# GitHub Issue-to-PR Workflow

This is LysStack's AI-assisted coding workflow. It moves a change from idea to
merged code through five stages, one owner per stage. **No agent merges. Human
approval is always required before merge.**

## Roles

| Stage | Owner | What they produce |
| --- | --- | --- |
| 1. Issue | Claude | A clear GitHub issue with acceptance criteria |
| 2. Plan | DeepSeek | An ordered implementation plan |
| 3. Code | Qwen + Aider | A feature branch and a pull request |
| 4. Review | Codex | A pass / conditional / fail recommendation |
| 5. Merge | Lystiger (human) | The final merge decision |

Role details: [claude-issue-writer](../agents/claude-issue-writer.md),
[deepseek-planner](../agents/deepseek-planner.md),
[qwen-coder](../agents/qwen-coder.md),
[codex-reviewer](../agents/codex-reviewer.md).

## Where to Run It

LysStack is the brain/config repo. Run the **coding** stages (3-4) inside the
target product repository. Issue writing and planning can happen anywhere, since
they live in GitHub Issues. The helper scripts operate on whatever git repo is
the current working directory.

## The Five Stages

### 1. Write the issue (Claude)

Capture the problem as a GitHub issue using a template in
`.github/ISSUE_TEMPLATE/`. The issue must state the goal, scope, non-goals, and
testable acceptance criteria. Lystiger accepts the issue before planning starts.

### 2. Plan the implementation (DeepSeek)

Read the issue and produce an ordered plan: approach, steps, files likely to
change, verification commands, and risks. Post the plan as a comment on the
issue. Lystiger accepts the plan before coding starts.

### 3. Write the code (Qwen + Aider)

Create a feature branch, then implement the plan locally with Aider driving a
local Qwen model. Keep commits small. Run the verification commands from the
plan. Open a pull request that links the issue and fills in the PR template.
Stop at the PR.

### 4. Review the change (Codex)

Produce the diff with `scripts/review-diff.sh`, check the change against every
acceptance criterion, look for bugs, regressions, and leaked secrets, and post a
recommendation: **Pass**, **Conditional pass**, or **Fail**. A failed gate goes
back to stage 3.

### 5. Merge (Lystiger)

Lystiger reviews the recommendation and merges, requests changes, or rejects.
No agent merges on its own.

## Example Command Flow

```bash
# --- Stage 1: Claude opens the issue (run in the target project repo) ---
gh issue create \
  --title "Add CSV export to the report page" \
  --body-file issue.md \
  --label feature

# --- Stage 2: DeepSeek posts the plan as a comment ---
gh issue comment 42 --body-file plan.md

# --- Stage 3: Qwen + Aider implement on a branch ---
git switch -c feature/42-csv-export
~/projects/LysStack/scripts/start-qwen-aider.sh   # edit code with Aider, then exit
# run the plan's verification commands, e.g.:
#   npm test
git push -u origin feature/42-csv-export
gh pr create --fill --base main          # links the issue via the PR body

# --- Stage 4: Codex reviews the diff ---
~/projects/LysStack/scripts/review-diff.sh main > review.txt
gh pr comment 43 --body-file review.txt  # 43 = the PR number

# --- Stage 5: Lystiger merges after approval (human only) ---
gh pr merge 43 --squash   # run by the human, never by an agent
```

## Rules

- One issue per deliverable; keep changes small.
- Branch before coding; never commit straight to `main`.
- Run verification before opening the PR and record the output.
- Never commit secrets or API keys.
- Never auto-merge. Stage 5 is human-only.
