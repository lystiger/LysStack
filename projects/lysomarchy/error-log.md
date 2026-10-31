# LysOmarchy — Hermes Error Log

### E1 — Antigravity allow rules are prefixes, and rtk rewrites first; every command was denied · fixed

- **When:** 2026-10-26, job `run_20261026_084017_69758c4c` (roadmap step 1, review pane).
- **What:** `t1_write_tests` (builder, antigravity) ended `FAILED_NO_CHANGES` four times; its first
  command `ls -la tests session` was auto-denied each time, and the job blocked on the replan limit.
- **Cause:** two things, tested directly against `agy` with Hermes's `scoped_antigravity_permissions`:
  1. The rtk PreToolUse hook rewrites `ls -la tests session` to `rtk ls -la tests session` before
     Antigravity checks the allow rules, so only the `rtk` form can match.
  2. `command(...)` rules match by prefix and treat `*` literally: `rtk ls` allows the command,
     `rtk ls *` and `rtk *` do not. The job listed only `*` forms.
- **Fix:** relaunched as `run_20261026_084524_d49cd638` with plain prefixes, each in plain and `rtk`
  form. Rule recorded in LysOmarchy `agents/rules.md`.
- **Hermes fix wanted (same as vm-hunter E6):** move a task to another agent when its run reports
  denied commands, instead of replanning it onto the same agent.

### E3 — The goal pointed at the LysStack brief, outside the worktree; Antigravity's read was denied · fixed

- **When:** 2026-10-26, job `run_20261026_084524_d49cd638`.
- **What:** with E1 fixed, commands ran, but `write_review_tests` ended `FAILED_NO_CHANGES` four times on a
  denied `read_file`: the goal named `~/Projects/LysStack/projects/lysomarchy/brief.md`, and Hermes grants
  Antigravity reads only inside the worktree and the target's `.git`.
- **Fix:** relaunched with the pointer removed; the goal already carried the full spec. Lesson: a goal
  must be self-contained, or name only files inside the target repository.

### E4 — Antigravity aborts on its first unlisted command, and the job still reported COMPLETED · open

- **When:** 2026-10-26, job `run_20261026_085212_849ae887`.
- **What:** all three Antigravity tasks ended on one denied command each: `rg`, `rtk recall`, `rtk bypass`
  (rtk's own recovery commands, which the global RTK.md tells agents to use), and a compound
  `python3 -m unittest ... && bash -n ...`. Headless Antigravity stops the whole turn on a denial, so no
  file was written. The integration branch equals `main`.
- **Why it passed:** the planner tagged all four tasks `hardener`, so the builder `FAILED_NO_CHANGES` check
  never ran, and with no `builder` task the independent-verifier rule (E2) had no one to skip; Antigravity
  verified again.
- **Lesson:** an allowlist cannot predict an agent's exploration. Hermes fixes wanted: a job whose builder
  work produced no diff must not end COMPLETED, and roles should not depend on the planner's labels alone.

### E2 — The planner ignores agent preferences in the goal; Antigravity verified its own build · fixed

- **When:** 2026-10-26, dry runs `run_20261026_083051_a382b24b` and `run_20261026_083521_d779e814`.
- **What:** the verifier task went to Antigravity, which also built, even with a constraint asking for
  Codex. Antigravity's default capabilities are a superset of Codex's, so it ranks first everywhere.
- **Fix:** Hermes-lab `9f4b539` on branch `feat/independent-verifier`: a verifier task skips agents that
  built in the same job when another capable agent exists. Dry run `run_20261026_083930_7fdb0ee9`
  then planned Codex as verifier.

### E5 — Job 1 built with all three agents; Codex caught a missing section · fixed inline

- **When:** 2026-10-26, job `run_20261026_091623_4b7519df`, with `antigravitySkipPermissions` (Hermes-lab `db0f807`).
- **What:** Antigravity wrote the tests (one retry after the pre-commit hook failed them), Claude built the
  script and `.gitignore` and reviewed, and Codex verified independently and failed the job: the pane
  printed the per-file lines inside WORKFLOW, with no WHY heading. The job ended BLOCKED.
- **Fix:** one-commit inline fix with a heading-order test (`b545b7d`), PR lystiger/LysOmarchy#1.
- **E4 status:** the no-diff COMPLETED bug in Hermes is still open.

### E6 — The pre-commit hook let a test commit into the job's worktree, deleting almost every file · fixed

- **When:** 2026-10-26, job `run_20261026_104709_66bce656` (roadmap step 2, notes required).
- **What:** the job branch got a commit `start` (`7a0a99c`) holding only `tests/test_dev_hooks.py`'s fixture
  files. Codex then failed verification: notes parsing differs from `note_for()` (the hook also reads a
  final line without a newline), and 1 environment error in 195 tests. The job ended BLOCKED.
- **Cause:** in a linked worktree git gives hooks absolute `GIT_DIR` and `GIT_INDEX_FILE`; `.githooks/pre-commit`
  passed them to the tests, whose own `git add`/`commit` then hit the worktree. Reproduced by hand.
- **Fix:** PR lystiger/LysOmarchy#2 runs the tests with those variables unset, plus a regression test.
