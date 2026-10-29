# Hermes Baseline Eval Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run 8 tasks × 2 arms × 3 repeats and count, with hidden tests, the bugs each arm ships.

**Architecture:** A small local harness (`~/hermes-eval`, Python stdlib + pytest, its own Git repo with
no remote) prepares a fresh clone per run, runs Arm A (`claude -p`) or Arm B (a separate Hermes
instance on port 8100), then scores the run's output against hidden tests that live encrypted outside
every clone. Results go to one JSONL file; a report script builds the tables.

**Tech Stack:** Python 3.14 stdlib, pytest, git, gpg (symmetric), curl-free `urllib`, Docker/Postgres
(existing `hermes_postgres` container), Hermes-lab pinned at `1e50811`.

**Spec:** `~/Projects/LysStack/projects/hermes-eval/design.md`

**Why not on Hermes:** the harness and hidden tests must stay unseen by the agents being measured, and
Hermes agents can read the home directory. It is built inline.

## Global Constraints

- 8 tasks: R1–R4 (vm-hunter replays), F1–F2 (vm-hunter fresh), F3–F4 (AOI fresh). 2 arms × 3 repeats = 48 runs.
- Starting commits: R1 `871a208` + eval `hermes.json` commit; R2 `175ca9c`; R3 `2b9da0e`; R4 `6415ca1`; F1–F2 vm-hunter `main` at freeze; F3–F4 AOI `main` at freeze + eval commit adding `hermes.json` (`pytest -q`).
- Goal text for replays: verbatim `goal` of `job.created` for R1 `run_20261023_181921_8a249caf`, R2 `run_20261023_201042_160f5253`, R3 `run_20261024_154936_a7d5bf57`, R4 `run_20261024_174103_d72ce714`.
- Arm A: `claude -p --model claude-opus-5-5 --dangerously-skip-permissions --disallowedTools Agent Task --output-format stream-json --verbose`, with a clean `CLAUDE_CONFIG_DIR` holding only `.credentials.json`. Goal text + the sentence "Run the repository's checks (`./scripts/check` if it exists) before you finish."
- Arm B: `POST http://localhost:8100/jobs/goal` with `antigravitySkipPermissions: true`, no `excludeAgents`, no `allowedCommands`, default planner (`claude-haiku-5-5`, medium). Same clean `CLAUDE_CONFIG_DIR`.
- Eval Hermes env: `DATABASE_URL=postgresql://postgres:postgres@localhost:5433/hermes_eval`, `HERMES_GOAL_REPOS_ROOT=~/hermes-eval-repos`, `HERMES_LYSSTACK_ROOT=~/hermes-eval/lysstack-scratch`, `HERMES_AUTO_PR=0`, port 8100.
- Every clone: `main` at the starting commit, `origin` removed. Nothing may push or open a PR.
- Per-run limit: 45 minutes wall time; over the limit = not shipped. Concurrency: at most 3 runs, at most 2 of them Hermes.
- Hidden tests: plaintext only inside a scorer temp dir, deleted after each scoring pass; at rest `~/.local/share/hev/hidden.tar.gz.gpg`, key `~/.config/hev/key` (mode 600). Test function names start `test_<BUGID>__`.
- A run is void if its transcript (Arm A stream-json; Arm B `~/hermes-runs/<job_id>/`) contains `hev` path segments, `hidden.tar`, or `hermes-eval/hidden`.

## Review Focus

- A Hermes job that blocks mid-way still leaves an integration branch: it must score as **not shipped**, while its tree is still scored and recorded separately (`tree_bugs`), never counted in the headline.
- A clone where Arm A changed nothing: it ships (session ended), and the hidden tests run on the starting code; expected bugs = every bug ID. Test it.
- A hidden test that errors at import (arm renamed a file the goal did not name) counts as a failing bug, but the scorer must record `error` vs `fail` so Lystiger can see unfair tests.
- Re-running the orchestrator after a crash must skip runs already in `results.jsonl` and never start a duplicate Hermes job for the same run ID.
- The eval Hermes instance on 8100 and the real one on 8000 must not share a database: the stack script refuses to start if `DATABASE_URL` ends in `/hermes_lab`.

