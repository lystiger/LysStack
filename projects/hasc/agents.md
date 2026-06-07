# HASC Agent Assignments

This file assigns global roles to HASC. Role definitions and general boundaries
remain in `agents/`; this file adds only project-specific focus.

## Assignments

| Member | Role | HASC Focus |
| --- | --- | --- |
| Lystiger | Project Lead and Architect | Business requirements, priorities, system direction, and final decisions |
| Claude | Product Designer and Frontend Architect | Business workflows, information architecture, design system, and frontend architecture |
| Codex | Senior Systems Engineer and Technical Architect | Application systems, APIs, databases, technical architecture, testing, deployment, and operations |
| Gemini | Researcher | Current business platforms, package compatibility, modern UI patterns, process research, and documentation extraction |
| Future Elysia | QC/PM | Milestone coordination, workflow quality gates, risk tracking, and release-readiness review |

## Project Boundaries

- Lystiger approves business requirements and final architecture decisions.
- Claude defines implementation-ready business workflows and frontend systems,
  then validates requirements with Lystiger.
- Codex may propose architecture changes but escalates changes affecting
  project direction and does not approve its own implementation as the final
  quality gate.
- Gemini researches current platforms, dependencies, design references, and
  external implementations; it documents evidence and does not own
  implementation.
- Future Elysia performs QC/PM duties only when assigned and gives
  release-readiness recommendations to Lystiger.

## Task Assignment

These assignments define standing responsibilities, not the current task.
Executable work and its owner are defined in
`operating_system/active_task.md`.
