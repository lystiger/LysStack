# SignGlove Agent Assignments

This file assigns global roles to SignGlove. Role definitions and general
boundaries remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | SignGlove Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Requirements, priorities, system direction, and final decisions |
| Claude | Product Designer and Frontend Architect | Interaction design, user flows, accessibility, design system, and frontend architecture |
| Codex | Senior Systems Engineer and Technical Architect | Sensor integration, APIs, data pipelines, technical architecture, testing, deployment, and reliability |
| Gemini | Researcher | Current multimodal methods, package compatibility, sensor-fusion research, datasets, UI references, and evaluation |
| Future Elysia | QC/PM | Milestone coordination, multimodal-system quality gates, risk tracking, and release-readiness review |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude defines implementation-ready interaction flows and frontend systems,
  then coordinates them with hardware and latency constraints.
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
