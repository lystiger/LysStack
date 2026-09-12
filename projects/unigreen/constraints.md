# Unigreen Constraints

## Product Constraints (UG-001)

- Scope is full-stack: FastAPI backend and Next.js admin frontend.
- Explicit non-goals (deferred to later milestones):
  - No quotation creation or quotation line editing.
  - No quotation pricing, margin calculation, or discounts.
  - No quotation PDF generation.
  - No customer quotation acceptance or rejection flow.
  - No purchase-order (PO) upload or processing.
  - No sales-order creation or conversion.
  - No shipment, inventory, or delivery fulfilment.
  - No EasyBooks accounting integration.
  - No UniOps platform/observability integration.
  - No autonomous AI business decisions or automated customer responses.
  - No architectural rewrites, microservices, or external workflow engines.
- Avoid unrelated refactoring.

## Inquiry Domain Constraints

### Public Submission (Preserved Invariants)
- Public submission uses `POST /api/v1/public/inquiries`.
- Requires at least one line with positive quantity and valid unit.
- Referenced products must exist and be published; product snapshots are captured.
- Generates human-readable reference `UG-INQ-YYYY-NNNNNN`.
- Enforces `Idempotency-Key` deduplication and atomic persistence.
- Original customer submission data is strictly immutable.

### Staff Review Operations (UG-001)
- Staff actions must never mutate or overwrite original customer-submitted data
  (contact details, line items, customer notes, product snapshots).
- Staff-managed operational metadata (status, assignment, internal notes) must
  remain cleanly isolated from customer submission data.
  - Specifically, staff internal notes must be stored in a dedicated notes
    relation/table and not overwrite `inquiries.notes` (customer notes).
- Operational status transitions must adhere to valid inquiry statuses.
- Staff assignment must reference valid, active `StaffUser` records.
- All staff operational mutations must emit structured `AuditEvent` records.
- Endpoints must enforce staff authentication and inquiry permissions
  (`inquiry:read`, `inquiry:write`).

## Engineering Constraints

- Follow established Unigreen module conventions where sensible.
- Use existing SQLAlchemy 2.x, Alembic migrations, and test patterns.
- Staff frontend components must integrate cleanly with `AdminShell`.
- Keep the OpenAPI contract and frontend types (`lib/api/schema.d.ts`)
  synchronized.
- Preserve full test and lint suites across both backend and frontend.
- Do not place secrets in context files.
