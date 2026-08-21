# Unigreen Decisions

## D001 — Modular Monolith

- **Status:** Accepted
- **Decision:** Unigreen remains a FastAPI modular monolith. This feature does
  not introduce microservices.

## D002 — First Hermes Vertical Slice

- **Status:** Accepted
- **Decision:** The first governed external-project Hermes experiment is Core
  Public Inquiry Submission at `POST /api/v1/public/inquiries`.
- **Reason:** It is a real missing business capability that exercises the API
  contract, validation, service/domain logic, persistence, migrations, product
  lookup, idempotency, tests, and OpenAPI synchronization without requiring the
  full commercial workflow.

## D003 — Execution Roles

- **Status:** Accepted
- **Decision:** The roles are BUILDER, HARDENER, and VERIFIER. Current preferred
  workers are Antigravity, Claude, and Codex respectively.
- **Invariant:** Role does not equal provider. Providers may change without
  changing workflow roles.

## D004 — Hermes Execution Ownership

- **Status:** Accepted
- **Decision:** Hermes owns target worktrees, the integration branch, sprint
  Git staging/commits/merges, phase semantics, handoff capture, deterministic
  verification, and run evidence. Agents do not own orchestration state.

## D005 — Human Authority

- **Status:** Accepted
- **Decision:** Agents may implement, review, and verify. Hermes may produce
  `READY_FOR_REVIEW`, but the human decides whether to push, open a PR, merge,
  or deploy. There is no automatic merge.

## D006 — LysStack Boundary

- **Status:** Accepted
- **Decision:** LysStack stores project context, policies, constraints,
  decisions, active task state, and lessons. It does not invoke or orchestrate
  coding workers.
- **Invariant:** LysStack never executes agents. Hermes executes agents.
