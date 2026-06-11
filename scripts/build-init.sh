#!/usr/bin/env bash
# build-init.sh — regenerate scripts/loop-init.sh from templates/
# Run after any change under templates/; CI (templates-in-sync) fails if you don't.

set -euo pipefail
cd "$(dirname "$0")/.."

{
cat << 'HDR'
#!/usr/bin/env bash
# loop-init.sh — bootstrap loop engineering into any codebase
# Usage: curl -fsSL https://raw.githubusercontent.com/matheo-lm/loop-kit/main/scripts/loop-init.sh | bash
#   or:  ./loop-init.sh /path/to/project
#
# GENERATED FILE — do not edit by hand. Edit templates/ and run scripts/build-init.sh.

set -euo pipefail

TARGET="${1:-.}"
mkdir -p "$TARGET"
cd "$TARGET"

echo "=== loop-kit: bootstrapping $TARGET ==="

# ── helpers ──────────────────────────────────────────────────────────
write_if_missing() {
  local file="$1"
  if [ -f "$file" ]; then
    echo "  -  $file (already exists)"
    cat > /dev/null
  else
    mkdir -p "$(dirname "$file")"
    cat > "$file"
    echo "  +  $file"
  fi
}
HDR

emit() {
  printf '\n# ── %s ─────────────────────────────\n' "$2"
  printf "write_if_missing \"%s\" << 'TEMPLATE_EOF'\n" "$1"
  cat "$3"
  printf 'TEMPLATE_EOF\n'
}

emit "SESSION.md" "1. SESSION.md — session-start prompt" templates/SESSION.md
emit "AGENTS.md" "2. AGENTS.md — operating model" templates/AGENTS.md
emit "STATE.md" "3. STATE.md — session memory" templates/STATE.md
emit "docs/laundry_list.md" "4. docs/laundry_list.md — ranked backlog" templates/docs/laundry_list.md
emit "docs/done_laundry_list.md" "5. docs/done_laundry_list.md — completed items" templates/docs/done_laundry_list.md
emit "skills/disciplined-coding/SKILL.md" "6. skill — disciplined coding" templates/skills/disciplined-coding/SKILL.md
emit "skills/design/SKILL.md" "7. skill — frontend design" templates/skills/design/SKILL.md
emit "skills/usability-heuristics/SKILL.md" "8. skill — usability heuristics" templates/skills/usability-heuristics/SKILL.md
emit ".agents/reviewer.md" "9. sub-agent — reviewer" templates/.agents/reviewer.md
emit ".agents/security-auditor.md" "10. sub-agent — security auditor" templates/.agents/security-auditor.md
emit ".github/workflows/loop-triage.yml" "11. automation — scheduled triage" templates/.github/workflows/loop-triage.yml

cat << 'FTR'

# ── 12. .gitignore ───────────────────────────────────────────────────
write_if_missing ".gitignore" << 'TEMPLATE_EOF'
node_modules/
dist/
.tmp/
*.log
.DS_Store
TEMPLATE_EOF

# ── 13. Claude Code skill discovery ──────────────────────────────────
# Relative symlinks so skills are discovered natively by Claude Code.
# Committed to the repo on purpose: the loop's setup should be portable,
# not per-machine. Harmless for other agent tools.
mkdir -p .claude/skills
for skill_dir in skills/*/; do
  skill_name="$(basename "$skill_dir")"
  if [ ! -e ".claude/skills/$skill_name" ]; then
    ln -s "../../skills/$skill_name" ".claude/skills/$skill_name"
    echo "  +  .claude/skills/$skill_name -> ../../skills/$skill_name"
  fi
done

echo ""
echo "=== loop-kit: bootstrapped $TARGET ==="
echo ""
echo "Generated files:"
echo "  SESSION.md                        ← session-start prompt (give this to your agent)"
echo "  AGENTS.md                         ← operating model + principles (fill in <!-- TODO -->)"
echo "  STATE.md                          ← session memory"
echo "  docs/laundry_list.md              ← ranked backlog"
echo "  docs/done_laundry_list.md         ← completed items"
echo "  skills/disciplined-coding/        ← disciplined coding skill"
echo "  skills/design/                    ← frontend design skill"
echo "  skills/usability-heuristics/      ← usability evaluation skill"
echo "  .agents/reviewer.md               ← code review sub-agent"
echo "  .agents/security-auditor.md       ← security audit sub-agent"
echo "  .github/workflows/loop-triage.yml ← scheduled triage (manual-only until you enable the cron)"
echo "  .claude/skills/*                  ← Claude Code skill symlinks (commit these)"
echo ""
echo "Next steps:"
echo "  1. Edit AGENTS.md — fill in <!-- TODO --> placeholders"
echo "  2. Populate docs/laundry_list.md by auditing your codebase"
echo "  3. Add project-specific skills under skills/<name>/SKILL.md"
echo "  4. Enable the cron in .github/workflows/loop-triage.yml when the list is trustworthy"
echo "  5. Commit: git add . && git commit -m 'feat: establish loop engineering operating model'"
echo ""
echo "The loop is ready. Next session:"
echo "  1. Give SESSION.md to your agent as the session-start prompt"
echo "  2. The agent reads STATE.md + docs/laundry_list.md and runs the operating loop"
echo "  3. The agent ships a PR with verification evidence — the human reviews it (Ship gate)"
FTR
} > scripts/loop-init.sh

chmod +x scripts/loop-init.sh
echo "scripts/loop-init.sh regenerated from templates/"
