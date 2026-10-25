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

### The Seven Pieces

1. **Memory** — `STATE.md` tracks the current goal and blockers; the open GitHub issues labelled `laundry` are the ranked backlog (priority `P0` to `P3`, area labels) and the closed ones the archive (`docs/laundry_list.md` says how). The agent reads them at session start and writes at session end. The model forgets; the repository and its issues don't.
2. **Skills** — `skills/<name>/SKILL.md` files codify project knowledge so every agent doesn't re-derive it from zero. Conventions, build steps, rationale — written once, read every run. Each skill carries YAML frontmatter (`name`, `description`) so agent tools can discover it; for Claude Code, symlink skills into `.claude/skills/` (`ln -s ../../skills/<name> .claude/skills/<name>`).
3. **Sub-agents** — Maker and checker are separated. Defined in `.agents/` (agent-agnostic; for Claude Code, copy or symlink into `.claude/agents/`). The agent that writes is never the sole agent that grades.
4. **Automations** — Scheduled workflows run discovery and triage without human prompting. `.github/workflows/loop-triage.yml` posts the open `laundry` issues as a recurring digest; enable its cron when the backlog is trustworthy.
5. **Worktrees** — For parallel work, use `git worktree` isolation so concurrent agents don't collide.
6. **Human attention** — A human-only need is asked live when the human is in the chat and recorded in the item (`WAITING ON HUMAN`) when nobody can answer; only a critical need becomes a `human-action` issue, per `skills/human-attention/SKILL.md`. The scheduled attention check, run from the control repository, is the only thing that reaches the human for issues; the daily changelog lists what waits. Answers come back as recorded decisions. Agents never notify the human directly.
7. **Intake** — The human's raw thoughts, bugs, ideas and feedback land in one private Slack channel; the scheduled intake check in `docs/intake.md` turns each message into a laundry-list item after a gap analysis (`skills/intake/SKILL.md`), asks in the thread when the ask is unclear, and never does the work itself. The loop's inbound half; human attention is the outbound half.

Pieces 6 and 7 are cross-repository: when several repositories share one human, they run once from a private control repository that also keeps `docs/scheduled-tasks.md`, the registry of scheduled tasks.

### The Two Human Gates

The human engineers the loop, not its per-cycle prompter. Exactly two gates: **Frame** (clarifying questions before code, when ambiguous or on the STOP list) and **Ship** (the PR, with verification evidence). Between them, run to completion — `SESSION.md` defines both gates.

### Stay the Engineer (human-only decisions)

Unattended loops make mistakes unattended. These stop the loop for an explicit human decision, even mid-run and regardless of approvals earlier in the session:
- Production writes: migrations, data changes, ingestion runs, paid batch jobs. Ask each time; access to a system is not approval.
- Deleting user data.
- Payments and billing.
- Auth and access control.
- Publishing outward: email sends, broadcasts, social posts, anything external.
- Overriding a decision already recorded in the backlog or docs.

### Questions and Confidence

- **Ask with the structured question tool** (Claude Code: AskUserQuestion), not buried in prose. Recommend one option and say why. Batch related questions into one call.
- **Ask only what is the human's to decide.** Choosing the next item or vertical, how to implement it and what to do after it are the agent's job; do not hand them back as questions.
- **Human-only needs are asked live or recorded**, per `skills/human-attention/SKILL.md`: in an attended session, ask with the structured question tool and write the answer into the item, `STATE.md` or the shared memory; unattended, record `WAITING ON HUMAN` in the item and continue; only a critical need becomes a `human-action` issue. The record is the written answer, never the chat alone.
- **Unanswered questions are recorded, never guessed.** If nobody answers (a scheduled run, an unattended chain), write the question into the item and the open-questions list, leave that item open, and finish the rest of the work.
- **Confidence disclosure.** Whenever confidence in a response or solution is below 97%, append "Confidence Level x%" to the response.

### Chains

To work through the backlog across many sessions without prompting each one, run the laundry-list chain in `docs/laundry-chain.md`: one bundle per session, the PR title as a lock, a session limit, a queue and a chain log, and a hand-off that starts the next session.

### Session Ritual

Follow the phased operating loop in `SESSION.md` — it is the canonical session protocol.

In summary:
1. **Pre-flight**: Check open PRs (QA; merge only with approval), prune merged worktrees, sync `<default-branch>`.
2. **Start**: Read `STATE.md` and the open `laundry` issues.
3. **Phase 1-3**: Gather evidence, build vertical candidates, commit to a vertical (Frame gate).
4. **Phase 4-5**: Implement (fan out agents for independent items), verify, review, evaluate.
5. **Bookkeeping**: Update `STATE.md`; close finished issues with the evidence (`Closes #N` in the PR body); file follow-up work as new issues.
6. **Ship**: Feature branch, conventional commit, PR with verification evidence (Ship gate).
7. **Loop**: If exit criteria not met, return to step 2.

### Red Flags

These thoughts mean stop — you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is too simple to need acceptance criteria" | Simple items with unexamined assumptions are where rework comes from. Two lines is enough. |
| "I'll just fix this adjacent thing while I'm here" | Scope creep breaks surgical changes. File it as a `laundry` issue instead. |
| "Tests probably pass" / "this should work now" | Evidence before claims. Run them. |
| "Tests pass, so it works" | Tests prove the code satisfies its own assertions, not that the change is wired to reality. Run the artifact and watch the change happen at its surface (`skills/surface-verification/SKILL.md`). |
| "I'll check with the human if this looks good so far" | Mid-loop permission-seeking re-inserts the human into the cycle. Verify against the criteria and ship. |
| "The status says done, so it's done" | Statuses go stale. Verify against the code. |
| "I'll update the docs in a follow-up" | The follow-up never comes. Same change, same PR. |
| "Want me to fix this?" / "Should I knock these out?" | Mid-loop suggestion re-inserts the human gate. Work is done → backlog is updated → stop. The human reads the backlog and decides what's next. |
| "I'll pick the single most important item" | Prefer a Loop Vertical — a group of thematically cohesive items that deliver more together. Single-item thinking under-uses parallelism and misses compound impact. |
| "Which item would you like me to pick?" | Choosing the work is the agent's job. Pick, state why, and run the loop; ask only what is the human's to decide. |
| "I'll guess what they'd want" (no one answering) | Record the question, leave that item open, finish the rest. |
| "I'm fairly sure" | Below 97%, say "Confidence Level x%". |
| "I'll ping the human" | In the chat: ask live. Nobody answering: record `WAITING ON HUMAN`. Only the attention check reaches the human, and only for a critical issue. Never notify. |

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
