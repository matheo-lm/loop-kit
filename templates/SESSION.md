# "go" / "loop" — what this trigger activates

When a human says "go" or "loop", run this full protocol from Phase 0 through Ship without interruption. No confirmation between phases. The two human gates (Frame and Ship) are the only stops.

---

# Session start

Read `AGENTS.md` completely before doing anything else. It is the canonical agent guide and overrides all other instructions.

Then read `STATE.md` and `docs/laundry_list.md` to understand current state and priorities.

---

# Objective

Deliver a complete Loop Vertical — a thematically cohesive group of items from `docs/laundry_list.md` — and leave it in a merge-ready state.

Optimize for the highest collective user/operator impact. Fan out to parallel agents for independent items within the vertical. If no items are clear, audit the codebase and populate `docs/laundry_list.md` with findings.

---

# The Two Human Gates

The human engineers the loop; the loop runs the work. The human is involved at exactly two points:

1. **Frame gate** (end of Phase 3) — if the selected vertical is ambiguous, has multiple valid interpretations, or any item touches the STOP list, ask before writing code. Questions before work are cheap; questions after mistakes are expensive.
2. **Ship gate** (the PR) — the human reviews finished, verified work with evidence attached.

Between the gates, run to completion. Do not stop to ask "shall I proceed?", present intermediate artifacts for sign-off, request permission between phases, or volunteer "want me to fix these?" after completing a task. Once framing is settled, it converts into acceptance criteria and the loop runs autonomously through implement → verify → ship. The only legitimate mid-loop stop is being blocked on input only the human has.

---

# Operating Loop

Remain in the following loop until exit criteria are satisfied.

## Phase 0: Pre-flight

Before picking new work, clean up anything in-flight and sync the repo.

### 1. Open PRs
Run `gh pr list` (or equivalent). For each open PR:
- Check out the branch, run the project's validation suite (typecheck, lint, tests).
- If clean: merge it, delete the branch.
- If failing: add a laundry item capturing the failure, leave the PR open, continue.

### 2. Open worktrees
Run `git worktree list`. For each worktree that isn't `main`:
- If uncommitted work exists: surface it to the human before proceeding (this is the only legitimate pre-flight stop).
- If clean and branch is merged: prune with `git worktree remove`.

### 3. Sync main
```
git checkout main && git pull origin main
```
Start all new work from a clean, up-to-date main.

---

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

## Phase 2: Build Candidates (Loop Vertical)

A **Loop Vertical** is a group of laundry items that are thematically cohesive and deliver a more meaningful outcome together than any one item alone. Examples: "pipeline observability fixes", "doc accuracy corrections", "auth hardening", "onboarding UX pass".

Identify the top 2–3 candidate verticals. For each, note:
- The items it groups and their collective user/operator impact
- Whether items within it are independent (can fan out to parallel agents) or sequential
- Dependencies and risks
- Estimated scope

Rank by:
1. Collective user/operator impact
2. Readiness (no unresolved blockers across the group)
3. Implementation efficiency (high parallelism = faster vertical completion)

Explicitly state why lower-ranked verticals were rejected.

---

## Phase 3: Commit to a Vertical

Before coding, record:

### Selected Vertical
- Name and theme
- Items included (list each, with acceptance criteria)
- Which items are independent (fan-out candidates) vs sequential
- Files expected to change
- Rationale for selection

### Out of Scope
List what will not be touched.

### Execution Plan
For independent items: fan out to parallel sub-agents, one per item or domain. Brief each agent with: its specific item, acceptance criteria, constraints, and expected output. Coordinate results before integrating.

For sequential items: work in order. Complete and verify each before starting the next.

This is the Frame gate. If any item in the vertical touches:
- payments/billing
- auth/access control
- data deletion
- irreversible public behavior

STOP and request approval. Likewise ask now if the vertical selection is ambiguous or any item has multiple valid interpretations. Otherwise proceed — no further check-ins until the PR.

---

## Phase 4: Implement

If the vertical contains independent items, dispatch sub-agents now — one per item or domain. Give each agent:
- The specific item and its acceptance criteria
- The files it should touch
- Explicit constraints (what not to touch)
- Expected output (summary of what was found/fixed)

Coordinate results when agents return. Check for conflicts. Then integrate.

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

### Observe at the surface
Validation proves the change compiles and satisfies its own assertions — not
that it works. For every change with a runtime surface, follow
`skills/surface-verification/SKILL.md`: run the artifact, drive it to where
the changed code executes, capture what you observe (output, response,
screenshot), and probe at least once off the happy path. The capture is the
evidence that goes in the PR.

If the observation contradicts the claim, that is the loop working — report
it plainly, fix, and re-observe. If no runtime surface exists (docs-only,
types-only, tests-only), state "no runtime surface" explicitly instead of
substituting a test run.

### Review (maker ≠ checker)
The work is graded by a pass that did not write it:
- Dispatch `.agents/reviewer.md` as a sub-agent to review the diff against the acceptance criteria. If your tool has no sub-agents, re-read the full diff cold against the criteria before declaring done.
- If the change touched auth, API surfaces, or user input handling, also run `.agents/security-auditor.md`.
- If the change touched user-facing UI, evaluate the changed screens against `skills/usability-heuristics/SKILL.md` — findings of severity 3+ block the ship.
- Address "changes requested" and "blocked" findings before shipping. Findings are inputs, not truth — the primary agent owns consolidation.

### Evaluate
Ask:
- Did the change satisfy the acceptance criteria for every item in the vertical?
- Did it introduce new work?
- Did it invalidate remaining items?

If not satisfied, revise and re-verify. If blocked, update `STATE.md` blockers and exit.

---

# Non-Negotiable Rules

- Never commit directly to `main`. Use a feature branch.
- Never merge without approval.
- Follow `AGENTS.md` operating principles (think, simplicity, surgical, goal-driven) and project conventions.
- No refactoring beyond what the selected vertical requires.
- When modifying API behavior, update `.env.example`, docs, and README.

---

# Bookkeeping

When items are complete:
1. Move each completed item from `docs/laundry_list.md` to `docs/done_laundry_list.md`
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
- Surface observation in the body — what you watched the running artifact do, with the capture (or "no runtime surface").
- If anything failed or was skipped, say so plainly.

The human reviews the finished PR, not intermediate artifacts.

---

# Exit Criteria

Do not declare success until ALL are true:
- acceptance criteria satisfied for every item in the vertical
- dependencies verified
- validation passing (typecheck, lint, tests)
- surface observation captured (or "no runtime surface" stated explicitly)
- reviewer findings addressed
- no new work left undocumented
- bookkeeping updated
- feature branch pushed and PR opened with verification evidence in the body
- remaining risks documented in `STATE.md`

If any criterion is unmet, continue the loop.
