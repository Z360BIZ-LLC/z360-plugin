#!/usr/bin/env bash
# Copy the text agent's system skills from agent-layer into this plugin.
# Usage: scripts/sync-skills.sh [agent-layer path] [git ref]
set -euo pipefail

AGENT_LAYER="${1:-../agent-layer}"
REF="${2:-origin/main}"
SRC="agents/text/src/deep_agent/skills/system"
SKILLS=(customer-communication harness-migration product-model workspace-management)

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git -C "$AGENT_LAYER" archive "$REF" "$SRC" | tar -x -C "$TMP"

rm -rf "$ROOT/skills"
mkdir -p "$ROOT/skills"
for skill in "${SKILLS[@]}"; do
  cp -R "$TMP/$SRC/$skill" "$ROOT/skills/$skill"
done

# Agent paths (/skills/system/<skill>/...) become paths relative to the skill folder.
grep -rl '/skills/system/' "$ROOT/skills" | xargs sed -i 's|/skills/system/|../|g'

echo "Synced ${SKILLS[*]} from $AGENT_LAYER@$(git -C "$AGENT_LAYER" rev-parse --short "$REF")"
