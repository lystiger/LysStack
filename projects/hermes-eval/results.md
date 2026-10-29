# Hermes baseline eval — results (pilot scale: 16 runs)

Run 2026-10-29. One repeat per task per arm (n=1 per cell), not the designed 3. Raw rows: `results.jsonl`.

| Arm | Runs | Void | Unscored | Completion | Shipped bugs per shipped run | Zero-bug shipped runs | Median wall | Cost |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| A: single session | 8 | 0 | 0 | 100% | 0.75 | 6 | 2.7 min | $10.18 |
| B: Hermes | 7 | 3 | 0 | 71% | 0.00 | 5 | 36.5 min | UNKNOWN |

Per task: shipped/runs, shipped bugs.

| Task | A: single session | B: Hermes |
|---|---|---|
| F1 | 1/1, 0 bugs | 1/1, 0 bugs |
| F2 | 1/1, 0 bugs | 1/1, 0 bugs |
| F3 | 1/1, 0 bugs | - |
| F4 | 1/1, 0 bugs | 1/1, 0 bugs |
| R1 | 1/1, 1 bugs | 1/1, 0 bugs |
| R2 | 1/1, 5 bugs | 0/1, 0 bugs |
| R3 | 1/1, 0 bugs | 1/1, 0 bugs |
| R4 | 1/1, 0 bugs | 0/1, 0 bugs |

## What it shows, and what it does not

- The single session shipped every task (8/8), fastest by far (median 2.7 min), and shipped 6 hidden-test
  bugs, all on R1 (1: R1CYCLE) and R2 (5). Those are the two replays where the original Hermes jobs'
  verifier caught bugs before anything merged. R2-A changed 9 files, reported "`./scripts/check` passes",
  and still failed 5 hidden bug IDs.
- Hermes shipped 5 of 7 valid runs with 0 hidden-test bugs. Two runs (R2, R4) hit the 45-minute limit;
  R4-B's unfinished tree still has R4URL, the bug Hermes shipped in the original job.
- On R1 the Hermes verifier again reported "a cost-guard bypass" with every declared check passing — the
  same catch as the original job.
- n=1 per cell: one lucky or unlucky run changes a cell. The direction is consistent with the ledger
  stories; the size is not established.

## Verifier FAIL verdicts (to label real / noise by hand)

| Run | Verdict | Label |
|---|---|---|
| R1-B-1 | All declared checks pass, but an independent probe found a cost-guard bypass. | |
| R4-B-1 | Checks pass, but independent audit found unmet safety and monitoring requirements. | |

## Void runs

- R3-B-1: read another run's clone (R3-A-1's fixtures). Retried as R3-B-1-r (valid).
- F3-B-1 and F3-B-1-r: Antigravity listed and explored the eval folders (`ls -la ~/hermes-eval/tasks/F3`)
  but read no task file. Void by rule twice, so F3 has no Hermes result.
- Finding: headless Antigravity with permissions skipped explores the filesystem outside its worktree.

## Harness problems found and fixed during the run

- Hermes reports branch `hermes/<job>/integration` but creates `job/<job>/integration`; the first scoring
  of Hermes runs used the starting commit. Rescored.
- Three single-session runs hit the Claude session limit and did no work; discarded and rerun. A quota
  message now stops the eval instead of recording a result.
- Hermes cost summed only Claude's priced rows; it is now UNKNOWN when any agent run is unpriced.

## Caveats (from the design)

- Arm A is one strong model in one session; Arm B is Hermes as configured (Haiku, Codex, Antigravity).
  The comparison does not separate the harness from the extra models.
- Replays are tasks Hermes worked on before; fresh tasks F1–F4 shipped 0 bugs in both arms.
- Cost for Hermes is unknown; wall time is the only comparable cost.
