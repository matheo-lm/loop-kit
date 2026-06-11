#!/usr/bin/env bash
# loop-init.sh — bootstrap loop engineering into any codebase
# Usage: curl -fsSL https://raw.githubusercontent.com/matheo-lm/loop-kit/main/scripts/loop-init.sh | bash
#   or:  ./loop-init.sh /path/to/project

set -euo pipefail

TARGET="${1:-.}"
cd "$TARGET"

echo "=== loop-kit: bootstrapping $TARGET ==="

# ── helpers ──────────────────────────────────────────────────────────
write_if_missing() {
  local file="$1"
  local content="$2"
  if [ -f "$file" ]; then
    echo "  ⏭  $file (already exists)"
  else
    mkdir -p "$(dirname "$file")"
    cat > "$file" <<< "$content"
    echo "  ✓ $file"
  fi
}

# ── 1. SESSION.md — session-start prompt ────────────────────────────
write_if_missing "SESSION.md" \
'# Session start

Read `AGENTS.md` completely before doing anything else. It is the canonical agent guide and overrides all other instructions.

Then read `STATE.md` and `docs/soul.md` to understand current state and priorities.

---

# Objective

Deliver one complete item from `docs/soul.md` and leave it in a merge-ready state.

Optimize for the highest-impact user-facing outcome. If no items are clear, audit the codebase and populate `docs/soul.md` with findings.

---

# Operating Loop

Remain in the following loop until exit criteria are satisfied.

## Phase 1: Gather Evidence

Before proposing work:

1. Read:
   - `AGENTS.md`
   - `STATE.md`
   - `docs/soul.md`
   - `docs/done_soul.md`

2. Refresh repository state:
   - `git pull origin <branch>`
   - Verify task metadata against actual code state

3. Treat all task metadata as potentially stale. Never trust status fields, dependency declarations, or implementation assumptions until verified in code.

---

## Phase 2: Build Candidates

Identify the top candidate items from `docs/soul.md`.

For each candidate, note:
- user-facing impact
- dependencies
- risk level
- affected files
- verification scope

Rank by:
1. User impact
2. Priority/severity
3. Readiness (dependencies met, blocked on nothing)
4. Implementation efficiency

Explicitly state why lower-ranked candidates were rejected.

---

## Phase 3: Commit to One Item

Before coding, present:

### Selected Item
- what it is
- rationale for selection
- dependencies verified
- files expected to change

### Out of Scope
List what will not be touched.

### Acceptance Criteria
For the item:
- required behavior
- tests required (if any)
- verification required

If work touches:
- payments/billing
- auth/access control
- data deletion
- irreversible public behavior

STOP and request approval. Otherwise proceed.

---

## Phase 4: Implement

Work incrementally. After each meaningful change:
1. Re-read affected code.
2. Verify assumptions still hold.
3. Update plan if new evidence appears.
4. Avoid broad refactors.

Prefer the smallest change that satisfies acceptance criteria.

---

## Phase 5: Reality Check

After implementation:

### Verify
Run the project'\''s validation:
- touched unit tests
- typecheck
- lint
- build (when applicable)

Do not fix unrelated failures.

### Evaluate
Ask:
- Did the change satisfy the acceptance criteria?
- Did it introduce new work?
- Did it invalidate remaining items?

If not satisfied, revise and re-verify. If blocked, update `STATE.md` blockers and exit.

---

# Non-Negotiable Rules

- Never commit directly to `main`. Use a feature branch.
- Never merge without approval.
- No emoji in product UI.
- Follow `AGENTS.md` operating principles (think, simplicity, surgical, goal-driven).
- No refactoring beyond what the selected item requires.
- When modifying API behavior, update `.env.example`, docs, and README.

---

# Bookkeeping

When an item is complete:
1. Move it from `docs/soul.md` to `docs/done_soul.md`
2. Preserve all content — add completion date and implementation notes
3. Never delete items; always move

If new work is discovered:
- Add it to `docs/soul.md` with severity and location
- Never leave findings only in conversation

---

# Exit Criteria

Do not declare success until ALL are true:
- acceptance criteria satisfied
- dependencies verified
- validation passing (typecheck, lint, tests)
- no new work left undocumented
- bookkeeping updated
- feature branch pushed
- remaining risks documented in `STATE.md`

If any criterion is unmet, continue the loop.
'

# ── 2. docs/done_soul.md — completed items ───────────────────────────
write_if_missing "docs/done_soul.md" \
'# done soul

completed items from `docs/soul.md`. nothing is deleted — only moved here.

**read this to avoid re-fixing what'\''s already fixed.**

---

| date completed | area | original item | notes |
|----------------|------|---------------|-------|
| yyyy-mm-dd | ux/ui | item text | implementation notes |
'

# ── 3. AGENTS.md — operating model ───────────────────────────────────
write_if_missing "AGENTS.md" \
'# Repository Guidelines

Read `SESSION.md` before starting a session. It defines the operating loop.

## Operating Principles

These principles govern every agent interaction. Read them first. Apply them always.

