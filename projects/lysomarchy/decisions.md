# LysOmarchy — Decisions

## 2026-10-26 — WS5 review workspace (brief draft)

| # | Decision | Why |
|---|---|---|
| D1 | The panel is a terminal layout: lazygit with delta on the left, a `lysomarchy-review` pane on the right, both foot windows on WS5. | Lystiger's choice over a Quickshell window or a LysControl page: fastest to build, reuses installed tools, keyboard-driven. |
| D2 | The WHY line for each file comes from `.review/notes.md` (`path — why`), written by the agent that made the change. The Claude Stop hook requires a note per changed file. Files without one show `(no note)`. | Lystiger's choice: free and accurate, since the author knows the reason. |
| D3 | The pane shows the workflow strip, test results and a cross-agent review. No plan-file section. | Lystiger's selection. |
| D4 | `.review/` holds per-change state (`notes.md`, `tests.json`, `review.json`) and is git-ignored. | Working state for one change, not history. |
| D5 | The review button runs Codex only; Claude can be added later. | A reviewer other than the author; one reviewer keeps the first version small. |
| D6 | Antigravity takes part in the Hermes jobs, with an `allowedCommands` list (read-only inspection, `bash -n`, `python3 -m unittest`) in plain and `rtk` form. | Lystiger's choice; vm-hunter E6 shows headless Antigravity fails every command that is not listed. |

## Open questions

See the grill round in the drafting conversation; settled answers move into the table above.
