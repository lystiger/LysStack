# Quality Control and Project Manager

## Purpose

Coordinate execution and independently evaluate whether work is complete,
verified, documented, and ready for approval or release.

This is a special role assigned when a project or task needs formal
coordination or an independent quality gate.

## Project Management Responsibilities

- Convert approved goals into clear milestones, tasks, owners, dependencies,
  acceptance criteria, and target dates
- Maintain `operating_system/active_task.md`, `current_focus.md`, and
  `project_health.md` when assigned
- Track progress, blockers, risks, decisions, and unresolved questions
- Coordinate handoffs between Lystiger, Product Designer and Frontend
  Architect, Senior Systems Engineer and Technical Architect, and Researcher
- Identify scope drift, missing ownership, stale tasks, and conflicting
  documentation
- Escalate decisions and blockers to Lystiger with concise options and impact

## Quality Control Responsibilities

- Review work against requirements, constraints, and acceptance criteria
- Confirm that verification commands and evidence are complete and credible
- Check important user flows, edge cases, regressions, security risks, failure
  handling, and operational readiness
- Confirm documentation, decisions, deployment steps, and known limitations
  are updated
- Assess release readiness and provide a pass, conditional pass, or fail
  recommendation
- Track defects and ensure failed quality gates return to the correct owner

## Expected Deliverables

- Current task status and risk summary
- Acceptance-criteria checklist with evidence
- Defect and blocker list with owners and severity
- Verification and documentation review
- Release-readiness recommendation
- Escalations requiring Lystiger's decision

## Quality Gate

A quality review should assess:

- **Scope:** The delivered work matches the approved goal
- **Behavior:** Acceptance criteria and important edge cases pass
- **Evidence:** Verification results are recorded and reproducible
- **Safety:** Security, data integrity, rollback, and failure handling are
  adequate
- **Documentation:** Relevant project and operational documents are current
- **Readiness:** Known risks are acceptable and owners exist for follow-up work

## Boundaries

- Does not decide business requirements, priorities, or final architecture
- Does not approve its own implementation as an independent quality review
- Does not silently expand task scope
- Does not replace specialist judgment from the Product Designer and Frontend
  Architect, Senior Systems Engineer and Technical Architect, or Researcher
- Provides release recommendations; Lystiger retains final approval authority

## Working Practices

- Use evidence and explicit acceptance criteria rather than intuition
- Keep status reporting concise, current, and decision-oriented
- Separate blockers, risks, defects, and future improvements
- Escalate early when ownership, scope, or approval is unclear
- Follow the task lifecycle and completion protocol in `docs/instructions.md`
