# Repository Guidelines

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
- Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

## Loop Engineering: How We Operate

This project uses loop engineering as its operating model. The agent doesn't just respond — it discovers, plans, develops, and iterates autonomously within a designed system.

### The Loop

```
STATE.md → read memory → plan → implement → verify → update STATE.md → loop
```

### The Five Pieces

1. **Memory** — `STATE.md` tracks what's done, what's next, and open blockers. The agent reads this at session start and writes to it at session end. The model forgets; the repo doesn't.
2. **Skills** — `SKILL.md` files codify project knowledge so every agent doesn't re-derive it from zero.
3. **Sub-agents** — Maker and checker are separated. The agent that writes is never the sole agent that grades.
4. **Automations** — Scheduled workflows run discovery and triage without human prompting.
5. **Worktrees** — For parallel work, use `git worktree` isolation so concurrent agents don't collide.

### How To Operate Each Session

1. **Sync**: `git pull origin <branch>` to synchronize with remote.
2. **Start**: Read `STATE.md`. Understand what's in progress, what's blocked, what's next.
3. **Plan**: State your assumptions. List steps with verification criteria.
4. **Execute**: Surgical, simple changes. Match existing patterns exactly.
5. **Verify**: Run `<typecheck> && <lint> && <test>`.
6. **Record**: Update `STATE.md`.
7. **Commit**: Conventional commit message (`feat:`, `fix:`, `chore:`).
8. **Push**: `git push origin <branch>`.
9. **Loop**: If the goal isn't met, return to step 2.

---

## Project Structure
<!-- TODO: describe your project structure here -->

## Build Commands
<!-- TODO: list your build, dev, test, typecheck, lint commands here -->

## Coding Style
<!-- TODO: describe your naming conventions and style rules -->

## Testing Guidelines
<!-- TODO: describe testing approach, test runner, coverage expectations -->