---

### Task 1: Harness skeleton, task specs, clone preparation

**Files:**
- Create: `~/hermes-eval/hev/tasks.py`, `~/hermes-eval/hev/prepare.py`, `~/hermes-eval/tasks/<ID>/task.json`, `~/hermes-eval/tasks/<ID>/goal.md`, `~/hermes-eval/tasks/<ID>/setup.patch` (only R1, F3, F4)
- Test: `~/hermes-eval/tests/test_prepare.py`

**Interfaces:**
- Produces: `Task` dataclass `(id: str, repo: Path, base: str, goal: str, setup_patch: Path | None, venv: str)` where `venv` is `"vm-hunter"` or `"aoi"`; `load_tasks() -> dict[str, Task]`; `prepare_clone(task: Task, run_id: str, root: Path) -> Path` (returns the clone, `main` at base + setup commit, no `origin`, `.venv` built).

- [ ] **Step 1: Write failing tests** — `test_clone_has_no_origin`, `test_main_is_at_base_plus_setup` (for a task with a patch: `git rev-list --count base..main == 1`), `test_clone_is_independent_of_source` (a commit in the clone does not appear in the source repo), using a tiny temporary source repo.
- [ ] **Step 2: Run** `cd ~/hermes-eval && python -m pytest tests/test_prepare.py -q` — expect FAIL (module missing).
- [ ] **Step 3: Implement** `prepare_clone` with `git clone --no-local`, `git checkout -B main <base>`, `git remote remove origin`, `git am` the setup patch, and the venv: vm-hunter `python -m venv .venv && .venv/bin/pip install pytest`; AOI `.venv/bin/pip install -e .[test]`.
- [ ] **Step 4: Write the 8 `task.json` files and the 4 replay `goal.md` files** (goal text pulled from the ledger with `psql`), plus `setup.patch` for R1 (`hermes.json` declaring `./scripts/check`) and AOI (`hermes.json` declaring `.venv/bin/python -m pytest -q`). F1–F4 `goal.md` are written in Task 7.
- [ ] **Step 5: Run** the tests — expect PASS; then `python -c "from hev.tasks import load_tasks; print(sorted(load_tasks()))"` prints the 8 IDs.
- [ ] **Step 6: Commit** (`git init` first; never add a remote).

### Task 2: The eval Hermes instance

**Files:**
- Create: `~/hermes-eval/bin/eval-hermes` (bash: `start | stop | status`), `~/hermes-eval/claude-config/` (only `.credentials.json`, copied, mode 600)

**Interfaces:**
- Produces: a Hermes API on `http://localhost:8100` from the pinned worktree `~/hermes-eval/hermes` (`git -C ~/Projects/Hermes-lab worktree add ~/hermes-eval/hermes 1e50811`, with `config/agent_models.json` copied in and its copy saved to `~/hermes-eval/results/agent_models.json`).

- [ ] **Step 1:** Create the `hermes_eval` database and run `alembic upgrade head` against it from the pinned worktree.
- [ ] **Step 2:** Write `eval-hermes start` with the Global Constraints env, refusing if `DATABASE_URL` ends in `/hermes_lab`. Run `bash -n bin/eval-hermes`.
- [ ] **Step 3: Verify:** `bin/eval-hermes start && curl -fs localhost:8100/health`; then a dry-run goal job (`dryRun: true`) on a scratch clone in `~/hermes-eval-repos` reaches `completed`; then `psql ... -d hermes_lab -c "select count(*) from runtime_events where job_id = '<that id>'"` returns 0.
- [ ] **Step 4: Commit.**

### Task 3: Arm A runner

**Files:**
- Create: `~/hermes-eval/hev/arm_a.py`
- Test: `~/hermes-eval/tests/test_arm_a.py`