### 1. Think Before Coding
Don'\''t assume. Don'\''t hide confusion. Surface tradeoffs.
- State your assumptions explicitly before implementing. If uncertain, ask.
- If multiple interpretations exist, present them — don'\''t pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what'\''s confusing. Ask.

### 2. Simplicity First
Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked. No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn'\''t requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Ask: "Would a senior engineer say this is overcomplicated?"

### 3. Surgical Changes
Touch only what you must. Clean up only your own mess.
- Don'\''t "improve" adjacent code, comments, or formatting.
- Don'\''t refactor things that aren'\''t broken.
- Match existing style, even if you'\''d do it differently.
- If you notice unrelated dead code, mention it — don'\''t delete it.
- Every changed line should trace directly to the user'\''s request.

### 4. Goal-Driven Execution
Define success criteria. Loop until verified.
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"
- For multi-step tasks, state a brief plan with verification checkpoints:
  ```
  1. [step] → verify: [check]
  2. [step] → verify: [check]
  ```
- Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Loop Engineering: How We Operate

This project uses loop engineering as its operating model. The agent doesn'\''t just respond — it discovers, plans, develops, and iterates autonomously within a designed system.

### The Loop

```
STATE.md → read memory → plan → implement → verify → update STATE.md → loop
```

### The Five Pieces

1. **Memory** — `STATE.md` tracks what'\''s done, what'\''s next, and open blockers. The agent reads this at session start and writes to it at session end. The model forgets; the repo doesn'\''t.
2. **Skills** — `SKILL.md` files codify project knowledge so every agent doesn'\''t re-derive it from zero. Conventions, build steps, rationale — written once, read every run.
3. **Sub-agents** — Maker and checker are separated. Defined in `.opencode/agents/`. The agent that writes is never the sole agent that grades.
4. **Automations** — Scheduled workflows run discovery and triage without human prompting. Findings land in STATE.md for the next agent session.
5. **Worktrees** — For parallel work, use `git worktree` isolation so concurrent agents don'\''t collide.

### Session Ritual

Follow the phased operating loop in `SESSION.md` — it is the canonical session protocol.

In summary:
1. **Sync**: `git pull origin <branch>`.
2. **Start**: Read `STATE.md`, `docs/soul.md`, `docs/done_soul.md`.
3. **Phase 1-3**: Gather evidence, build candidates, commit to one item.
4. **Phase 4-5**: Implement, verify, evaluate.
5. **Bookkeeping**: Update `STATE.md`, move completed items from `docs/soul.md` to `docs/done_soul.md`.
6. **Commit + push**: Feature branch, conventional commit.
7. **Loop**: If exit criteria not met, return to step 2.

---

## Project Structure & Module Organization
<!-- TODO: describe your project structure here -->

## Build, Test, and Development Commands
<!-- TODO: list your build, dev, test, typecheck, lint commands here -->

## Coding Style & Naming Conventions
<!-- TODO: describe your naming conventions and style rules -->

## Testing Guidelines
<!-- TODO: describe testing approach, test runner, coverage expectations -->

## Commit & Pull Request Guidelines
<!-- TODO: describe commit message format, PR process -->
'

# ── 4. STATE.md — session memory ────────────────────────────────────
write_if_missing "STATE.md" \
'# state
> last updated: <date>

## current goal
<what we are working on right now>

## progress
- [ ] task 1
- [ ] task 2

## findings
<discoveries, decisions, rationale>

## blockers
<what is blocking progress — be specific>

## next actions
1. first thing to do
2. second thing

---

## session log
| date | work | next |
|------|------|------|
| yyyy-mm-dd | <done> | <next> |
'

# ── 5. SKILL.md — disciplined coding ────────────────────────────────
write_if_missing "SKILL.md" \
'# disciplined-coding

Use for any code change that requires disciplined implementation rigor — not trivial one-liners.

## before you write code
- State your assumptions explicitly. If uncertain, ask.
- If the task is ambiguous, list the possible interpretations — don'\''t pick silently.
- If a clearly simpler approach exists, recommend it. Push back if warranted.
- If you are confused about any aspect, stop and ask.

## while you write code
- Write the minimum code that solves the exact problem. Nothing more.
- Do not add features, abstractions, or configuration options beyond what was asked.
- Touch only the lines that need to change. Match existing style exactly.
- Do not add error handling for impossible scenarios.
- When removing code, clean up imports and variables that YOUR change made unused.

## after you write code
- Can every changed line be traced to the user'\''s request? If not, undo it.
- Would a senior engineer say this is overcomplicated? If yes, simplify.
- Run the project'\''s validation commands and fix any issues before declaring done.

## verification pattern
For any multi-step change, structure your plan as:
```
1. [step] → verify: [how you will check]
2. [step] → verify: [how you will check]
3. [step] → verify: [how you will check]
```
'

# ── 6. Sub-agents ────────────────────────────────────────────────────
write_if_missing ".opencode/agents/reviewer.md" \
'# reviewer

A code review sub-agent that evaluates work done by the primary agent.

