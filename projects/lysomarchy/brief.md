# LysOmarchy WS5 Review — Brief

**Owner:** Lystiger · **Built by:** Hermes (goal-planned jobs) · **Status:** Draft · **Drafted:** 2026-10-26
**Repository:** `lystiger/LysOmarchy` (`~/Projects/LysOmarchy`)

## What it is

A review workspace on WS5 (FOCUS) that answers three questions about the change in a repository:
what changed, why, and is it safe to ship. Two foot windows side by side:

- **Left:** `lazygit`, with `delta` rendering the diffs.
- **Right:** `lysomarchy-review`, a terminal pane that redraws when the repository changes:

```text
WORKFLOW   tests written ✓ · tests pass ✓ · reviewed ○ · committed ○ · CI ● passed
WHY
  plugins/lysomarchy.ci/CiModel.js   gh JSON → bar state; rejects option-like repo names
  README.md                          (no note)
TESTS      43 ok · 12s · 2 min ago            [t] rerun
REVIEW     Codex: 2 findings                  [r] run review
  CiModel.js:32  low: branch regex allows "..". Use git check-ref-format.
```

## Why

Agents change code faster than Lystiger reads it. The panel puts the diff, the agent's reason for each
file, the test result and an independent review in one place before a commit, so a change is read
before it ships rather than after CI fails.

## Success

- Super+Shift+R opens both windows on WS5 for the repository of the focused window (or the last one used).
- Every changed file appears under WHY, with the agent's note or `(no note)`.
- `t` runs the related tests and shows count, time and the exact failing assertion.
- `r` runs a Codex review of the current diff; the review is marked stale once the diff changes.
- The WORKFLOW strip is computed from git and saved results, never typed by hand.
- Every part has tests in `tests/`, and the repository suite stays green in CI.

## Out of scope

- A Quickshell or web version of the panel (decided: terminal, D1).
- Generating explanations with a model when a note is missing (decided: agent notes, D2).
- Committing, pushing or merging from the panel; it only reads, runs tests and runs a review.
- A plan-file section (not chosen, D3).

## Context

- Repository rules: `agents/rules.md`; tests: `python3 -m unittest discover -s tests`.
- Existing pieces to reuse: the related-test selection in `.githooks/pre-commit`, the source/test rule in
  `.claude/hooks/require-tests`, the CI call in `plugins/lysomarchy.ci/CiModel.js`.
- Decisions: `decisions.md` in this folder. Steps: `roadmap.md`.
