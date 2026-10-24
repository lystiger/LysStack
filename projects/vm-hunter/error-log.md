# VM Hunter — Hermes Error Log

Every problem Hermes (or the agents it runs) hit while building this project, newest first.
One entry per problem: what happened, the evidence, the cause if known, and what was done.

Status: **open** (not fixed), **fixed** (link the fix), **workaround** (avoided, not fixed).

## Entries

### E8 — A research-only task failed as "no file changes" until the job blocked · workaround
- **When:** 2026-10-24, job `run_20261024_172948_48e2f30c` (roadmap step 4, Oracle claimer).
- **What:** the goal asked the job to settle O1 "in your result". The planner made it a separate task
  that said "Do not change any files", but ran it as a builder task. Hermes fails a builder task with no
  file changes (`FAILED_NO_CHANGES`), so all four attempts failed and the job blocked after 3 replans.
  The agent also could not answer: Context7 needs OAuth, and WebFetch and WebSearch were denied.
- **Cause:** Hermes has no task kind for research that ends in a written answer; the planner can create
  a no-change task that the runtime is sure to fail. Agents have no documentation access.
- **Workaround:** the operator settled O1 by running the pinned n8n (D14), updated the skill and
  relaunched without the research request.
- **Hermes fix wanted:** let the planner mark a task as research (its result is the deliverable, no
  diff required), or forbid no-change tasks in plans.

### E7 — Offer watcher passed every check but would have found nothing in production · fixed
- **When:** 2026-10-24, job `run_20261024_154936_a7d5bf57` (roadmap step 3, PR #4).
- **What:** two defects survived the builder, the reviewer, the verifier and `./scripts/check`:
  1. The free-for-dev fixture invented the headings `## Hosting` and `## Servers`; the real README has
     `Major Cloud Providers`, `IaaS`, `PaaS` and `Web Hosting`. The watcher would parse 0 offers and post a
     "No offers parsed" alert every day.
  2. The Execute Workflow nodes used the default mode (`once`), but notify-discord sends only its first
     input item, so when one run raised several alerts, only the first reached Discord.
- **Cause:** agents run without network access, so "a trimmed copy of the real README" became a
  hand-written guess, and the tests only checked the code against that guess. Nothing told agents
  that notify-discord handles one item per call.
- **Fix:** vm-hunter PR #4 commit by Claude: real headings (checked against the live README, 131 offers
  parsed), `mode: each` on every notify call, and a test for it.
- **Next:** when a fixture must copy a live source, the operator records it before the job, or the job
  says the fixture is a guess. Add "one message per call" to the notify-discord skill.

### E6 — Fixture task given to Antigravity, which cannot run commands headless; replans kept picking it · workaround
- **When:** 2026-10-24, job `run_20261024_154526_1f6b0e28` (roadmap step 3, offer watcher).
- **What:** the planner gave `record_source_fixtures` to Antigravity. Headless Antigravity auto-denies every
  command not on an allowlist (`permission check failed for unsandboxed "find tests -maxdepth 4"`), so each
  attempt ended `FAILED_NO_CHANGES`. All three replans assigned Antigravity again, and the job blocked with
  "Exhausted maximum allowed replans (3)". No other task ran.
- **Cause:** the launch request omitted `excludeAgents` (operator error; earlier jobs passed
  `["antigravity", "gemini"]`). Hermes also does not switch agents after a permission denial, and has no
  safe default when `allowedCommands` is empty.
- **Workaround:** relaunched with `excludeAgents: ["antigravity", "gemini"]`.
- **Hermes fix wanted:** exclude Antigravity by default when `allowedCommands` is empty, or move a task to
  another agent when its run reports denied commands.

### E5 — AGENTS.md and .env.example disagreed, and the repair deleted useful defaults · fixed
- **When:** 2026-10-23, job `run_20261023_201042_160f5253` (PR #3).
- **What:** AGENTS.md rule 2 says `.env.example` holds "names only, no values", but it shipped with
  non-secret defaults (feed URLs, `NODE_FUNCTION_ALLOW_BUILTIN=crypto`). Codex flagged the mismatch; the
  repair emptied every value and tightened the repository test to forbid values, losing defaults the
  owner needs on the VM.
- **Cause:** the scaffold (written by Claude in this session) contradicted itself, as in E3.
- **Fix:** vm-hunter `b3efcf0` (merged with PR #3): AGENTS.md allows non-secret defaults and never
  secrets, the defaults are restored, and the test stays strict about secrets only.

### E4 — A retry overwrites the previous attempt's logs · open
- **When:** 2026-10-23, same job. The first repair attempt (`repair_T4_verify_1`, Claude) exited with
  code 1 and an empty message; Hermes retried and the retry succeeded.
- **What:** run logs are named `<task>_<agent>_stdout.log` with no attempt number, so the retry wrote
  over the failed attempt's logs and the cause of the exit cannot be found.
- **Next:** Hermes-lab: include the attempt number in run log names.

### E3 — A contradiction in a skill made repairs go back and forth until the job blocked · fixed
- **When:** 2026-10-23, job `run_20261023_195607_efa39646` (forum thread routing).
- **What:** the `monitoring` skill asked the notifier both to fail the run on a failed send and to count
  that failure in its static data. n8n does not save static data from a failed run, so both cannot hold.
  Claude alternated between "fail and lose the counter" and "succeed and hide the failure"; Codex
  rejected each correctly; the job blocked after 3 repair cycles ("Verification failed after 3 repair
  cycles ... a 429 followed by a failed retry still loses the rateLimited increment").
- **Cause:** the skill (written by Claude in this session), not the agents or Hermes. The thread routing,
  new kinds and missing-thread error all passed review.
- **Fix:** the skill now says a failing run cannot count itself; failures are counted by the error
  workflow, and a lost `rateLimited` increment on a failed run is accepted. The job is re-run.
- **Hermes lesson (open):** repairs cannot tell "the spec contradicts itself" from "the fix is
  incomplete". When re-checks keep returning the same finding, Hermes could stop early and ask the
  owner instead of spending the remaining cycles.

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
