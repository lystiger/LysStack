#!/usr/bin/env bash
#
# start-qwen-aider.sh
# Launch Aider with a local Qwen model for the local-coder stage of the
# LysStack GitHub issue-to-PR workflow.
#
# This script contains NO secrets. It reads configuration from environment
# variables with safe defaults. By default it targets a local Ollama server,
# which needs no API key.
#
# Usage:
#   scripts/start-qwen-aider.sh [extra aider args...]
#
# Environment variables:
#   QWEN_MODEL        Model passed to aider   (default: ollama/qwen2.5-coder:7b)
#   OLLAMA_API_BASE   Local Ollama endpoint   (default: http://localhost:11434)
#
# Examples:
#   scripts/start-qwen-aider.sh
#   QWEN_MODEL=ollama/qwen2.5-coder:14b scripts/start-qwen-aider.sh src/app.py

set -euo pipefail

QWEN_MODEL="${QWEN_MODEL:-ollama/qwen2.5-coder:7b}"
OLLAMA_API_BASE="${OLLAMA_API_BASE:-http://localhost:11434}"

# Aider must be installed by the user; this script does not install anything.
if ! command -v aider >/dev/null 2>&1; then
  echo "Error: 'aider' is not installed or not on PATH." >&2
  echo "Install it first, e.g.:  python -m pip install aider-install && aider-install" >&2
  echo "See https://aider.chat for details." >&2
  exit 1
fi

# Warn (do not fail) if we are not inside a git repository. Aider works best in
# a repo, and the workflow expects branch-based changes.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Warning: not inside a git repository. Create or enter the target project repo first." >&2
fi

echo "Starting Aider"
echo "  model:    ${QWEN_MODEL}"
echo "  endpoint: ${OLLAMA_API_BASE}"
echo "  Reminder: branch before coding, and never commit secrets."

# Export the endpoint so aider's Ollama backend can find the local server.
export OLLAMA_API_BASE

# Hand off to aider. Any extra arguments are passed straight through.
exec aider --model "${QWEN_MODEL}" "$@"
