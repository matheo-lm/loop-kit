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

# ── 1. SESSION.md — session-start prompt ─────────────────────────────
write_if_missing "SESSION.md" << 'TEMPLATE_EOF'
# Session start

Read `AGENTS.md` completely before doing anything else. It is the canonical agent guide and overrides all other instructions.

Then read `STATE.md` and `docs/laundry_list.md` to understand current state and priorities.

---

# Objective

Deliver one complete item from `docs/laundry_list.md` and leave it in a merge-ready state.

Optimize for the highest-impact user-facing outcome. If no items are clear, audit the codebase and populate `docs/laundry_list.md` with findings.

---

# The Two Human Gates

The human engineers the loop; the loop runs the work. The human is involved at exactly two points:

1. **Frame gate** (end of Phase 3) — if the selected item is ambiguous, has multiple valid interpretations, or touches the STOP list, ask before writing code. Questions before work are cheap; questions after mistakes are expensive.
2. **Ship gate** (the PR) — the human reviews finished, verified work with evidence attached.

Between the gates, run to completion. Do not stop to ask "shall I proceed?", present intermediate artifacts for sign-off, or request permission between phases. Once framing is settled, it converts into acceptance criteria and the loop runs autonomously through implement → verify → ship. The only legitimate mid-loop stop is being blocked on input only the human has.

---

# Operating Loop

Remain in the following loop until exit criteria are satisfied.

## Phase 1: Gather Evidence

Before proposing work:

1. Read:
   - `AGENTS.md`
   - `STATE.md`
   - `docs/laundry_list.md`
   - `docs/done_laundry_list.md`

2. Refresh repository state:
   - `git pull origin <branch>`
   - Verify task metadata against actual code state

3. Treat all task metadata as potentially stale. Never trust status fields, dependency declarations, or implementation assumptions until verified in code.

---

## Phase 2: Build Candidates

Identify the top candidate items from `docs/laundry_list.md`.

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

Before coding, record:

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

This is the Frame gate. If work touches:
- payments/billing
- auth/access control
- data deletion
- irreversible public behavior

STOP and request approval. Likewise ask now if the item is ambiguous or has multiple valid interpretations. Otherwise proceed — no further check-ins until the PR.

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
Run the project's validation:
- touched unit tests
- typecheck
- lint
- build (when applicable)

Do not fix unrelated failures.

### Review (maker ≠ checker)
The work is graded by a pass that did not write it:
- Dispatch `.agents/reviewer.md` as a sub-agent to review the diff against the acceptance criteria. If your tool has no sub-agents, re-read the full diff cold against the criteria before declaring done.
- If the change touched auth, API surfaces, or user input handling, also run `.agents/security-auditor.md`.
- If the change touched user-facing UI, evaluate the changed screens against `skills/usability-heuristics/SKILL.md` — findings of severity 3+ block the ship.
- Address "changes requested" and "blocked" findings before shipping. Findings are inputs, not truth — the primary agent owns consolidation.

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
- Follow `AGENTS.md` operating principles (think, simplicity, surgical, goal-driven) and project conventions.
- No refactoring beyond what the selected item requires.
- When modifying API behavior, update `.env.example`, docs, and README.

---

# Bookkeeping

When an item is complete:
1. Move it from `docs/laundry_list.md` to `docs/done_laundry_list.md`
2. Preserve all content — add completion date and implementation notes
3. Never delete items; always move

If new work is discovered:
- Add it to `docs/laundry_list.md` with severity and location
- Never leave findings only in conversation

---

# Ship

Open a pull request (the Ship gate):
- Concise summary of what changed and why.
- Verification evidence in the body — the commands you ran and their output, not assertions.
- If anything failed or was skipped, say so plainly.

The human reviews the finished PR, not intermediate artifacts.

---

# Exit Criteria

Do not declare success until ALL are true:
- acceptance criteria satisfied
- dependencies verified
- validation passing (typecheck, lint, tests)
- reviewer findings addressed
- no new work left undocumented
- bookkeeping updated
- feature branch pushed and PR opened with verification evidence in the body
- remaining risks documented in `STATE.md`

If any criterion is unmet, continue the loop.
TEMPLATE_EOF

# ── 2. AGENTS.md — operating model ─────────────────────────────
write_if_missing "AGENTS.md" << 'TEMPLATE_EOF'
# Repository Guidelines

Read `SESSION.md` before starting a session. It defines the operating loop.