**Interfaces:**
- Consumes: `Task`, `prepare_clone`.
- Produces: `run_arm_a(task: Task, clone: Path, out_dir: Path, timeout_s: int = 2700) -> RunRecord`; `RunRecord` dataclass `(run_id, task_id, arm, shipped: bool, wall_s: float, cost_usd: float | None, output_ref: str, transcript: Path, verifier_fails: list[str], note: str)` in `hev/records.py`. For Arm A, `output_ref` is a commit made by the harness from the final working tree (`git add -A && git commit`), so uncommitted work is scored too.

- [ ] **Step 1: Write failing tests** with `claude` replaced by a stub script on `PATH`: `test_command_line_matches_constraints` (asserts the exact flags in Global Constraints), `test_timeout_marks_not_shipped`, `test_final_tree_is_committed_for_scoring`, `test_cost_read_from_result_event`.
- [ ] **Step 2: Run** — expect FAIL. **Step 3: Implement.** **Step 4: Run** — expect PASS. **Step 5: Commit.**

### Task 4: Arm B runner

**Files:**
- Create: `~/hermes-eval/hev/arm_b.py`
- Test: `~/hermes-eval/tests/test_arm_b.py`

**Interfaces:**
- Consumes: `Task`, `prepare_clone`, `RunRecord`.
- Produces: `run_arm_b(task: Task, clone: Path, out_dir: Path, api: str = "http://localhost:8100", timeout_s: int = 2700) -> RunRecord`. `shipped` is true only for job state `review_requested` or `completed`. `output_ref` = `job/<job_id>/integration` if it exists, else the starting commit. `cost_usd` = sum of `cost_usd` in `~/hermes-runs/<job_id>/usage.jsonl` (None if absent). `verifier_fails` = the `error` of every `agent.failed` event for a task whose role is `verifier`, read from the `hermes_eval` ledger (Arm A: always empty). On timeout it cancels the job via the API.

- [ ] **Step 1: Write failing tests** against a fake HTTP server (stdlib `http.server`): `test_payload_matches_constraints`, `test_blocked_job_is_not_shipped_but_tree_recorded`, `test_timeout_cancels_job`, `test_usage_cost_summed`, `test_verifier_fail_verdicts_recorded`.
- [ ] **Step 2–5:** Run (FAIL), implement, run (PASS), commit.

### Task 5: Hidden-test store, scorer, leak check

**Files:**
- Create: `~/hermes-eval/hev/hidden.py`, `~/hermes-eval/hev/score.py`
- Test: `~/hermes-eval/tests/test_score.py`

**Interfaces:**
- Produces: `seal(src: Path) -> None` (tar + `gpg --symmetric --batch --passphrase-file ~/.config/hev/key`, then deletes `src`); `unsealed() -> ContextManager[Path]` (decrypts to a `tempfile.mkdtemp`, deletes on exit); `score(record: RunRecord, task: Task, clone: Path) -> dict` returning the results row: record fields + `bugs: list[str]`, `errors: list[str]`, `tree_bugs: list[str]`, `visible_checks_pass: bool`, `void: bool`. Hidden tests for task `<ID>` live at `<unsealed>/<ID>/` and are copied into a scratch checkout of `output_ref` as `tests/_hidden/`, run with that clone's `.venv`; bug IDs come from the `test_<BUGID>__` prefix.

- [ ] **Step 1: Write failing tests:** `test_failing_hidden_test_maps_to_bug_id`, `test_import_error_recorded_as_error_and_bug`, `test_not_shipped_run_has_no_bugs_but_tree_bugs`, `test_plaintext_removed_after_scoring`, `test_transcript_mentioning_store_is_void`.
- [ ] **Step 2–5:** Run (FAIL), implement, run (PASS), commit.

### Task 6: Hidden tests for R1–R4

**Files:**
- Create (then sealed): `hidden-src/R1..R4/test_*.py`; `~/hermes-eval/tasks/<ID>/hidden-manifest.md` (per bug ID: what it checks, the goal or skill sentence it cites, the buggy tree, the fixed tree)

