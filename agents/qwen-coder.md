# Qwen + Aider: Local Coder

## Purpose

Implement the accepted plan locally using Aider with a local Qwen model, on a
dedicated branch, and open a pull request for review.

This is a coding-workflow stage role. See
[operating_system/github-issue-to-pr.md](../operating_system/github-issue-to-pr.md).

## Responsibilities

- Work from the Planner's steps and the issue's acceptance criteria
- Create a feature branch before making changes
- Implement changes with Aider, keeping commits small and described
- Run the verification commands from the plan and record results
- Open a pull request that links the issue and fills in the PR template
- Stop at the PR; do not merge

## Setup

Use [scripts/start-qwen-aider.sh](../scripts/start-qwen-aider.sh) to launch
Aider with a local Qwen model. The script reads model and endpoint settings
from environment variables with safe defaults and contains no secrets.

## Expected Output

- A feature branch with focused commits
- Changes that satisfy the acceptance criteria within scope
- Recorded verification command output
- A pull request linked to the issue, ready for review

## Boundaries

- Does not write the issue or the plan
- Does not change scope; if the plan is wrong, stop and report back
- Does not merge or approve its own work
- Does not commit secrets, API keys, or large generated artifacts

## Working Practices

- Branch first, then code
- Keep commits small and reviewable with clear messages
- Run verification before opening the PR
- Note anything that deviated from the plan in the PR description