## Operating Principles

These principles govern every agent interaction. Read them first. Apply them always.

### 1. Think Before Coding
Don't assume. Don't hide confusion. Surface tradeoffs.
- State your assumptions explicitly before implementing. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First
Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked. No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Ask: "Would a senior engineer say this is overcomplicated?"

### 3. Surgical Changes
Touch only what you must. Clean up only your own mess.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Every changed line should trace directly to the user's request.

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

This project uses loop engineering as its operating model. The agent doesn't just respond — it discovers, plans, develops, and iterates autonomously within a designed system.

### The Loop

```
STATE.md → read memory → plan → implement → verify → update STATE.md → loop
```

### The Five Pieces

1. **Memory** — `STATE.md` tracks the current goal and blockers; `docs/laundry_list.md` is the ranked backlog and `docs/done_laundry_list.md` the archive. The agent reads them at session start and writes at session end. The model forgets; the repo doesn't.
2. **Skills** — `skills/<name>/SKILL.md` files codify project knowledge so every agent doesn't re-derive it from zero. Conventions, build steps, rationale — written once, read every run. Each skill carries YAML frontmatter (`name`, `description`) so agent tools can discover it; for Claude Code, symlink skills into `.claude/skills/` (`ln -s ../../skills/<name> .claude/skills/<name>`).
3. **Sub-agents** — Maker and checker are separated. Defined in `.agents/` (agent-agnostic; for Claude Code, copy or symlink into `.claude/agents/`). The agent that writes is never the sole agent that grades.
4. **Automations** — Scheduled workflows run discovery and triage without human prompting. `.github/workflows/loop-triage.yml` surfaces open laundry-list items as a recurring issue; enable its cron when the list is trustworthy.
5. **Worktrees** — For parallel work, use `git worktree` isolation so concurrent agents don't collide.

### The Two Human Gates

The human engineers the loop, not its per-cycle prompter. Exactly two gates: **Frame** (clarifying questions before code, when ambiguous or on the STOP list) and **Ship** (the PR, with verification evidence). Between them, run to completion — `SESSION.md` defines both gates.

### Session Ritual

Follow the phased operating loop in `SESSION.md` — it is the canonical session protocol.

In summary:
1. **Sync**: `git pull origin <branch>`.
2. **Start**: Read `STATE.md`, `docs/laundry_list.md`, `docs/done_laundry_list.md`.
3. **Phase 1-3**: Gather evidence, build candidates, commit to one item (Frame gate).
4. **Phase 4-5**: Implement, verify, review, evaluate.
5. **Bookkeeping**: Update `STATE.md`, move completed items from `docs/laundry_list.md` to `docs/done_laundry_list.md`.
6. **Ship**: Feature branch, conventional commit, PR with verification evidence (Ship gate).
7. **Loop**: If exit criteria not met, return to step 2.

### Red Flags

These thoughts mean stop — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is too simple to need acceptance criteria" | Simple items with unexamined assumptions are where rework comes from. Two lines is enough. |
| "I'll just fix this adjacent thing while I'm here" | Scope creep breaks surgical changes. Add it to `docs/laundry_list.md` instead. |
| "Tests probably pass" / "this should work now" | Evidence before claims. Run them. |
| "I'll check with the human if this looks good so far" | Mid-loop permission-seeking re-inserts the human into the cycle. Verify against the criteria and ship. |
| "The status says done, so it's done" | Statuses go stale. Verify against the code. |
| "I'll update the docs in a follow-up" | The follow-up never comes. Same change, same PR. |

### Comprehension Debt

Loop velocity must not outpace understanding. The human reads the diffs; the agent writes PR descriptions that make the diff comprehensible — what changed, why, and what was verified. If a change can't be explained plainly in the PR body, it isn't ready to ship.

---

## Project Structure & Module Organization
<!-- TODO: describe your project structure here -->

## Build, Test, and Development Commands
<!-- TODO: list your build, dev, test, typecheck, lint commands here -->

## Coding Style & Naming Conventions
<!-- TODO: describe your naming conventions and style rules (e.g., "no emoji in product UI") -->

## Testing Guidelines
<!-- TODO: describe testing approach, test runner, coverage expectations -->

## Commit & Pull Request Guidelines
<!-- TODO: describe commit message format, PR process -->
TEMPLATE_EOF

# ── 3. STATE.md — session memory ─────────────────────────────
write_if_missing "STATE.md" << 'TEMPLATE_EOF'
# state
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
TEMPLATE_EOF

