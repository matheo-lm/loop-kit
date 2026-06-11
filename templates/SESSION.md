# Session start

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
Run the project's validation:
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
