# Start Here

LysStack is a personal AI-agent orchestration system. It provides enough
context for agents to understand the mission, accept a task, perform it
responsibly, and preserve useful knowledge afterward.

It should answer:

- What am I working on?
- Why does it matter?
- What has already been decided?
- What constraints and failures should I know about?
- What should happen next?

## Agent Startup Protocol

Read these files in order:

1. `operating_system/vision.md`
2. `memory/principles.md`
3. `operating_system/current_focus.md`
4. `operating_system/active_task.md`
5. The selected project's `agents.md`
6. The selected project's `architecture.md`, `constraints.md`, and
   `decisions.md`
7. Your assigned global role in `agents/`

Read additional project files when relevant:

- `dataset.md` for data collection, preparation, or model work
- `deployment.md` for infrastructure, release, or operations work
- `roadmap.md` for project sequencing and planned milestones
- `lessons.md` before repeating or extending previous work

## Before Starting Work

Only begin implementation when `operating_system/active_task.md`:

- Has status `Ready` or `In progress`
- Names you or your role as the owner
- Identifies the project and goal
- Defines acceptance criteria
- Provides enough repository or source locations to find the work
- Defines how the result will be verified

Project `agents.md` files define standing responsibilities and project-specific
focus. They do not assign executable work by themselves.

If required information is missing, investigate what can be discovered from
the repository. Ask Lystiger only when a missing decision would risk doing the
wrong work.

## After Completing Work

Follow the completion protocol in `docs/instructions.md`. Do not mark a task
complete until its acceptance criteria have been met and verification results
have been recorded.
