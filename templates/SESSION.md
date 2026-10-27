# "go" / "loop" — what this trigger activates

When a human says "go" or "loop", run this full protocol from Phase 0 through Ship without interruption. No confirmation between phases. The Frame gate is the only stop; the Ship gate is passed by an independent review, not by the human.

---

# Session start

Read `AGENTS.md` completely before doing anything else. It is the canonical agent guide and overrides all other instructions.

Then read `STATE.md` and the open `laundry` issues (`gh api "repos/<owner>/<repo>/issues?labels=laundry&state=open&per_page=100"`; the backlog lives in GitHub issues, see `docs/laundry_list.md`) to understand current state and priorities. If this session is part of the laundry-list chain, read `docs/laundry-chain.md` and run its start checks first.

---

# Objective

Deliver a complete Loop Vertical — a thematically cohesive group of open `laundry` issues — and leave it in a merge-ready state.

Optimize for the highest collective user/operator impact. Fan out to parallel agents for independent items within the vertical. If no items are clear, audit the codebase and file the findings as `laundry` issues.

---

# The Two Human Gates

The human engineers the loop; the loop runs the work. The human is involved at exactly two points:

The human never reviews code or pull requests: review is done by an independent agent (maker ≠ checker, see "Review"), or by the agent itself re-reading the full diff cold when no sub-agent is available.

1. **Frame gate** (end of Phase 3) — if the selected vertical is ambiguous, has multiple valid interpretations, or any item touches the STOP list, ask before writing code. Questions before work are cheap; questions after mistakes are expensive.
2. **Ship gate** (the PR) — finished, verified work with evidence attached, reviewed by an independent agent whose findings are fixed; the PR then merges itself under the conditions in "Non-Negotiable Rules". The human is asked only for an owner-only decision (STOP list, `AGENTS.md` "Stay the Engineer"), live or recorded per `skills/human-attention/SKILL.md`.

Between the gates, run to completion. Do not stop to ask "shall I proceed?", present intermediate artifacts for sign-off, request permission between phases, or volunteer "want me to fix these?" after completing a task. Once framing is settled, it converts into acceptance criteria and the loop runs autonomously through implement → verify → ship. The only legitimate mid-loop stop is being blocked on input only the human has.

---

# Operating Loop

Remain in the following loop until exit criteria are satisfied.

## Phase 0: Pre-flight

Before picking new work, clean up anything in-flight and sync the repo.

### 1. Open PRs
Run `gh pr list` (or equivalent). For each open PR:
- Check out the branch, run the project's validation suite (typecheck, lint, tests).
- If clean: it merges under the conditions in Non-Negotiable Rules once an independent review's findings are fixed; no approval is asked.
- If failing: add a laundry item capturing the failure, leave the PR open, continue.

### 2. Open worktrees
Run `git worktree list`. For each worktree that isn't `<default-branch>`:
- If uncommitted work exists: surface it to the human before proceeding (this is the only legitimate pre-flight stop).
- If clean and branch is merged: prune with `git worktree remove`.

### 3. Sync the default branch
```
git checkout <default-branch> && git pull origin <default-branch>
```
Start all new work from a clean, up-to-date `<default-branch>`.

---

## Phase 1: Gather Evidence

Before proposing work:

1. Read:
   - `AGENTS.md`
   - `STATE.md`
   - the open `laundry` issues (and the closed ones a candidate item touches)

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

This is the Frame gate. If any item in the vertical touches the Stay the Engineer list in `AGENTS.md`:
- production writes (migrations, data changes, ingestion, paid batch jobs)
- payments/billing
- auth/access control
- data deletion
- publishing outward or other irreversible public behavior

STOP and request approval. Likewise ask now if any item has multiple valid interpretations. Ask with the structured question tool, recommend one option, and batch the questions into one call. Choosing the vertical is not a question for the human: pick it and state why. If nobody answers, record the question in the item, leave that item open and continue with the rest. Otherwise proceed — no further check-ins until the PR.

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

Run narrow tests for touched areas first, then the full suite from a clean environment (`env -i PATH="$PATH" HOME="$HOME" <test command>`) when the session environment carries production keys. Do not fix unrelated failures.

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

- Never commit directly to `<default-branch>`. Use a feature branch.
- Never merge without an independent review. A PR merges itself (squash) when the project's checks are green, the default branch is merged in with no conflict, the independent review's findings are fixed, the PR body carries the evidence, and the diff touches nothing under `.github/workflows/`; otherwise it stays a draft and its body says why. Never merge a failing or conflicted PR.
- Follow `AGENTS.md` operating principles (think, simplicity, surgical, goal-driven) and project conventions.
- No refactoring beyond what the selected vertical requires.
- When modifying API behavior, update `.env.example`, docs, and README.

---

# Bookkeeping

The `laundry` issues are the loop's memory; keep them truthful:
- **Truth in the same change.** Any PR that changes reality says so on the affected issue in the same session: a comment with the evidence, `Closes #N` in the PR body for finished items, labels for state (`in-progress`, `waiting-on-human`).
- **Absolute dates only.** `yyyy-mm-dd`, never "yesterday" or "last week".
- **Close with evidence.** A finished item is a closed issue whose last comment names the PR, the date and the verification; never delete an issue or file a duplicate; reopened work reopens the issue with a comment saying why.
- **New work gets an issue.** Follow-up work becomes a new `laundry` issue with a `P0` to `P3` label, Problem, Acceptance, Validation and Risk — never a TODO in code, a side note or silent scope creep in an existing issue. Never leave findings only in conversation.
- **One home per kind of fact.** Active work in open issues, completed work in closed issues, doctrine in `AGENTS.md`, technical detail in docs. Point, don't restate.
- **Chain sessions** also update "Queue" and "Chain log" in `docs/laundry-chain.md`.

---

# Ship

Open a pull request (the Ship gate):
- Concise summary of what changed and why.
- Verification evidence in the body — the commands you ran and their output, not assertions.
- Surface observation in the body — what you watched the running artifact do, with the capture (or "no runtime surface").
- If anything failed or was skipped, say so plainly.
- Chain sessions title the PR `Chain N/<limit> — <theme> (<items>)` and open it as a draft at the first commit.

The independent review is the gate; the human reads merged work afterward, never as a step before the merge.

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
