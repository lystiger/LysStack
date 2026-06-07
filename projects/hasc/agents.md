# HASC Agent Assignments

This file assigns global roles to HASC. Role definitions and general boundaries
remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | HASC Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Business requirements, priorities, system direction, and final decisions |
| Claude | Designer | Business workflows, user experience, and frontend architecture |
| Codex | Engineer | Application systems, testing, deployment, operations, and maintenance |
| Gemini | Researcher | Current business platforms, package compatibility, modern UI patterns, process research, and documentation extraction |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude validates workflows with Lystiger before treating them as
  requirements.
- Codex may propose architecture changes but escalates changes affecting
  project direction.
- Gemini researches current platforms, dependencies, design references, and
  external implementations; it documents evidence and does not own
  implementation.

## Task Assignment

These assignments define standing responsibilities, not the current task.
Executable work and its owner are defined in
`operating_system/active_task.md`.
