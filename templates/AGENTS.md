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
