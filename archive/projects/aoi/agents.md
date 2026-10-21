# AOI Agent Assignments

This file assigns global roles to AOI. Role definitions and general boundaries
remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | AOI Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Requirements, priorities, system direction, and final decisions |
| Claude | Product Designer and Frontend Architect | Inspection workflows, operator experience, design system, and frontend architecture |
| Codex | Senior Systems Engineer and Technical Architect | Model integration, backend systems, APIs, technical architecture, testing, deployment, and reliability |
| Gemini | Researcher | Current computer-vision methods, package compatibility, datasets, evaluation, UI references, and external implementations |
| Future Elysia | QC/PM | Milestone coordination, inspection-system quality gates, risk tracking, and release-readiness review |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude defines implementation-ready operator workflows and frontend systems,
  then coordinates them with AOI technical constraints.
- Codex may propose architecture changes but escalates changes affecting
  project direction and does not approve its own implementation as the final
  quality gate.
- Gemini researches current methods, dependencies, datasets, design
  references, and external implementations; it records findings in the
  relevant project documents and does not own implementation.
- Future Elysia performs QC/PM duties only when assigned and gives
  release-readiness recommendations to Lystiger.

## Task Assignment

These assignments define standing responsibilities, not the current task.
Executable work and its owner are defined in
`operating_system/active_task.md`.
