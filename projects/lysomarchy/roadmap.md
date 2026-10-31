# LysOmarchy — Roadmap

Each step is one Hermes goal job on `~/Projects/LysOmarchy`, smallest first, ending in a pull request.
Each must pass `python3 -m unittest discover -s tests` and the pre-commit hook before merge.

1. **Review pane.** `session/lysomarchy-review`: draws WORKFLOW, WHY, TESTS and REVIEW from git and
   `.review/`, and redraws on change. `.review/` added to `.gitignore`. Tests on throwaway git repos.
2. **Notes required.** `.claude/hooks/require-tests` also asks for a `.review/notes.md` line per changed
   file. Extend `tests/test_dev_hooks.py`.
3. **Test script.** `pipeline-test`, per `step-3-spec.md`. Replaces the `t` and `r` actions, dropped by pipeline P16. It's the A-vs-B test task (P19). Later pieces: the pane lists worktrees (P20), the verifier saves its result, and the orchestrator uses both.
4. **Launch and install.** The WS5 keybinding opens both windows in the right repository; the installer
   installs the script and adds `git-delta` to the packages, and the review window layers a delta config over lazygit's. Installer
   tests, then Lystiger checks it on WS5.
