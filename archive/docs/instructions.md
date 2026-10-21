# Working With LysStack

This document defines how work is represented in LysStack, executed through
Hermes, and preserved as useful project knowledge.

## Sources of Truth

| Question | Source |
| --- | --- |
| What matters now? | `operating_system/current_focus.md` |
| What task is assigned? | `operating_system/active_task.md` |
| Who has standing responsibilities in a project? | `projects/<project>/agents.md` |
| What role should the agent follow? | `agents/<role>.md` |
| Who performs an assigned independent quality gate? | `agents/qc_pm.md` |
| How is the project designed? | `projects/<project>/architecture.md` |
| What limits the solution? | `projects/<project>/constraints.md` |
| What has already been decided? | `projects/<project>/decisions.md` |
| What failed or was learned? | `projects/<project>/lessons.md` |
| What knowledge applies across projects? | `memory/` |

`current_focus.md` is a priority overview. It does not authorize implementation
by itself. `active_task.md` is the source of truth for the current executable
assignment.

Project `agents.md` files map collaborators to global roles and define
project-specific focus. They do not replace global role definitions or assign
the current task.

## Project Structure

Each project uses this structure:

```text
projects/<project>/
├── agents.md
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
2. **Prepare:** Select bounded project context and pin the target repository
   base SHA in a Hermes sprint specification.
3. **Accept:** Hermes obtains `DRY_RUN_READY`, then changes the task status to
   `In progress` when real execution begins.
4. **Execute:** Hermes governs BUILDER, HARDENER, and VERIFIER phases within
   documented constraints and authority boundaries.
5. **Verify:** Hermes runs the deterministic commands listed in the task and
   records the results.
6. **Document:** Update relevant project decisions, lessons,
   architecture, or deployment documentation.
7. **Quality gate:** When QC/PM is assigned, it independently reviews scope,
   evidence, risks, documentation, and release readiness.
8. **Complete:** The task changes to `Complete` only after all acceptance
   criteria pass and any assigned quality gate is resolved.

Use `Blocked` when work cannot continue. Record the blocker, what was tried,
and the decision or resource needed to resume.

## Research Handoff

When research informs another agent's work, the Researcher should provide:

- The decision or missing project piece being investigated
- A dated findings summary with source links
- Current package versions and compatibility concerns when relevant
- Compared options, tradeoffs, risks, and a recommendation
- Suggested validation steps before adoption

The Researcher records findings in the relevant project documents, then hands
them to:

- The Product Designer and Frontend Architect for UI, UX, design-system, and
  template evaluation
- The Senior Systems Engineer and Technical Architect for packages,
  repositories, implementation approaches, and technical validation
- Lystiger for requirements, priorities, and final architecture decisions

Research recommendations do not authorize dependency changes, implementation,
or final design decisions.

## Quality Gate

Assign QC/PM when a task has meaningful release, data, security, integration,
operational, or cross-agent risk. Small low-risk tasks may complete without a
separate QC/PM review when Lystiger does not require one.

QC/PM provides a `Pass`, `Conditional pass`, or `Fail` recommendation with
evidence. A failed gate returns defects to the appropriate owner. Lystiger
retains final approval authority.

## Completion Protocol

Before marking an active task complete:

- Confirm every acceptance criterion
- Run the listed verification commands or explain why they could not run
- Resolve any assigned QC/PM quality gate and record its recommendation
- Record dated source links and version information for research-dependent work
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
