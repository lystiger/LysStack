# LysOmarchy step 3 — test script

**Decisions:** Lystiger · **Written by:** Claude · **Status:** Accepted 2026-10-31 · **Source:** pipeline brief P13, P15, P17–P19, P21–P28

## 1. Context and problem
When an agent finishes a branch, nothing records whether its tests ran, against which commit, or how they ended. An agent reports its own result, a stuck test can hold a job indefinitely, and each project tests differently (`unittest`, `pytest`, `vitest`, `npm`). The orchestrator has no reliable input for its test gate, and the review pane has nothing trustworthy to show.

## 2. Goals
- The orchestrator can read, for any agent branch, whether its related tests passed at a specific commit.
- A test run can never hold a job longer than its time limit.
- The same script works on any project that declares a test command.
- The result is good enough for the review pane to display later, without changing the script.

## 3. Non-goals
- The full suite and integration: the orchestrator runs those at integration (P18).
- Deciding what happens next: the script reports, and the orchestrator acts (P15).
- Pane keys or display changes: the pane has no `t` or `r` (P16), and showing worktrees is a later piece (P20).
- Starting agents, committing, pushing or merging.
- Choosing which tests are related: that's each repo's command (P22).
- The TDD check that tests fail first (P5): a separate piece.

## 4. Requirements

Call: `pipeline-test <worktree> <base> [--limit <minutes>]`. The script lives in LysOmarchy, which installs it to `~/.local/bin`.

### Functional

**Input**
- `<worktree>` is the folder holding the agent's checked-out branch. `<base>` is the branch to compare against. Both are required, and the orchestrator passes them.
- `--limit` is optional and sets the time limit for this job.
- If an argument is missing, the path is not a git repository, the base does not exist, or `--limit` is above 60, the script saves nothing, prints an error and exits non-zero.

**Choosing the tests**
- The changed files are the output of `git diff --name-only <base>...HEAD`, run in the worktree.
- Each repo provides one test command in a `.pipeline.toml` file at its root, which can also set the repo's time limit. The script pipes the changed files to the command's stdin, one per line. The command runs that project's related tests and exits with:
  - `0`: the tests passed.
  - `5`: there are no related tests.
  - Anything else: the tests failed.
- The script knows nothing else about how a project tests.

**The saved result**

The result is a file at `$(git rev-parse --git-dir)/review/tests.json`, which is private to the worktree and never tracked by git. It holds:

| Field | Why it's there |
|---|---|
| `status` | What happened; the orchestrator acts on it |
| `sha` | The commit tested; a newer commit makes the result stale |
| `base` | The branch compared against; a pass against one base doesn't count for another |
| `started`, `finished` | When it ran and how long it took; `finished` is empty during a run |
| `limit` | The time limit for this run; needed to spot a run that died |
| `output` | The last 200 or so lines, so the builder can fix a failure without rerunning |
| `log` | The path to the full output |

**Statuses**

| Status | When | Counts as passed? |
|---|---|---|
| `running` | Saved when the run starts | No |
| `passed` | The command exited `0` | Yes |
| `failed` | The command exited with anything but `0` or `5` | No |
| `no-tests` | The command exited `5` | Only if the branch changed nothing but docs; the orchestrator decides, and otherwise sends it back to the builder |
| `hung` | The time limit was reached | No |
| `no-config` | The repo has no `.pipeline.toml` or no test command in it; nothing runs, and the orchestrator checks in with Lystiger | No |
| `dirty` | The worktree has uncommitted changes, including untracked files git doesn't ignore; nothing runs | No |
| `stale` | `HEAD` moved during the run, so the result says nothing reliable about either commit | No |

### Non-functional

**Time limit**
- The limit is the job's `--limit` if given, otherwise the repo's setting, otherwise 10 minutes. The cap is 60 minutes.
- AI, heavy-compute or heavy-load work can have a longer limit, set in the job's requirements and spec before the orchestrator starts the test.
- At the limit, the script stops the test command and all its child processes: `SIGTERM` (asks them to stop), then `SIGKILL` (forces them) after 10 seconds. It then saves `hung` and keeps the log.

**During a run, and if the script dies**
- Anyone reading the file during a run sees `running`.
- If the script itself dies, the file would say `running` forever. So readers treat `running` as `hung` once `started` is older than `limit` plus 1 minute.

## 5. Acceptance criteria
Each check runs against a throwaway git repository with a fake test command.

