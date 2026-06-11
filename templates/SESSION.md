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
