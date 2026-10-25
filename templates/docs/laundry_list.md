# laundry list

The backlog of this repository lives in GitHub issues, not in this file. This file says how.

- **An item is an issue** labelled `laundry`, with a priority label `P0` to `P3` (P0 broken or blocking, P3 nice to have), an `area:<name>` label when the repository uses areas, and a body with Problem, Acceptance (2–5 statements a checker could verify), Validation (commands, surface checks) and Risk. Title: a short action statement.
- **State is labels and comments.** `in-progress` while a chain works it (comment `chain: started in Chain N/<limit>`), `waiting-on-human` plus one comment with the question, the options and the recommended one when only the human can decide (`skills/human-attention/SKILL.md`), `human-action` with `severity:critical` for the critical case only.
- **Done is closed.** The PR body says `Closes #N`; the closing comment carries the evidence and the date. Never delete an issue; reopen with a comment when work comes back.
- **Reading the backlog:** `gh api "repos/<owner>/<repo>/issues?labels=laundry&state=open&per_page=100"` (REST; GraphQL is refused in Claude Code cloud sessions). The human's view: `https://github.com/<owner>/<repo>/issues?q=is%3Aissue+label%3Alaundry+is%3Aopen`.
- **Intake** files issues the same way (`docs/intake.md`); chains take bundles of 2–5 related open issues (`docs/laundry-chain.md`).

Dates are absolute (yyyy-mm-dd). Nothing is deleted. If this repository once kept its items in this file, the text below the rule is a frozen archive: each item is also an issue whose title carries the item's id.

---