# ── 4. docs/laundry_list.md — ranked backlog ─────────────────────────────
write_if_missing "docs/laundry_list.md" << 'TEMPLATE_EOF'
# laundry list

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
TEMPLATE_EOF

# ── 5. docs/done_laundry_list.md — completed items ─────────────────────────────
write_if_missing "docs/done_laundry_list.md" << 'TEMPLATE_EOF'
# done laundry list

completed items from `docs/laundry_list.md`. nothing is deleted — only moved here.

**read this to avoid re-fixing what's already fixed.**

---

| date completed | area | original item | notes |
|----------------|------|---------------|-------|
| yyyy-mm-dd | ux/ui | item text | implementation notes |
TEMPLATE_EOF

# ── 6. skill — disciplined coding ─────────────────────────────
write_if_missing "skills/disciplined-coding/SKILL.md" << 'TEMPLATE_EOF'
---
name: disciplined-coding
description: Use for any code change that requires disciplined implementation rigor — not trivial one-liners.
---

# disciplined-coding

## before you write code
- State your assumptions explicitly. If uncertain, ask.
- If the task is ambiguous, list the possible interpretations — don't pick silently.
- If a clearly simpler approach exists, recommend it. Push back if warranted.
- If you are confused about any aspect, stop and ask.

## while you write code
- Write the minimum code that solves the exact problem. Nothing more.
- Do not add features, abstractions, or configuration options beyond what was asked.
- Touch only the lines that need to change. Match existing style exactly.
- Do not add error handling for impossible scenarios.
- When removing code, clean up imports and variables that YOUR change made unused.

## after you write code
- Can every changed line be traced to the user's request? If not, undo it.
- Would a senior engineer say this is overcomplicated? If yes, simplify.
- Run the project's validation commands and fix any issues before declaring done.

## verification pattern
For any multi-step change, structure your plan as:
```
1. [step] → verify: [how you will check]
2. [step] → verify: [how you will check]
3. [step] → verify: [how you will check]
```
TEMPLATE_EOF

# ── 7. skill — frontend design ─────────────────────────────
write_if_missing "skills/design/SKILL.md" << 'TEMPLATE_EOF'
---
name: design
description: Use when building or refining UI components, pages, or visual design.
---

# design

Frontend design guidelines adapted from Anthropic's frontend-design skill.

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
- Choose fonts that fit the project's character. Avoid generic system fonts, Inter, Roboto, Arial.
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
TEMPLATE_EOF

# ── 8. skill — usability heuristics ─────────────────────────────
write_if_missing "skills/usability-heuristics/SKILL.md" << 'TEMPLATE_EOF'
---
name: usability-heuristics
description: Use when designing or reviewing any user-facing surface — evaluate against Nielsen's 10 usability heuristics, name the violated heuristic, and rate severity 0-4 so findings are prioritized fixes, not opinions.
---

# usability-heuristics

