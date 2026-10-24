---
name: human-attention
description: Use the moment an item cannot move without the owner (an owner-only decision, credential, account, payment, legal or identity matter) and every agentic alternative is exhausted. Defines the bar, the severity, the issue format, the rate limits and the answer loop. Human attention is the scarcest resource in the loop; spend it only when nothing else can move the work.
---

# human-attention

The owner is not the loop's per-cycle prompter and not its fallback. An escalation is a request for something only the owner can give. It is created only after the bar below is met, it lives as a GitHub issue labeled `owner-action` in the repository it concerns, and it reaches the owner through the attention check (`docs/attention-check.md`) on the schedule below. Everything else is recorded and waits.

## The bar: all five must hold

1. **Owner-only.** The need is on the Stay-the-Engineer list in `AGENTS.md`, or requires something only the owner has: credentials, accounts, money, a legal or contractual reading, the owner's identity (voice, name, face), or a decision the docs record as the owner's.
2. **Alternatives exhausted, in writing.** Each of these was tried or ruled out, and the issue says what happened: (a) another approach inside the item; (b) a reversible safe default, taken and recorded instead of asked; (c) deferring the item and doing other backlog work; (d) a recorded decision in the docs, laundry lists, done lists or chain log that already answers it.
3. **It matters.** It blocks a P0 or P1 item or a whole vertical, or carries risk: money, security, legal, public exposure, data loss.
4. **Not already open.** No open `owner-action` issue covers it. Search first; add to the existing issue instead of opening a second.
5. **One ask.** The issue asks for exactly one decision or one action, with options and a recommendation. Bundled asks are split or dropped.

If any of the five fails: record the question in the item and `STATE.md`, leave the item open, finish the rest of the work. No issue, no notification.

## Severity

| Label | Meaning | Reaches the owner |
|---|---|---|
| `severity:critical` | Money, security, legal, public exposure, data loss, or every P0 item blocked | The next hourly attention check |
| `severity:blocking` | A P0 or P1 item or a vertical cannot move | The next daily digest |
| `severity:question` | A decision that would improve the work; nothing is blocked | Never pushed; waits in the issue for the owner's next look |

Rate limits, enforced by the attention check and not by the filer: at most one critical push per repository per 24 hours (the rest queue into the digest), one digest per day, nothing sent when nothing is new.

## Filing

Labels: `owner-action` plus exactly one severity label; create them if missing. Title: `[OWNER] <one-line ask>`. Body in this order (`.github/ISSUE_TEMPLATE/owner-action.md` carries it):

1. **Decision or action needed**: one sentence, then options A, B, C with the recommended one first and why.
2. **Why only you**: the rule, or the thing only the owner has.
3. **What was tried**: the four alternatives from the bar, each with what happened.
4. **Impact of waiting**: the items and verticals blocked, and the date it starts to cost (a deadline, an expiring key, a policy date).
5. **How to answer**: reply on the issue with the option letter or `done`. The next attention check records it and closes the issue. Nothing else is needed from the owner.
6. **Links**: the laundry item, the PR or run, the evidence.

In the same change, set the laundry item's status to `OWNER ACTION OPEN` with the issue link. Never file in a public repository: use the first (private) repository the attention check lists and link the public one. Filers never notify the owner directly, in any channel.

## The attention check (scheduled, fresh session, hourly)

The prompt is `docs/attention-check.md`; the owner creates the scheduled task from it once, in the claude.ai Routines UI, with the repositories attached (a routine created from a session carries none, and unattended sessions cannot attach any). Every run lists the open `owner-action` issues of the attached repositories over the GitHub REST API, and then:

- For each `severity:critical` issue without an `attention-notified` comment in the last 24 hours: include it in the run's final summary (repository, title, link, the one ask) and comment `attention-notified <yyyy-mm-dd hh:mm UTC>` on it.
- At the digest hour the prompt names, also include every `severity:blocking` issue without an `attention-digested` comment, and comment `attention-digested <timestamp>` on each.
- For each `owner-action` issue with an owner comment newer than its last `attention-recorded` comment: on a branch, record the answer in the laundry item and `STATE.md`, open a draft PR, comment `attention-recorded <timestamp>`, and close the issue if the answer chose an option or said `done`.
- If nothing above applied, end with exactly: `Human attention: nothing to escalate.`

The final summary of a run that found something starts with `HUMAN ATTENTION:` and lists one line per issue. The run never changes a severity, never files new issues, never widens its repositories, and never messages anywhere but its own summary. A repository it cannot attach is named in the summary as unreachable.

## Red flags

| Thought | Reality |
|---|---|
| "I'll ask to be safe" | Safe is a reversible default, recorded. Asking spends the scarcest resource. |
| "Two small questions in one issue" | Split or drop. One ask per issue. |
| "It's probably critical" | Critical is money, security, legal, public, data loss, or all P0 blocked. Everything else is blocking or question. |
| "The owner will see it in chat" | Chat is not a record. The issue is. |
| "I'll notify the owner now" | Only the attention check reaches the owner. Filers file. |
| "They haven't answered, I'll guess" | Record the question, leave the item open, do other work. |
