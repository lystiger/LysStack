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

## Open
- Where the pipeline's state lives and what LysControl shows. This waits for the P8 comparison.
