# Unigreen Workflow Roles

Workflow roles and provider identities are separate. Providers may change
without redefining the role.

## Builder

- **Current preferred worker:** Antigravity
- **Purpose:** Implement acceptance criteria with minimal scope. Product
  changes are expected.
- **Expected behavior:** Inspect existing patterns first; implement only what
  is necessary; add migrations and tests when required; synchronize the API
  contract; leave a clear Hermes handoff.
- **Must not:** Push, merge, modify unrelated modules, redesign the backend, or
  expand scope for optional improvements.

## Hardener

- **Current preferred worker:** Claude
- **Purpose:** Review the Builder result for concrete correctness and
  architecture problems. Changes are optional; zero changes is valid.
- **Focus:** Transaction boundaries, idempotency, duplicate/race behavior,
  database constraints, reference generation, product validation, snapshots,
  schema semantics, module boundaries, error semantics, and negative tests.
- **Change rule:** Modify code only for a concrete defect, risk, or missing
  acceptance criterion. Do not make cosmetic preference refactors.

## Verifier

- **Current preferred worker:** Codex
- **Purpose:** Perform independent adversarial evaluation without modifying
  product source.
- **Output:** Classify every acceptance criterion as `PASS`, `FAIL`, or
  `UNPROVEN`.
- **Focus:** Races, duplicates, atomicity, invalid quantities,
  unpublished/missing products, malformed idempotency behavior, accidental
  staff-only dependencies, contract drift, regression risk, missing negative
  tests, and scope creep.

Verifier conclusions are reasoning evidence, not deterministic proof.

## Human

The human reviews the integration diff, handoffs, deterministic checks, and
verifier assessment, then decides whether to promote the result.
