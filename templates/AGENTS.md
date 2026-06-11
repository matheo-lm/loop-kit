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

## Project Structure
<!-- TODO: describe your project structure here -->

## Build Commands
<!-- TODO: list your build, dev, test, typecheck, lint commands here -->

## Coding Style
<!-- TODO: describe your naming conventions and style rules -->

## Testing Guidelines
<!-- TODO: describe testing approach, test runner, coverage expectations -->
