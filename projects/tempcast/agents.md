# TempCast Agent Assignments

This file assigns global roles to TempCast. Role definitions and general
boundaries remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | TempCast Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Requirements, priorities, experiment direction, and final decisions |
| Claude | Product Designer and Frontend Architect | Forecast presentation, experiment workflows, design system, and frontend architecture |
| Codex | Senior Systems Engineer and Technical Architect | Data pipelines, forecasting integration, APIs, technical architecture, testing, deployment, and reliability |
| Gemini | Researcher | Current forecasting methods, package compatibility, TinyML research, datasets, UI references, and evaluation |
| Future Elysia | QC/PM | Milestone coordination, experiment quality gates, risk tracking, and release-readiness review |

## Project Boundaries

- Lystiger approves requirements and final architecture decisions.
- Claude defines implementation-ready experiment flows and frontend systems,
  while distinguishing experimental interfaces from production requirements.
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
