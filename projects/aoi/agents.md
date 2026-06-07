# AOI Agent Assignments

This file assigns global roles to AOI. Role definitions and general boundaries
remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | AOI Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Requirements, priorities, system direction, and final decisions |
| Claude | Designer | Inspection workflows, operator experience, and frontend architecture |
| Codex | Engineer | Model integration, backend systems, testing, deployment, and maintenance |
| Gemini | Researcher | Current computer-vision methods, package compatibility, datasets, evaluation, UI references, and external implementations |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude coordinates frontend decisions with AOI technical constraints.
- Codex may propose architecture changes but escalates changes affecting
  project direction.
- Gemini researches current methods, dependencies, datasets, design
  references, and external implementations; it records findings in the
  relevant project documents and does not own implementation.

## Task Assignment

These assignments define standing responsibilities, not the current task.
Executable work and its owner are defined in
`operating_system/active_task.md`.
