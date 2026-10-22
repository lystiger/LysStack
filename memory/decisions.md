# Decisions

Record repository-wide decisions and their rationale here. Project-specific
decisions belong in the corresponding project directory.

## Entry Template

### Decision: Title

- **Date:** YYYY-MM-DD
- **Status:** Proposed, accepted, superseded, or rejected
- **Context:** What problem or constraint prompted this decision?
- **Decision:** What was decided?
- **Rationale:** Why was this option selected?
- **Alternatives:** What other options were considered?
- **Consequences:** What changes or tradeoffs follow?

### Decision: Roles belong to phases, not agents

- **Date:** 2026-10-22
- **Status:** Accepted (Lystiger)
- **Context:** LysStack described fixed BUILDER, HARDENER and VERIFIER workers,
  LysControl had stopped labelling agents with roles, and Hermes set roles per
  phase but merged two phases with the same role into one. SECURITY was defined
  in LysStack but rejected by Hermes.
- **Decision:** A role is a property of a sprint phase, set in the Hermes sprint
  spec. The roles are BUILDER, HARDENER, VERIFIER and SECURITY. Any agent can
  play any role, roles can repeat within a sprint, and one agent can run several
  phases. Hermes identifies a phase by its spec order, never by role. LysControl
  shows the role on the phase (run timeline, "running now by role") and never as
  a fixed agent label; an agent's own `role` field from Hermes is shown as its
  focus.
- **Rationale:** Parallel phase groups and repeated hardener phases need per-phase
  roles; tying roles to agents hid running work and merged phases.
- **Alternatives:** Fixed agent roles (one role per agent), rejected.
- **Consequences:** The preferred-worker mapping in `AGENTS.md` is a default for
  writing specs only. Hermes treats SECURITY as read-only like VERIFIER.
