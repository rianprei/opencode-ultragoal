#!/usr/bin/env bash
# install.sh — opencode-ultragoal
# One-liner installer: detects runtime, copies the right file.
set -euo pipefail

REPO="rianprei/opencode-ultragoal"
BRANCH="main"

echo "📋 Installing opencode-ultragoal..."

# Detect runtimes
install_opencode() {
  mkdir -p ~/.config/opencode/commands
  cp src/opencode/ultragoal.md ~/.config/opencode/commands/ultragoal.md
  echo "  ✅ opencode: ~/.config/opencode/commands/ultragoal.md"
}

install_claude() {
  mkdir -p ~/.claude/commands
  cp src/claude/ultragoal.md ~/.claude/commands/ultragoal.md
  echo "  ✅ Claude Code: ~/.claude/commands/ultragoal.md"
}

install_codex() {
  mkdir -p ~/.codex/skills/ultragoal
  cp src/codex/SKILL.md ~/.codex/skills/ultragoal/SKILL.md
  echo "  ✅ Codex: ~/.codex/skills/ultragoal/SKILL.md"
}

install_grok() {
  mkdir -p ~/.grok/skills/ultragoal
  cp src/grok/SKILL.md ~/.grok/skills/ultragoal/SKILL.md
  echo "  ✅ Grok Build: ~/.grok/skills/ultragoal/SKILL.md"
}

# If running from the repo (files present), copy directly
if [ -f "src/opencode/ultragoal.md" ]; then
  if command -v opencode >/dev/null 2>&1; then install_opencode; fi
  if [ -d ~/.claude ]; then install_claude; fi
  if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then install_codex; fi
  if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then install_grok; fi
else
  # Download and install
  echo "  Downloading..."
  tmpdir=$(mktemp -d)
  git clone --depth 1 "https://github.com/$REPO.git" "$tmpdir/repo" 2>/dev/null
  cd "$tmpdir/repo"
  if command -v opencode >/dev/null 2>&1; then install_opencode; fi
  if [ -d ~/.claude ]; then install_claude; fi
  if command -v codex >/dev/null 2>&1 || [ -d ~/.codex ]; then install_codex; fi
  if command -v grok >/dev/null 2>&1 || [ -d ~/.grok ]; then install_grok; fi
  cd /
  rm -rf "$tmpdir"
fi

echo ""
echo "  Done. Use: /ultragoal <objective>"
