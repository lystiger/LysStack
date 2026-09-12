# Unigreen Roadmap

## Current Milestone

**UG-001 — Staff Inquiry Review Workspace**

- **Goal:** Create the internal staff workflow for inquiry review, qualification, assignment, and internal notes.
- **Pinned Unigreen baseline:** `069aed0630f3d121cdf28bec03f68bc99cfb8123`
- **Scope:** Full-stack (FastAPI backend + Next.js staff admin frontend)

### Acceptance Criteria

- [ ] Authorized staff can list inquiries with search and filtering (status, reference, company)
- [ ] Authorized staff can view inquiry details with verbatim customer submission data
- [ ] Operational inquiry status transitions can be performed by authorized staff
- [ ] Staff assignment can be updated by authorized staff
- [ ] Internal notes can be added without modifying the customer-submitted notes
- [ ] Customer submission data remains preserved and immutable
- [ ] Backend enforces staff authentication and inquiry permissions
- [ ] Staff mutations produce audit records (`AuditEvent`)
- [ ] Existing public inquiry submission and notification mailers remain functional
- [ ] Backend and frontend deterministic verification passes without regressions
- [ ] OpenAPI schema and generated frontend types remain synchronized

## Completed Milestones

### Hermes E2E Experiment 01 — Public Inquiry Submission (`unigreen-inquiry-v1`)

- **Status:** Complete (Merged to `main`)
- **Pinned starting point:** `16b1b30579b788e3502874b3c54bde7a601e5404`
- **Execution Evidence:**
  - Governed Hermes sprint: `unigreen-inquiry-v1` executed 2026-08-22
  - BUILDER (`antigravity`): Commit `93699d5722e336847505ca6610d94c004f50b77f` (12 files changed)
  - HARDENER (`claude`): Commit `7b7882e1540d0838b60302ac23ea158303614cf0` (2 files changed)
  - VERIFIER (`codex`): Evaluated without source modifications (status `SUCCESS`)
  - Integration commit: `703f7e0a4066092d5d781b37d47e5addccb0d536`
  - Deterministic checks: All 7 verification commands passed (`uv-sync`, `ruff-format`, `ruff-lint`, `mypy`, `pytest`, `openapi-export`, `openapi-diff`)
- **Promotion & Merge:**
  - Integrated into `main` via `d268daade3958581f5d4bff9656e3e128bebf2d7`
  - PR #19 (`6234d97d97e7df31341e5240afa6668c940abcd6`) merged on 2026-08-22
- **Subsequent Unigreen Evolution:**
  - PR #17: Frontend inquiry basket, state persistence, and 3D landing hero
  - PR #20: Product pack options, quote mailer integration, inquiry UX improvements, production deploy fixes
  - Commit `069aed0`: Refine inquiry and product experience
- **Milestone Criteria:**
  - [x] `POST /api/v1/public/inquiries` returns HTTP 201
  - [x] Inquiry requires at least one line
  - [x] Quantities must be positive
  - [x] Referenced products must exist and be published
  - [x] Required product information is snapshotted
  - [x] A human-readable inquiry reference is generated (`UG-INQ-YYYY-NNNNNN`)
  - [x] Inquiry and lines persist atomically
  - [x] Repeated `Idempotency-Key` use does not create duplicates
  - [x] New behavior has automated tests
  - [x] Existing checks remain green
  - [x] The OpenAPI contract remains synchronized

## Later Milestones

- Quotation creation & pricing engine
- Quotation PDF generation & customer decision workflow
- Purchase-order upload & customer document handling
- Sales-order conversion
- Fulfilment & external integrations (EasyBooks, UniOps)
