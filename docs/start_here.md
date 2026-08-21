# Start Here

LysStack is the control plane for project context, policy, task state,
decisions, and memory. Hermes is the runtime that executes agents against
product repositories.

It should answer:

- What am I working on?
- Why does it matter?
- What has already been decided?
- What constraints and failures should I know about?
- What should happen next?

## Startup Protocol

Inspect these files in order:

1. [`AGENTS.md`](../AGENTS.md)
2. [`operating_system/current_focus.md`](../operating_system/current_focus.md)
3. [`operating_system/active_task.md`](../operating_system/active_task.md)
4. `projects/<project>/architecture.md`
5. `projects/<project>/constraints.md`
6. `projects/<project>/decisions.md`
7. [`operating_system/hermes-delivery.md`](../operating_system/hermes-delivery.md)

Read additional project files when relevant:

- `agents.md` for project-specific workflow-role interpretation
- `roadmap.md` for sequencing and acceptance criteria
- `lessons.md` before repeating or extending previous work
- `dataset.md` for data collection, preparation, or model work
- `deployment.md` for infrastructure, release, or operations work

Repository-wide principles and working rules remain in
[`memory/principles.md`](../memory/principles.md) and
[`docs/instructions.md`](instructions.md).

## Before Execution

Hermes execution begins only when `operating_system/active_task.md`:

- Has status `Ready`
- Identifies the project, goal, target repository, and pinned base SHA
- Defines acceptance criteria and verification
- Provides enough bounded context to govern the work

Project `agents.md` files describe standing workflow responsibilities. They do
not execute workers or assign work independently.

## After Execution

Follow the completion protocol in `docs/instructions.md`. Do not mark a task
complete until its acceptance criteria and deterministic verification have
been recorded and the human has made the required promotion decision.
