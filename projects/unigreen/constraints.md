# Unigreen Constraints

## Product Constraints

- The first experiment is backend only.
- Do not build the entire CRM flow.
- Do not build quotation, purchase-order, or sales-order functionality.
- Do not implement a frontend inquiry basket.
- Do not implement email acknowledgement or Redis rate limiting yet.
- Do not add ERP functionality, microservices, or Kubernetes.
- Avoid unrelated refactoring.

## Inquiry Domain Constraints

Public submission uses `POST /api/v1/public/inquiries`.

An inquiry:

- Requires at least one line.
- References catalogue products, and only published products may be used.
- Requires a positive quantity and a unit.
- Supports standard and/or OEM/private-label requirements.
- Generates a human-readable reference in the form `UG-INQ-YYYY-NNNNNN`.

Submission must support `Idempotency-Key`. Repeated use of the same valid key
must not create duplicate inquiries.

Inquiry and inquiry lines must persist atomically: both persist or neither
persists. Product information required for historical meaning must be
snapshotted so later catalogue edits do not rewrite inquiry history. The
original customer submission remains immutable.

## Engineering Constraints

- Follow established Unigreen module conventions where sensible.
- Use existing SQLAlchemy 2.x, Alembic, and test patterns.
- Add automated tests for new behavior and preserve existing tests.
- Keep the OpenAPI contract synchronized.
- Do not perform an unrelated architecture rewrite.
- Do not place secrets in context files.
