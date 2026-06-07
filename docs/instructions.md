# Working With LysStack

This document defines how agents receive work, execute it, and preserve useful
project knowledge.

## Sources of Truth

| Question | Source |
| --- | --- |
| What matters now? | `operating_system/current_focus.md` |
| What task is assigned? | `operating_system/active_task.md` |
| What role should the agent follow? | `agents/<role>.md` |
| How is the project designed? | `projects/<project>/architecture.md` |
| What limits the solution? | `projects/<project>/constraints.md` |
| What has already been decided? | `projects/<project>/decisions.md` |
| What failed or was learned? | `projects/<project>/lessons.md` |
| What knowledge applies across projects? | `memory/` |

`current_focus.md` is a priority overview. It does not authorize implementation
by itself. `active_task.md` is the source of truth for the current executable
assignment.

## Project Structure

Each project uses this structure:

```text
projects/<project>/
├── architecture.md
├── roadmap.md
├── constraints.md
├── decisions.md
├── dataset.md
├── deployment.md
└── lessons.md
```

## Task Lifecycle

1. **Define:** Lystiger or an authorized coordinator fills in
   `operating_system/active_task.md`.
2. **Accept:** The assigned agent confirms that the task is actionable and
   changes its status to `In progress`.
3. **Execute:** The agent performs the work within the documented constraints
   and authority boundaries.
4. **Verify:** The agent runs the commands or checks listed in the task and
   records the results.
5. **Document:** The agent updates relevant project decisions, lessons,
   architecture, or deployment documentation.
6. **Complete:** The agent changes the task status to `Complete` only after all
   acceptance criteria pass.

Use `Blocked` when work cannot continue. Record the blocker, what was tried,
and the decision or resource needed to resume.

## Completion Protocol

Before marking an active task complete:

- Confirm every acceptance criterion
- Run the listed verification commands or explain why they could not run
- Record significant technical decisions in the project's `decisions.md`
- Record reusable project-specific lessons in the project's `lessons.md`
- Promote cross-project knowledge to `memory/` when appropriate
- Update architecture, constraints, dataset, or deployment documents if the
  work changed them
- Add a concise completion summary and verification results to
  `active_task.md`
- Update `current_focus.md` if project priorities or blockers changed

## Decision Record

Record decisions in the relevant project's `decisions.md`. Use
`memory/decisions.md` only for repository-wide decisions.

```markdown
### Decision 001: Title

- **Date:** YYYY-MM-DD
- **Problem:** What needs to be decided?
- **Decision:** What was selected?
- **Reason:** Why was it selected?
- **Rejected:** What alternatives were rejected?
- **Status:** Proposed, accepted, superseded, or rejected
```

Do not record routine implementation details as decisions. Record choices that
affect architecture, constraints, future work, or meaningful tradeoffs.
