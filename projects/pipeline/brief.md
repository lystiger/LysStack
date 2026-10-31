# Pipeline — agents working like a company

**Status:** Draft (grill-me in progress)

## Goal
Agents take a change through every stage: spec, TDD, build, verify, CI, staging and prod. Each stage ends at a gate, and LysControl shows where each change is. Lystiger learns to write specs and make system decisions along the way.

## Decisions
| # | Decision | Source |
|---|---|---|
| P1 | Compare ways of working before choosing the runner. | Lystiger, round 1 |
| P2 | Staging prepares for prod on this machine. | Lystiger, round 1 |
| P3 | Lystiger writes specs and is coached, not handed a finished spec. | Lystiger, round 1 |
| P4 | Tiers: S = config/docs (build, CI, merge); M = feature (spec, TDD, build, harden, verify, CI, merge); L = user-facing/data/API (M + security + staging + Lystiger's deploy approval). The orchestrator picks the tier and Lystiger can override it. | Lystiger, round 1 |
| P5 | TDD is checked by machine for M and L: tests are committed first and must fail before the build starts. | Lystiger, round 1 |
| P6 | The verifier is never the agent that built the change; rotate codex, claude and agy by remaining quota. | Lystiger, round 1 |
| P7 | Agents commit, push and merge after the gates pass; production deploys need Lystiger. | Lystiger, 2026-10-26 |
| P8 | Compare A (one Claude loop + Codex verify) and B (six: orchestrator, roles, 6 panes). Hermes waits until its bugs are fixed. | Lystiger, round 2 |
| P9 | Test task: LysOmarchy roadmap step 3 (review pane `t`/`r` actions). Both methods start from the same commit, each in its own worktree. | Lystiger, round 2 |
| P10 | Measures: wall-clock time, Lystiger interventions, defects found after "done", quota used, real catches by the verifier. | Lystiger, round 2 |
| P11 | LysOmarchy staging: `install.py --home <temp dir>` plus the test suite and config checks. Prod: the real install. | Lystiger, round 2 |
| P12 | Lystiger writes the step 3 spec (Google design doc sections); I grill it; both methods build from it. | Lystiger, round 2 |
| P13 | The review unit is commits on an agent's branch, not uncommitted files. Agents commit in their own worktrees (tests first, then code); the orchestrator integrates one passed branch at a time. Uncommitted work can be read but never counts as passed. | Lystiger, 2026-10-31 |
| P14 | A `dev` branch exists only on projects where staging needs it. Other projects integrate into `main` through PRs. | Lystiger, 2026-10-31 |
| P15 | Agents run the tests, called by the orchestrator. Starting, cancelling and restarting a run belong to the orchestrator. | Lystiger, 2026-10-31 |
| P16 | The review pane has no `t` or `r` keys: they overlap with what the pane already shows and with the agents' jobs. The pane only displays saved results. Replaces the actions in LysOmarchy roadmap step 3. | Lystiger, 2026-10-31 |
| P17 | The test agent calls one script that enforces the 10-minute limit, kills a hung run and saves the result with the commit SHA. | Lystiger, 2026-10-31 |
| P18 | The test agent runs the branch's related tests; the full suite runs at integration. | Lystiger, 2026-10-31 |
| P19 | The A-vs-B test task (replaces P9's step 3) is the test script from P17. | Lystiger, 2026-10-31 |
| P20 | The review pane shows one list of all agent worktrees; selecting one shows its detail. | Lystiger, 2026-10-31 |
| P21 | The pipeline, including the test script, works on any project, not only LysOmarchy. The orchestrator passes the worktree and base to the script; both are required. | Lystiger, 2026-10-31 |
| P22 | Each repo provides one test command that receives the changed files and runs its related tests. With no command, the script runs nothing and saves `no-config`, and the orchestrator checks in with Lystiger. | Lystiger, 2026-10-31 |
| P23 | The test result holds status, commit SHA, base, started, finished, the last 200 or so lines of output, and the path to the full log. It lives in `$(git rev-parse --git-dir)/review/`, and the pane no longer shows a test count. | Lystiger, 2026-10-31 |
| P24 | Statuses: `passed`, `failed`, `running`, `hung`, `no-config`, `no-tests`, `dirty`. Only `passed` counts as passed, except `no-tests` when the branch changed only docs, which the orchestrator lets continue; other `no-tests` go back to the builder. `dirty` refuses without running. The repo's command exits 0 for pass, 5 for no related tests, and anything else for fail. A bad path or base saves nothing and exits non-zero. | Lystiger, 2026-10-31 |
| P25 | Time limit: 10 minutes by default, with a per-repo override. AI, heavy-compute or heavy-load work can get a longer limit, set in the job's requirements and spec before the orchestrator starts the test. At the limit the script stops the whole process group (`SIGTERM`, then `SIGKILL` after 10 seconds), saves `hung` and keeps the log. The result stores the limit, and readers treat `running` as `hung` once `started` is older than the limit plus a margin. The limit comes from the job's spec, then the repo setting, then the 10-minute default, with a hard cap of 60 minutes. | Lystiger, 2026-10-31 |
| P26 | Replaces P3 and P12's drafting: Lystiger makes the decisions, compares trade-offs and gets technical terms explained; Claude writes the spec from those decisions and flags anything undecided. | Lystiger, 2026-10-31 |
| P27 | The script is `pipeline-test`, kept in LysOmarchy and installed to `~/.local/bin`. A repo's `.pipeline.toml` declares its test command and limit, and the command reads changed files from stdin. A `--limit` above 60 is an error. The stale `running` margin is 1 minute. Untracked files not ignored by git count as `dirty`. | Lystiger, 2026-10-31 |
| P28 | `pipeline-test` takes a `flock`, so a second run on a worktree exits with an error. If `HEAD` moves during a run, it saves `stale`, which doesn't count as passed. | Lystiger, 2026-10-31 |

## Open
- Where the pipeline's state lives and what LysControl shows. This waits for the P8 comparison.
