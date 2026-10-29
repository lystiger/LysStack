# Hermes baseline eval — Design

**Owner:** Lystiger · **Date:** 2026-10-29 · **Status:** approved 2026-10-29

## Intent

Lystiger wants to say one sentence truthfully: **"Hermes catches bugs a single agent session ships."**
The job ledger shows the independent verifier catching real defects that passed every test (a cost-guard
bypass, failed Discord sends counted as successes, unsaved failure counters). That is anecdote. This eval
measures it: the same goals, from the same starting commits, given to one Claude Code session and to a
Hermes goal job, with hidden tests that count the bugs each one ships.

## Goals

- A number per arm: **shipped bugs per shipped run**, from hidden tests neither arm saw.
- Enough repeats (3 per task per arm) that one lucky run does not decide the result.
- A result Lystiger can defend in an interview, including when it is mixed or negative.

## Non-goals

- Ranking models. Arm A is one model in one session; Arm B is Hermes as it is configured today.
- Measuring cost precisely. Cost is recorded where a tool reports it and marked UNKNOWN elsewhere.
- Improving Hermes during the eval. Hermes stays at one pinned commit for all 24 Hermes runs.

## Anti-goals (a failure even if it runs)

- **Task selection that favours Hermes.** Replays are tasks Hermes already worked on; half the tasks are
  fresh so the result does not rest on them alone. At least one replay (task R4) is a bug Hermes shipped.
- **A system that wins by never shipping.** A blocked Hermes job ships nothing, so it cannot ship a bug.
  Completion rate is reported next to the bug rate, never left out.
- **Hidden tests that test what the goal did not ask.** A hidden test may only check behaviour the goal
  text or the repository's own instructions (AGENTS.md, skills) require.
- **Leaked hidden tests.** If any agent transcript touches the hidden tests, that run is void.

## Arms

| | Arm A: single session | Arm B: Hermes |
|---|---|---|
| Runner | `claude -p "<goal>"` headless, `--output-format json`, permissions bypassed, in a fresh clone | `POST /jobs/goal` to the eval's own Hermes instance (see Isolation), in a fresh clone |
| Launch settings | No subagents: `--disallowedTools Agent Task`. One agent, one session | The same for all 8 tasks: `antigravitySkipPermissions: true`, no `excludeAgents`, no `allowedCommands`, planner = API default (`claude-haiku-5-5`, medium). Original per-job overrides are not reused |
| Model | Claude Opus 5.5, default effort | `config/agent_models.json` as it is today (copied into the results, since it is gitignored): Claude Haiku 5.5 (low), Codex gpt-6.1-sol (low), Antigravity gemini-3.8-flash-high |
| Claude config | A clean `CLAUDE_CONFIG_DIR` holding only login credentials: no global CLAUDE.md (it tells Claude to hand work to Hermes), no plugins, no hooks | The same clean config for Hermes's Claude agents |
| Instructions | Goal text verbatim + "Run `./scripts/check` (or the repo's checks) before you finish." Repo AGENTS.md and skills as at the starting commit | Goal text verbatim. Repo AGENTS.md, skills and `hermes.json` as at the starting commit |
| Ships when | The session ends and says it finished | The job reaches `review_requested` or `completed` |
| Output scored | Final working tree of the clone | The job's integration branch |

Arm A uses the strongest Claude model on purpose: beating a strong single session makes the sentence
stronger. The comparison is "Hermes as Lystiger runs it" against "Claude Code as a developer would run it";
it does not separate the harness from the extra models. The write-up says so.

## Tasks (8)

### Replays (4)

Each starts from the vm-hunter commit that `main` was at when the job that produced the merged work
started. Goal text: verbatim from that job's `job.created` event.

Three of the four original jobs blocked: the verifier caught the bug before anything shipped. So the
replays test **catches**: would a single session have shipped a bug Hermes's verifier stopped? R4 is the
exception: Hermes shipped it.

| ID | Original job | Starting commit | Hidden tests check |
|---|---|---|---|
| R1 | Step 1, check environment (`run_20261023_181921_8a249caf`) | `871a208` + eval `hermes.json` commit | The workflow checker rejects an Oracle launch path that skips the cost guard |
| R2 | Forum-thread routing (`run_20261023_201042_160f5253`) | `175ca9c` | A failed Discord send ends the run as failed; counters persist across successful runs (what the skill at `175ca9c` asks; a failed run may lose its counter) |
| R3 | Step 3, offer watcher (`run_20261024_154936_a7d5bf57`; the earlier `1f6b0e28` died of a Hermes bug, E6) | `2b9da0e` | Real-format source headings (E7); the defects the verifier found in that job |
| R4 | Step 4, Oracle A1 claimer (`run_20261024_174103_d72ce714`) | `6415ca1` | Every Code node runs in the n8n sandbox without `new URL()` (E9: Hermes shipped this) |

