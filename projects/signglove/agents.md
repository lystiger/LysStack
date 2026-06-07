# SignGlove Agent Assignments

This file assigns global roles to SignGlove. Role definitions and general
boundaries remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | SignGlove Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Requirements, priorities, system direction, and final decisions |
| Claude | Product Designer and Frontend Architect | Interaction design, user flows, accessibility, design system, and frontend architecture |
| Codex | Engineer | Sensor integration, data pipelines, testing, deployment, and maintenance |
| Gemini | Researcher | Current multimodal methods, package compatibility, sensor-fusion research, datasets, UI references, and evaluation |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude defines implementation-ready interaction flows and frontend systems,
  then coordinates them with hardware and latency constraints.
- Codex may propose architecture changes but escalates changes affecting
  project direction.
- Gemini researches current methods, dependencies, datasets, design
  references, and external implementations; it records findings in the
  relevant project documents and does not own implementation.

## Task Assignment

These assignments define standing responsibilities, not the current task.
Executable work and its owner are defined in
`operating_system/active_task.md`.
