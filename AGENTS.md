# AGENTS.md

This is the single entry point for AI agents working in LysStack. Read it
first, then [operating_system/current_focus.md](operating_system/current_focus.md),
then [operating_system/active_task.md](operating_system/active_task.md).

LysStack is the engineering knowledge and brief repository: policy, decisions,
constraints, lessons, human-authored task briefs, and long-term memory. Product
source code lives in product repositories. **LysStack does not execute agents or
schedule jobs.** Hermes owns execution, job and task state, verification, and
run evidence. Human approval is required before any merge, push, or deploy.

## Sources of Truth

| Question | Source |
| --- | --- |
| What matters now? | `operating_system/current_focus.md` |
| What is the one active brief, and what jobs ran under it? | `operating_system/active_task.md` |
| How does a delivery run? | `operating_system/hermes-delivery.md` |
| How is a project designed? | `projects/<project>/architecture.md` |
| What limits the solution? | `projects/<project>/constraints.md` |
| What has a human or the orchestrator decided? | `projects/<project>/decisions.md` |
| What did agents decide along the way? | `operating_system/decision-log.md` |
| What failed or was learned? | `projects/<project>/lessons.md` |
| What applies across projects? | `memory/` |

`current_focus.md` sets priorities but does not authorize work. Only
`active_task.md` assigns executable work.

## Roles

Roles describe responsibilities. They are not tied to a provider, and providers
can change without redefining a role.

- **BUILDER:** implements the acceptance criteria with minimal scope. Inspects
  existing patterns first, adds migrations and tests when required, syncs the
  API contract, and leaves a clear Hermes handoff. Does not push, merge, touch
  unrelated modules, or expand scope.
- **HARDENER:** reviews the Builder result for concrete correctness and
  architecture problems. Changes only for a concrete defect, risk, or missing
  acceptance criterion. Zero changes is a valid outcome. No cosmetic refactors.
- **VERIFIER:** independent adversarial evaluation without modifying product
  source. Classifies every acceptance criterion as `PASS`, `FAIL`, or
  `UNPROVEN`. Its verdict is reasoning evidence, not deterministic proof.
- **Lystiger (the human):** reviews the integration diff, handoffs, deterministic checks, and
  verifier assessment, then decides whether to promote.

Current preferred workers: BUILDER runs on Antigravity, HARDENER on Claude,
VERIFIER on Codex. Hermes records which provider ran each phase.

Unigreen focus for the roles: Builder must not redesign the backend. Hardener
looks at transaction boundaries, idempotency, duplicate and race behavior,
database constraints, reference generation, product validation, snapshots,
schema semantics, module boundaries, error semantics, and negative tests.
Verifier looks at races, duplicates, atomicity, invalid quantities,
unpublished or missing products, malformed idempotency behavior, accidental
staff-only dependencies, contract drift, regression risk, missing negative
tests, and scope creep.

## Agent Rules

1. Draft briefs only. Never set a brief to `Ready`; only a human does that.
2. Never execute, push, merge, or deploy. Hermes runs the phases, and a human starts each run.
3. Stay in scope. Name anything out of scope instead of doing it.
4. Route decisions to the right place: human and orchestrator decisions to the project's `decisions.md`, agent-level decisions to `operating_system/decision-log.md`.
5. Label evidence. Test results and tool output are deterministic. Reasoning is not proof.
6. Mark anything unverified as `UNPROVEN` rather than guessing.
7. Never write secrets, credentials, or private data into the repository.
8. Stop and report when blocked or when a round cap is reached. Do not loop.
9. Address the user as Lystiger. Do not call the user "the human" or "a human" in messages to them. The word "human" stays only as a role name in governance text.

## Grill-Me Mode

Run grill-me before drafting any big task. A task is big when it spans more than one module or repository, changes an API or data model, or has more than about five acceptance criteria. The method follows Matt Pocock's grilling skill (github.com/mattpocock/skills).

- **Frontier rounds.** Each round asks every question whose prerequisites are settled. Number them, and give each a recommended answer. Lystiger replies "yes" to take all the recommendations, or names the numbers to change. Questions that depend on an open one wait for a later round.
- **Facts first.** Before asking, look things up with the tools: decision_search, lysstack_read, repo_state, agent_options, usage_analysis. Ask only decisions, never facts.
- **Record as you go.** Each settled answer goes into the brief's Decisions section, with its source (Lystiger, or the fact that settled it). Nothing is written to a project decisions.md until Lystiger promotes it.
- **Stop when the frontier is empty and Lystiger says "agreed".** Then build the brief, save it as a draft, and run the brief check. Do not act on the plan before that confirmation.
- **Safety cap.** At six rounds, stop and list what is still open. This is a warning, not a silent end.

## Task Lifecycle

There is one active brief at a time, in `operating_system/active_task.md`. Its
Hermes runs (jobs) are listed inside it.

Statuses: `Draft` → `Ready` → `In progress` → `Complete`, with `Blocked` when
work cannot continue.

1. **Draft:** a human, or the orchestrator on a human's instruction, writes the
   brief. A draft is never executed.
2. **Ready:** only a human sets this. It requires a project, goal, target
   repository, pinned base SHA, acceptance criteria, verification commands, and
   bounded context.
3. **Accept:** Hermes runs a dry run and must report `DRY_RUN_READY` before any
   real execution.
4. **In progress:** Hermes runs the phases. A human starts each run.
5. **Complete:** only after every acceptance criterion passes, deterministic
   verification is recorded, and the human has decided on promotion.

Use `Blocked` with the blocker, what was tried, and what is needed to resume.

## Recording Decisions

- **Human or orchestrator decisions** (architecture, constraints, meaningful
  tradeoffs, and every change a human makes to a brief that should apply
  later) go to `projects/<project>/decisions.md`. Each entry names the brief
  revision it came from.
- **Agent-level decisions** (routine choices made during a run) go to
  `operating_system/decision-log.md`.
- **Cross-project knowledge** goes to `memory/`.
- **Routine implementation details** are not decisions. Do not record them.

Decision format:

```markdown
### Decision 001: Title

- **Date:** YYYY-MM-DD
- **Source:** human, orchestrator, or agent; brief revision if any
- **Problem:** What needs to be decided?
- **Decision:** What was selected?
- **Reason:** Why was it selected?
- **Rejected:** What alternatives were rejected?
- **Status:** Proposed, accepted, superseded, or rejected
```

## Completion Protocol

Before a brief is marked `Complete`:

- Confirm every acceptance criterion
- Run the listed verification commands, or record why they could not run
- Record significant decisions in the project's `decisions.md`
- Record reusable lessons in the project's `lessons.md`
- Promote cross-project knowledge to `memory/`
- Update architecture, constraints, or deployment docs if the work changed them
- Add a completion summary and verification results to `active_task.md`
- Update `current_focus.md` if priorities or blockers changed

## Hard Constraints

- Never commit secrets, credentials, PII, or private business data.
- Never auto-merge. Human approval is required before promotion.
- Keep this repository Markdown-first and config-only. Product source belongs in
  its product repository.
- Do not add heavy agent frameworks without a recorded decision in
  `memory/decisions.md`.
