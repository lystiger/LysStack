#!/usr/bin/env bash
#
# review-diff.sh
# Produce a changed-file list and full diff for the current branch, for the
# review stage of the LysStack GitHub issue-to-PR workflow.
#
# This script is read-only: it does not modify, commit, push, or merge anything.
#
# Usage:
#   scripts/review-diff.sh [base-ref]
#
# Arguments:
#   base-ref   The branch/ref to compare against (default: origin/main, then
#              main if origin/main is unavailable).
#
# Examples:
#   scripts/review-diff.sh
#   scripts/review-diff.sh main
#   scripts/review-diff.sh main > review.txt

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

# Pick a base ref: explicit arg, else origin/main, else main.
BASE="${1:-}"
if [[ -z "${BASE}" ]]; then
  if git rev-parse --verify --quiet origin/main >/dev/null; then
    BASE="origin/main"
  else
    BASE="main"
  fi
fi

if ! git rev-parse --verify --quiet "${BASE}" >/dev/null; then
  echo "Error: base ref '${BASE}' not found." >&2
  echo "Pass a valid base, e.g.:  scripts/review-diff.sh main" >&2
  exit 1
fi

CURRENT="$(git rev-parse --abbrev-ref HEAD)"

echo "==================================================================="
echo "Review diff: ${BASE}...${CURRENT}"
echo "==================================================================="
echo

echo "----- Changed files -----"
# Use the merge-base (...) so only changes on this branch are shown.
git diff --stat "${BASE}...HEAD"
echo

echo "----- Full diff -----"
git diff "${BASE}...HEAD"