**Rules:** test only interfaces the goal text or the skills at the starting commit name (file paths, workflow file names, node names, env vars, CLI). Prefer behaviour over structure; where structure is all the goal fixes (R4: no `URL` global in any Code node's `jsCode`), test that.

- [ ] **Step 1: Find the buggy trees.** R4: `644cbc7` (bug), `d523616` (fix). R1: the pre-repair integration commit in `~/hermes-worktrees/run_20261023_181921_8a249caf/` (fix: PR #1 merge `c9ef916`). R2, R3: the job's task branches if they survive; otherwise hand-written mutants of the merged code (R2 fix: PR #3 merge `2b9da0e`; R3 fix: PR #4 merge `3ee6eba`), each a `.patch` recorded in the manifest.
- [ ] **Step 2: Write the tests** per the design's table.
- [ ] **Step 3: Prove discrimination:** `python -m hev.discriminate R1` (thin script over `score`'s runner) reports every bug ID failing on the buggy tree and passing on the fixed tree. Expected: `R1: discriminates (1/1)` etc. Fix tests until all four do.
- [ ] **Step 4:** `seal`, commit the manifests (not the tests).

### Task 7: Fresh goals F1–F4, reference solutions, hidden tests

**Files:**
- Create: `~/hermes-eval/tasks/F1..F4/goal.md`; `hidden-src/F1..F4/test_*.py`; reference solutions as `~/hermes-eval/tasks/<ID>/reference.patch`; manifests as in Task 6

- [ ] **Step 1: Write the four goals** in the replay goals' style, from the design's summaries. Each names every interface a hidden test will use.
- [ ] **Step 2: Write the reference solution** for each on its starting commit; the repo's visible checks pass on it.
- [ ] **Step 3: Write hidden tests** (2–4 bug IDs per task, each citing its goal sentence). Each must fail on the starting commit and pass on the reference: `python -m hev.discriminate F1` etc.
- [ ] **Step 4:** `seal`, commit goals and manifests (not tests or reference patches: the patches are sealed with the tests).

### Task 8: Orchestrator and report

**Files:**
- Create: `~/hermes-eval/hev/orchestrate.py`, `~/hermes-eval/hev/report.py`
- Test: `~/hermes-eval/tests/test_orchestrate.py`

**Interfaces:**
- Produces: `python -m hev.orchestrate [--only R4] [--repeats 1]` (run IDs `<TASK>-<A|B>-<n>`, interleaved order, concurrency per Global Constraints, appends to `results/results.jsonl`, skips IDs already present); `python -m hev.report` prints the headline table (per arm: completion rate, shipped bugs per shipped run, zero-bug shipped runs, median wall time, total cost) and the per-task table, and writes `results/report.md`.

- [ ] **Step 1: Write failing tests:** `test_order_interleaves_arms_and_tasks`, `test_resume_skips_finished_runs`, `test_at_most_two_hermes_runs_at_once`, `test_report_excludes_void_runs_and_counts_them`.
- [ ] **Step 2–5:** Run (FAIL), implement, run (PASS), commit.

### Task 9: Review gate, pilot, full run

- [ ] **Step 1: Lystiger reviews** every hidden test and manifest (unsealed in a temp dir for the review, resealed after). No run before approval.
- [ ] **Step 2: Pilot:** `python -m hev.orchestrate --only R4 --repeats 1`. Expected: 2 rows in `results.jsonl`, neither void, scorer output for both; check the Arm B job never touched `hermes_lab` (Task 2 Step 3 query).
- [ ] **Step 3: Full run:** `python -m hev.orchestrate` until 48 non-void rows exist (void runs are re-run once and reported).
- [ ] **Step 4: Report:** `python -m hev.report`; write `~/Projects/LysStack/projects/hermes-eval/results.md` with the tables, the verifier-FAIL real/noise labels, the caveats from the design, and the raw `results.jsonl` copied alongside.