1. A command exiting `0` saves `passed`, with the tested `sha` and `base`, and non-empty `started` and `finished`.
2. A command exiting `1` saves `failed`, and `output` contains the command's last lines.
3. A command exiting `5` saves `no-tests`.
4. The command receives exactly the files from `git diff --name-only <base>...HEAD` on stdin, one per line.
5. With no `.pipeline.toml`, or no command in it, the script saves `no-config` and the command doesn't run.
6. With an uncommitted or untracked file, the script saves `dirty` and the command doesn't run. A file git ignores doesn't count.
7. A missing argument, a non-repository path, an unknown base, or `--limit 61` saves nothing and exits non-zero.
8. A command that sleeps past a 1-minute-or-shorter test limit saves `hung`, and it and a child process it started are both gone afterwards. A command ignoring `SIGTERM` is gone after 10 more seconds.
9. The limit used is `--limit` if given, then the repo's setting, then 10 minutes, and it's saved in `limit`.
10. During a run, the result file says `running`.
11. A second run on a worktree that's already running exits non-zero and leaves the first run's result alone.
12. A commit made during a run saves `stale`.
13. The result file isn't tracked by git and doesn't make the worktree `dirty`.
14. From a linked worktree, the result is saved in that worktree's own git directory, not the main one.

## 6. Design
**Language: Python** (flagged below), because it needs TOML and JSON and must manage process groups. The standard library covers all three.

**Exit codes:** `0` for `passed`. `1` for any other saved status. `2` for a bad call or a run already in progress, where nothing is saved. The orchestrator should read `status`, not only the exit code.

**Sequence**
1. Check the arguments, worktree and base. Stop with exit `2` if any is bad.
2. Take a `flock` on `review/lock` in the worktree's git directory. Stop with exit `2` if it's taken.
3. Read `.pipeline.toml`. Without a command, save `no-config`.
4. Check for uncommitted changes. If there are any, save `dirty`.
5. Note `HEAD`, work out the limit, and save `running`.
6. Start the command in its own process group, with the changed files on stdin and output going to `review/tests.log`.
7. At the limit, stop the group (`SIGTERM`, then `SIGKILL` after 10 seconds) and save `hung`.
8. Otherwise, if `HEAD` moved, save `stale`. If not, map the exit code to a status and save it.

Each save writes a temporary file, then renames it, so a reader never sees half a file.

**`.pipeline.toml` example**
```toml
command = "tests/related"
limit = 10
```

**Reuse from `.githooks/pre-commit`:** its name-matching moves into a LysOmarchy command that reads filenames on stdin, and the hook pipes its staged files into the same command. The branch diff, not the selection logic, is the only difference.

## 7. Alternatives considered
| Alternative | Why rejected |
|---|---|
| `t` and `r` keys in the pane | They overlap with the agents' jobs and the pane's display (P16) |
| Testing uncommitted files | Results can't be tied to a commit, and P5 can't be proven (P13) |
| Selection rules inside the script | Every new tool or layout would change the script (P22) |
| An agent monitoring the time limit | A timer can't get stuck or run out of quota (P17) |
| A guessed test suite when no command exists | A wrong guess could look like a real pass (P22) |

## 8. Risks
| Risk | Handling |
|---|---|
| Two runs start on one worktree, such as a replacement agent after a crash | `flock`: the second exits `2`, and the lock is released even if the first crashes |
| A commit lands during a run | Compare `HEAD` at the end and save `stale`; the orchestrator reruns |
| A test leaves child processes behind | Its whole process group is stopped at the limit |
| The script dies mid-run | Readers treat `running` as `hung` once `started` is older than `limit` plus 1 minute |
| A test double-forks out of its process group | It can survive the kill. Accepted for now: rare, and it can't change the saved result |
| A repo's command reports the wrong exit code | The script trusts it. Each repo's command needs its own check that `5` and failures are reported correctly |

## 9. Test plan
Tests live in `tests/test_pipeline_test.py`, using throwaway git repositories and these fake commands:

| Fake command | Used for criteria |
|---|---|
| Exits `0`, `1` or `5` | 1, 2, 3 |
| Writes stdin to a file | 4 |
| Sleeps, started with a child that also sleeps | 8, 10, 11 |
| Traps and ignores `SIGTERM` | 8 |
| Makes a commit, then exits `0` | 12 |

Time-limit tests need a fraction of a minute to stay fast, so the tests need a way to set a very short limit.

## 10. Rollout
1. Ship the script with LysOmarchy's `.pipeline.toml`. Nothing depends on it yet.
2. It's built twice for the A-vs-B comparison (P19), one build per method, from the same commit.
3. The orchestrator starts calling it at gate 2 in a later piece.
4. Other projects get a `.pipeline.toml` when they first run through the pipeline. Until then they get `no-config`.

**Going back:** the orchestrator stops calling the script. It changes no project files and only writes inside each worktree's git directory, so nothing needs cleaning up beyond the installed script.

## Claude's choices, accepted by Lystiger 2026-10-31
1. Python as the language.
2. The exit codes `0`, `1` and `2`.
3. Accepting the double-fork risk in section 8.
4. Moving the selection into a command the pre-commit hook also uses.
5. How tests set a limit under a minute, such as a hidden seconds option or an environment variable.
6. Leaving the TDD check (P5, gate 1) to a separate piece.
