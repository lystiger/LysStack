# VM Hunter — Hermes Error Log

Every problem Hermes (or the agents it runs) hit while building this project, newest first.
One entry per problem: what happened, the evidence, the cause if known, and what was done.

Status: **open** (not fixed), **fixed** (link the fix), **workaround** (avoided, not fixed).

## Entries

### E2 — A blocked job's good work has no way forward but by hand · open
- **When:** 2026-10-23, job `run_20261023_181921_8a249caf` (roadmap step 1).
- **What:** the job blocked only because one check was unproven (E1); its code was correct. A blocked
  job opens no PR and cannot be resumed, so the work could only be saved by pushing its branch and
  opening the PR by hand (vm-hunter PR #1).
- **Next:** a way to re-run only the final verification of a blocked job (for example after the
  environment is fixed), or to open its PR marked "needs review".

### E1 — A Codex verifier cannot reach Docker, so the n8n import blocked the job · fixed
- **When:** 2026-10-23, job `run_20261023_181921_8a249caf` (roadmap step 1).
- **What:** Codex runs in a sandbox (`--sandbox workspace-write`) where Docker answers
  "permission denied". It reported the local n8n import as UNPROVEN, and Hermes blocked the job
  ("Blocked by environment ... local n8n import remains unproven"). Run outside the sandbox, the same
  `./scripts/check` passed, including a real import into n8n 1.123.87.
- **Cause:** checks that need Docker or the network were left for the verifier agent to run itself.
- **Fix:** Hermes-lab `feat/project-instructions`: a project declares its checks in `hermes.json`;
  Hermes runs them outside any sandbox before each verifier/security task, puts the results in the
  prompt, and its final gate runs them too. vm-hunter declares `./scripts/check`.
- **Worked well in the same job:** Codex found two real cost-guard bypasses (a direct path past the
  guard, then a loop around it); Claude fixed both in two repair cycles.

### E0 — Setup: project knowledge never reached goal-job agents · fixed
- **When:** 2026-10-23, before the first job.
- **What:** goal-planned jobs gave agents a persona, the task line and Hermes rules, but no project
  instructions; neither existing project repository had an `AGENTS.md` or skills, and Claude agents
  could not load skills (`Skill` was not an allowed tool).
- **Fix:** Hermes-lab `feat/project-instructions`: the planner ranks `AGENTS.md` first, prompts carry
  the task role instead of a persona, Claude agents may use `Skill`. This repository adds `AGENTS.md`
  and skills linked for both CLIs.
