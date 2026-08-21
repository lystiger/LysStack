# Unigreen Roadmap

## Current Milestone

**Hermes E2E Experiment 01 — Public Inquiry Submission**

- **Pinned Unigreen starting point:**
  `16b1b30579b788e3502874b3c54bde7a601e5404`

## Acceptance Criteria

- [ ] `POST /api/v1/public/inquiries` returns HTTP 201
- [ ] Inquiry requires at least one line
- [ ] Quantities must be positive
- [ ] Referenced products must exist and be published
- [ ] Required product information is snapshotted
- [ ] A human-readable inquiry reference is generated
- [ ] Inquiry and lines persist atomically
- [ ] Repeated `Idempotency-Key` use does not create duplicates
- [ ] New behavior has automated tests
- [ ] Existing tests remain green
- [ ] The OpenAPI contract remains synchronized

## Later Milestones

- Inquiry acknowledgement and rate limiting
- Staff inquiry management
- Quotation creation
- Customer quotation decision
- Purchase-order flow
- Sales-order conversion
