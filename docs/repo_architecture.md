# Repository Architecture

LysStack is an orchestration workspace for projects, AI collaborators, shared
knowledge, and long-term planning. The structure below is the target
architecture; directories should be added as their contents become necessary.

## Directory Structure

```text
LysStack/
├── README.md
├── docs/
│   ├── instructions.md
│   ├── repo_architecture.md
│   ├── start_here.md
│   └── team.md
├── projects/
│   ├── aoi/
│   ├── signglove/
│   ├── hasc/
│   └── tempcast/
├── memory/
│   ├── decisions.md
│   ├── lessons.md
│   ├── mistakes.md
│   └── principles.md
├── agents/
│   ├── architect.md
│   ├── engineer.md
│   ├── designer.md
│   └── researcher.md
└── operating_system/
    ├── active_task.md
    ├── current_focus.md
    ├── project_health.md
    ├── vision.md
    ├── roadmap.md
    ├── yearly_goals.md
    ├── monthly_goals.md
    └── improvements.md
```

## Top-Level Areas

### `docs/`

Repository-level documentation for understanding and working with LysStack.
This includes the team model, architecture, setup instructions, and shared
workflows.

### `projects/`

Independent product and research projects. Each project owns its source code,
tests, documentation, dependencies, and project-specific configuration.

Projects should not depend directly on files from other project directories.
Reusable components should be promoted to a dedicated shared package when
needed.

Each project includes an `agents.md` file that maps collaborators to global
roles and defines project-specific focus. It does not duplicate complete role
definitions or assign executable tasks.

### `memory/`

Durable knowledge gathered across projects and collaborators:

- `decisions.md`: Important decisions and their rationale
- `lessons.md`: Reusable insights from completed work
- `mistakes.md`: Failures, causes, and prevention measures
- `principles.md`: Stable engineering and product principles

Entries should be concise, dated when relevant, and useful beyond a single
task.

### `agents/`

Role definitions and operating instructions for AI collaborators. Each file
defines a role's responsibilities, boundaries, and expected working practices.

Team membership and decision authority belong in `docs/team.md`; role-specific
instructions belong here.

### `operating_system/`

Planning documents that connect the project vision to ongoing execution:

- `active_task.md`: The current executable assignment and completion record
- `current_focus.md`: Current priorities, outcomes, milestones, and blockers
- `project_health.md`: High-level project status
- `vision.md`: Long-term direction
- `roadmap.md`: Planned milestones and major initiatives
- `yearly_goals.md`: Current annual outcomes
- `monthly_goals.md`: Near-term priorities
- `improvements.md`: Process and system improvements

## Placement Guidelines

- Put product-specific work inside its corresponding `projects/` directory.
- Put project-specific role assignments and boundaries in the project's
  `agents.md`.
- Put repository-wide explanations and workflows in `docs/`.
- Record lasting cross-project knowledge in `memory/`.
- Keep agent behavior and role instructions in `agents/`.
- Keep goals, plans, and process improvements in `operating_system/`.
- Keep only one executable assignment in `operating_system/active_task.md`.
- Add new top-level directories only when they represent a distinct,
  repository-wide responsibility.