Condensed from the usability canon — Jakob Nielsen's 10 heuristics (NN/g), Don Norman's signifiers and feedback, Ben Shneiderman's golden rules, Dieter Rams' "less, but better". Structure inspired by [jpoindexter/design-and-ai-skills](https://github.com/jpoindexter/design-and-ai-skills).

A finding without a principle is an opinion; a finding without severity can't be prioritized. When you flag a problem: name the heuristic, rate the severity, propose the fix.

## the 10 heuristics

| # | Heuristic | Rule of thumb | Typical fix |
|---|-----------|---------------|-------------|
| H1 | Visibility of system status | Every action gives immediate feedback; every wait shows progress. | Loading states, disabled-on-submit, explicit success/failure confirmation. |
| H2 | Match the real world | Speak the user's language, never internal codes or jargon. | Translate errors to plain language; use the words real users use. |
| H3 | User control and freedom | Every state has a clearly marked exit; mistakes are reversible. | Cancel/Back everywhere; prefer an undo toast over a confirm nag. |
| H4 | Consistency and standards | Same word, color, and position for the same action; follow platform conventions. | One term per concept; use the design system, not bespoke variants. |
| H5 | Error prevention | Design so the error can't happen, rather than reporting it well. | Constrain inputs (pickers, masks, disabled invalid options); validate inline before submit. |
| H6 | Recognition over recall | Show options and carry context forward; never make users remember across screens. | Autocomplete, recents, visible choices, prefilled data, placeholders. |
| H7 | Flexibility and efficiency | Accelerators for experts that stay invisible to novices. | Shortcuts, bulk actions, saved views — behind progressive disclosure. |
| H8 | Aesthetic and minimalist design | Every extra element competes with the relevant ones. | Cut ruthlessly; one primary action per screen; disclose detail on demand. |
| H9 | Help users recover from errors | Errors say what happened, why, and how to fix it — in plain language, at the point of error. | Specific inline messages; preserve the user's input. |
| H10 | Help and documentation | Best is needing none; otherwise contextual, searchable, task-focused. | Tooltips and guided empty states over manuals. |

Also check (Norman): every interactive element has a visible signifier — nothing clickable should look like plain text, and nothing decorative should look clickable.

## evaluation method

1. Walk the interface twice: once for flow, once inspecting each element against every heuristic.
2. Log each problem: location, heuristic violated, why it's a problem, severity, recommended fix.
3. Sort by severity descending; fix top-down.

Severity scale (Nielsen, 0-4):

| Rating | Meaning | Action |
|--------|---------|--------|
| 0 | Not a usability problem | Ignore |
| 1 | Cosmetic | Fix if spare time |
| 2 | Minor | Schedule |
| 3 | Major | Fix before release |
| 4 | Catastrophe | Block release |

## common violations

- Silent submit button → double-charge from re-tapping (H1): disable on tap, show progress, confirm result.
- Raw error codes surfaced to users (`HTTP 500`, `EACCES`) (H2, H9): plain-language what/why/fix.
- Destructive or bulk action with no undo (H3, H5): undo window, or type-to-confirm for the irreversible.
- "Submit" / "Send" / "Go" all meaning the same action (H4): one term, everywhere.
- Free-text field where a picker fits; server-side-only validation (H5): constrain and validate inline.
- Form clears the user's input on error (H9): preserve everything they typed.

## when reviewing a diff

If the change touches anything user-facing, run the table above against the changed screens and report findings in the evaluation format: `location · heuristic · why · severity · fix`. Findings of severity 3+ block the ship.
TEMPLATE_EOF

# ── 9. sub-agent — reviewer ─────────────────────────────
write_if_missing ".agents/reviewer.md" << 'TEMPLATE_EOF'
# reviewer

A code review sub-agent that evaluates work done by the primary agent.

## instructions
1. **Goal check**: Does the change satisfy the stated goal? If not, reject and explain why.
2. **Simplicity check**: Is there any code, abstraction, or config that wasn't asked for? Flag it.
3. **Surgical check**: Does the diff touch files unrelated to the goal? Flag it.
4. **Style check**: Does the change match the project's existing conventions?
5. **Type/lint/test check**: Would the project's validation pass?
6. **Safety check**: Could this break other parts of the system?

## output
- **approve**: no issues found
- **changes requested**: list each issue with file:line and the exact fix needed
- **blocked**: critical issue that must be addressed before merging
TEMPLATE_EOF

# ── 10. sub-agent — security auditor ─────────────────────────────
write_if_missing ".agents/security-auditor.md" << 'TEMPLATE_EOF'
# security-auditor

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
TEMPLATE_EOF

# ── 11. automation — scheduled triage ─────────────────────────────
write_if_missing ".github/workflows/loop-triage.yml" << 'TEMPLATE_EOF'
name: loop-triage

# Scheduled discovery: surfaces open laundry-list items as a recurring triage
# issue so the loop has fresh input without human prompting.
# Manual-only by default — uncomment the schedule block to enable the cron
# once your laundry list is trustworthy.
on:
  workflow_dispatch:
  # schedule:
  #   - cron: "0 6 * * 1" # Mondays 06:00 UTC

permissions:
  contents: read
  issues: write

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Open or update the triage issue
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          open_items="$(grep -n '^- \[ \]' docs/laundry_list.md || true)"
          if [ -z "$open_items" ]; then
            open_items="(none - populate docs/laundry_list.md)"
          fi
          title="loop-triage: open laundry list items"
          body="$(printf 'Open items in docs/laundry_list.md as of %s:\n\n```\n%s\n```' "$(date -u +%F)" "$open_items")"
          existing="$(gh issue list --state open --search "\"$title\" in:title" --json number --jq '.[0].number // empty')"
          if [ -n "$existing" ]; then
            gh issue comment "$existing" --body "$body"
          else
            gh issue create --title "$title" --body "$body"
          fi
TEMPLATE_EOF

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
