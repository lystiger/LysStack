# Hermes Governed Delivery

LysStack provides engineering knowledge, bounded context, and policy. Hermes
is the authoritative execution runtime and owns canonical job/task state,
scheduling, and agent execution. LysStack is not a runtime scheduler.

## Workflow

1. Define the active task in LysStack.
2. Record project-specific decisions and constraints.
3. Choose a bounded set of context files.
4. Create a Hermes sprint specification.
5. Pin the target repository base SHA.
6. Run `Hermes --dry-run`.
7. Require `DRY_RUN_READY`.
8. Run the real Hermes sprint.
9. BUILDER phases implement the acceptance criteria.
10. HARDENER phases review and optionally fix concrete defects.
11. VERIFIER and SECURITY phases evaluate without changing product source; a
    failed verdict fails the sprint.

Each phase's role comes from the sprint spec. Roles can repeat, and phases
that share a `parallel_group` (with disjoint `owned_paths`) run at the same
time. Hermes merges a parallel group all or nothing.
12. Hermes executes deterministic verification.
13. Hermes produces `READY_FOR_REVIEW`.
14. Human inspects the diff, handoffs, verification, and agent evidence.
15. Human decides whether to push, open a PR, merge, or deploy.

## Evidence Hierarchy

An agent statement such as “implementation looks correct” is useful reasoning
evidence. It is not deterministic proof.

Successful commands such as `pytest`, `ruff`, and `mypy`, plus a clean OpenAPI
diff, are deterministic evidence. Both evidence types are useful and must be
reported without confusing one for the other.

## Authority

No AI worker merges product code. No Hermes run automatically merges into a
protected product `main` branch. The human remains the final promotion
authority for push, pull request, merge, and deployment decisions.