## instructions
1. **Goal check**: Does the change satisfy the stated goal? If not, reject and explain why.
2. **Simplicity check**: Is there any code, abstraction, or config that wasn'\''t asked for? Flag it.
3. **Surgical check**: Does the diff touch files unrelated to the goal? Flag it.
4. **Style check**: Does the change match the project'\''s existing conventions?
5. **Type/lint/test check**: Would the project'\''s validation pass?
6. **Safety check**: Could this break other parts of the system?

## output
- **approve**: no issues found
- **changes requested**: list each issue with file:line and the exact fix needed
- **blocked**: critical issue that must be addressed before merging
'

write_if_missing ".opencode/agents/security-auditor.md" \
'# security-auditor

Security audit sub-agent for changes touching auth, APIs, or user input.

## instructions
1. **Input safety**: If user-controlled text is accepted, verify it is normalized, capped in length, and not passed raw into anything.
2. **Data leakage**: Verify no internal tracing, model names, or debug metadata is returned in responses.
3. **Auth**: Are auth/health checks in place for endpoints? Are tokens handled correctly?
4. **Rate limiting**: Are API endpoints protected from abuse?
5. **Env vars**: If new environment variables were added, verify they are documented.

## output
- **clean**: no security concerns
- **advisory**: minor concern with recommendation
- **blocked**: must-fix issue with file:line and remediation
'

# ── 7. docs/soul.md — quality gap tracker ────────────────────────────
write_if_missing "docs/soul.md" \
'# soul

the living memory of what needs love in this project. gaps, debts, and broken windows
we know about. nothing here gets deleted — only moved to done when fixed.

**read this before any session.** pick one item, fix it, mark it done.

---

## ux/ui
- [ ] item with location and description (severity)

## code quality
- [ ] item with location and description (severity)

## security
- [ ] item with location and description (severity)

## testing & coverage
- [ ] item with location and description (severity)

## parity
- [ ] item with location and description (severity)

## config & infra
- [ ] item with location and description (severity)

---

## stats
| area | count |
|------|-------|
| ux/ui | 0 |
| code quality | 0 |
| security | 0 |
| testing | 0 |
| parity | 0 |
| config/infra | 0 |
| **total** | **0** |
'

# ── 8. Starter skills ────────────────────────────────────────────────
write_if_missing "templates/skills/design/SKILL.md" \
'# design

Frontend design guidelines adapted from Anthropic'\''s frontend-design skill.
Use when building or refining UI components, pages, or visual design.

## when to use
- building or restyling any component
- creating new layouts, modals, or screens
- refining visual polish, motion, or typography

## design thinking
Before coding, understand the context and commit to a clear aesthetic direction:
- **Purpose**: What does this interface solve? Who uses it?
- **Tone**: refined minimalism. intentional. never chaotic or loud.
- **Differentiation**: what makes this unforgettable? extreme refinement. every pixel intentional.

## frontend aesthetics guidelines

### typography
- Choose fonts that fit the project'\''s character. Avoid generic system fonts, Inter, Roboto, Arial.
- Pair a distinctive display font with a refined body font.
- Use CSS custom properties for consistent font stacks.

### color & theme
- Commit to a cohesive palette via CSS custom properties.
- Dominant colors with sharp accents outperform timid palettes.
- Keep contrast ratios accessible (WCAG AA minimum).

### motion
- Use animation for purposeful feedback, not decoration.
- Always respect `prefers-reduced-motion`.
- Keep durations short (150-300ms micro-interactions).

### spatial composition
- Generous negative space. Controlled density. Intentional alignment.
- Avoid visual clutter. Every element earns its place.

### avoid these cliches
- Purple gradients on dark backgrounds
- Generic sans-serif everywhere
- Cookie-cutter card layouts with rounded corners + shadow
- Over-engineered animations that serve no purpose
- Trend-driven aesthetics (glassmorphism, neubrutalism)
'

# ── 9. .gitignore ─────────────────────────────────────────────────────
write_if_missing ".gitignore" \
'node_modules/
dist/
.tmp/
*.log
.DS_Store
'

echo ""
echo "=== loop-kit: bootstrapped $TARGET ==="
echo ""
echo "Generated files:"
echo "  SESSION.md      ← session-start prompt (give this to your agent)"
echo "  AGENTS.md       ← operating model + principles (fill in <!-- TODO -->)"
echo "  STATE.md        ← session memory"
echo "  SKILL.md        ← disciplined coding"
echo "  docs/soul.md    ← quality gap tracker"
echo "  docs/done_soul.md ← completed items"
echo "  .opencode/agents/reviewer.md"
echo "  .opencode/agents/security-auditor.md"
echo ""
echo "Next steps:"
echo "  1. Edit AGENTS.md — fill in <!-- TODO --> placeholders"
echo "  2. Populate docs/soul.md by auditing your codebase"
echo "  3. Add project-specific skills under templates/skills/<name>/SKILL.md"
echo "  4. Add automations under .github/workflows/ as needed"
echo "  5. Commit: git add . && git commit -m 'feat: establish loop engineering operating model'"
echo ""
echo "The loop is ready. Next session:"
echo "  1. Give SESSION.md to your agent as the session-start prompt"
echo "  2. The agent reads STATE.md + soul.md and starts the operating loop"
echo "  3. After session: agent updates STATE.md and commits"