R2 and R4 start where the successful job started, not the first attempt: the skill at `5e31df3` asked
for two things n8n cannot do together (E3), so a hidden test there would check an impossible requirement.

R1's commit predates `hermes.json`; since Hermes now fails closed without checks, the eval adds one
commit declaring `./scripts/check`, identically for both arms (as for AOI).

### Fresh (4)

New goals neither arm has seen, written in the same style as the replay goals.

| ID | Repository | Goal (summary) |
|---|---|---|
| F1 | vm-hunter (`main` today) | Roadmap step 6, monitoring: the 09:00 daily summary line per workflow and the immediate alerts from the `monitoring` skill |
| F2 | vm-hunter (`main` today) | A Telegram notification workflow alongside `notify-discord`, chosen per message by an environment variable |
| F3 | AOI (`main` today) | `GET /runs/{run_id}/defects.csv`: a CSV export of a run's defects that honours the same filters as `/defects` and includes review status |
| F4 | AOI (`main` today) | Offset pagination on `GET /runs`: `offset`, a `total` count, stable ordering, validation of bad values |

AOI has no `hermes.json` and no virtualenv today. The eval adds both to the AOI starting commit (one
commit, `pytest -q` as the check), identically for both arms, before any run.

## Hidden tests

- Written before any run, kept outside every repository and every clone, and stored encrypted between
  scoring passes (decrypted only by the scorer).
- **Replays must discriminate:** each hidden test fails on a buggy tree and passes on the merged fix.
  The buggy tree is the real one where it still exists (R4: `644cbc7`, fix `d523616`; R1: the pre-repair
  task branches, if their worktrees or run records survive). Otherwise it is a hand-written mutant of the
  merged code that reproduces the defect as the error log and verifier verdicts describe it. Which kind
  each test used is recorded. A test that does not discriminate is rewritten.
- **Fresh tests must be fair:** each hidden test cites the sentence of the goal or skill it checks.
- Lystiger reviews every hidden test before the pilot.
- Each hidden test belongs to one bug ID. A run's shipped bugs = the number of bug IDs with a failing test.

## Isolation

The eval runs its own Hermes instance from the pinned Hermes-lab commit, configured by environment only:
port 8100, `DATABASE_URL` pointing at a separate `hermes_eval` database in the same Postgres container,
`HERMES_GOAL_REPOS_ROOT=~/hermes-eval/repos`, `HERMES_LYSSTACK_ROOT` at a scratch copy. The real ledger,
`~/Projects` and LysStack's run log are untouched; the eval folder is deleted after the write-up except
the results.

## Running

- Each run gets a fresh clone of the target repository at the starting commit, with `main` reset to it
  and **the `origin` remote removed**, so nothing can push to GitHub or open a PR on the real repository.
- 8 tasks × 2 arms × 3 repeats = 48 runs. Arms and tasks are interleaved, 2–3 runs at a time, so time
  of day and provider load fall on both arms equally.
- Per-run limit: 45 minutes wall time. A run that hits it counts as not shipped.

## Scoring and results

Per run, recorded to one results file:

- shipped (yes/no) and, if shipped, the failing bug IDs;
- the repository's visible checks: pass/fail on the final tree;
- wall time; agent runs (Hermes); cost in USD where reported (`claude -p` JSON), else UNKNOWN;
- for Hermes: each verifier FAIL verdict, labelled by hand as **real** (the code had a hidden-test bug or
  a defect Lystiger confirms) or **noise**;
- leak check: void if any transcript reads the hidden-test location.

Headline table per arm: completion rate, shipped bugs per shipped run, runs that shipped zero bugs,
median wall time. Then the same per task, so a reader sees where each arm won and lost.

## Order

1. Freeze the 8 starting points, goal texts and the AOI check commit.
2. Write the hidden tests; prove each replay test discriminates; Lystiger reviews all of them.
3. Build the two runners and the scorer.
4. Pilot: R4 in both arms once. Proves the runners, the scorer and the leak check work.
5. The 48 runs.
6. Write-up in this folder, with the raw results file.

## Left to the builder

- Encryption tool for the hidden tests and the scorer's file layout.
- The exact wording of the four fresh goals, within the summaries above, in the replay goals' style.
- How the scorer extracts each arm's final tree.
