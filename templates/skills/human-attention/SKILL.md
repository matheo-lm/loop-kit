---
name: human-attention
description: Use the moment an item cannot move without the owner (a human-only decision, credential, account, payment, legal or identity matter) and every agentic alternative is exhausted. Defines the bar, the severity, the issue format, the rate limits and the answer loop. Human attention is the scarcest resource in the loop; spend it only when nothing else can move the work.
---

# human-attention

The human is not the loop's per-cycle prompter and not its fallback. Every human-only need is recorded as a GitHub issue labeled `human-action` in the repository it concerns, so the human has one queue: the GitHub issue search `is:open label:human-action user:<owner>`. Severity decides whether and when the human is told, and the attention check (`docs/attention-check.md`) is the only thing that tells them. Nothing human-only lives only in chat.

## Filing and the bar

File an issue when conditions 1, 4 and 5 below hold and the issue says what the agent did instead: the reversible default it took, or the item it deferred. File it as `severity:blocking` or `severity:critical` only when conditions 2 and 3 also hold; otherwise it is `severity:question`.

1. **Human-only.** The need is on the Stay-the-Engineer list in `AGENTS.md`, or requires something only the human has: credentials, accounts, money, a legal or contractual reading, the human's identity (voice, name, face), or a decision the docs record as the human's.
2. **Alternatives exhausted, in writing.** Each of these was tried or ruled out, and the issue says what happened: (a) another approach inside the item; (b) a reversible safe default, taken and recorded instead of asked; (c) deferring the item and doing other backlog work; (d) a recorded decision in the docs, laundry lists, done lists or chain log that already answers it.
3. **It matters.** It blocks a P0 or P1 item or a whole vertical, or carries risk: money, security, legal, public exposure, data loss.
4. **Not already open.** No open `human-action` issue covers it. Search first; add to the existing issue instead of opening a second.
5. **One ask.** The issue asks for exactly one decision or one action, with options and a recommendation. Bundled asks are split or dropped.

If condition 1, 4 or 5 fails: record the question in the item and `STATE.md`, leave the item open, finish the rest of the work. No issue, no notification.

## Severity

| Label | Meaning | Reaches the human |
|---|---|---|
| `severity:critical` | Money, security, legal, public exposure, data loss, or every P0 item blocked | The next hourly attention check |
| `severity:blocking` | A P0 or P1 item or a vertical cannot move | The next daily digest |
| `severity:question` | A decision or action that improves the work; nothing is blocked | Never pushed on its own; rolled up in Monday's digest |

Rate limits, enforced by the attention check and not by the filer: at most one critical push per repository per 24 hours (the rest queue into the digest), one digest per day, nothing sent when nothing is new. A blocking issue digested earlier and still open is listed again in each daily digest under "still waiting", so a blocking ask is never silently forgotten; the human relabels it `severity:question` to stop that.

## Filing

Labels: `human-action` plus exactly one severity label; create them if missing. Title: `[HUMAN] <one-line ask>`. Body in this order (`.github/ISSUE_TEMPLATE/human-action.md` carries it):

1. **Decision or action needed**: one sentence, then options A, B, C with the recommended one first and why.
2. **Why only you**: the rule, or the thing only the human has.
3. **What was tried**: the four alternatives from the bar, each with what happened.
4. **Impact of waiting**: the items and verticals blocked, and the date it starts to cost (a deadline, an expiring key, a policy date).
5. **How to answer**: reply on the issue with the option letter or `done`. The next attention check records it and closes the issue. Nothing else is needed from the human.
6. **Links**: the laundry item, the PR or run, the evidence.

In the same change, set the laundry item's status to `HUMAN ACTION OPEN` with the issue link. Never file in a public repository: use the first (private) repository the attention check lists and link the public one. Filers never notify the human directly, in any channel.

## The attention check (scheduled, fresh session, hourly)

The prompt is `docs/attention-check.md`; the human creates the scheduled task from it once, in the claude.ai Routines UI, with the repositories attached (a routine created from a session carries none, and unattended sessions cannot attach any). Every run lists the open `human-action` issues of the attached repositories over the GitHub REST API, and then:

- For each `severity:critical` issue without an `attention-notified` comment in the last 24 hours: include it in the run's final summary (repository, title, link, the one ask) and comment `attention-notified <yyyy-mm-dd hh:mm UTC>` on it.
- At the digest hour the prompt names, also include every `severity:blocking` issue without an `attention-digested` comment and comment `attention-digested <timestamp>` on each; list the other open blocking issues under "still waiting"; and on Mondays append a roll-up of open `severity:question` issues (title and link), without commenting on those.
- For each `human-action` issue with a human comment newer than its last `attention-recorded` comment, or closed by the human without one: on a branch, record the answer in the laundry item and `STATE.md`, open a draft PR, comment `attention-recorded <timestamp>`, and close the issue if it is still open and the answer chose an option or said `done`.
- If a recorded answer unblocks a laundry item and that repository has a chain scheduled task, fire it once so work resumes now instead of at the next daily run.
- If nothing above applied, end with exactly: `Human attention: nothing to escalate.`

The final summary of a run that found something starts with `HUMAN ATTENTION:` and lists one line per issue. The run never changes a severity, never files new issues, never widens its repositories, and never messages anywhere but its own summary. A repository it cannot attach is named in the summary as unreachable.

## The answer loop

1. The human replies on the issue with an option letter, `done` or a sentence, or simply closes it.
2. The next attention check records the answer: a branch `attention/<n>`, the decision written into the laundry item and `STATE.md` with the date, a draft PR, an `attention-recorded` comment, and the issue closed. A closed issue drops out of the queue.
3. If the answer unblocks a laundry item and the repository has a chain scheduled task, the check fires it once.
4. The chain session reads human answers first (start check 5 in `docs/laundry-chain.md`) and takes the next bundle.

Nothing here needs the human beyond the reply. Each repository that runs a chain has a scheduled task (`<repo>-chain`: daily, a fresh session, the repository attached in the Routines UI, prompt = the chain start line from `docs/laundry-chain.md`), and the attention check's prompt lists those tasks by id.

## Red flags

| Thought | Reality |
|---|---|
| "I'll ask to be safe" | Safe is a reversible default, recorded. File it as a question so the human can see it; never as blocking. |
| "Two small questions in one issue" | Split or drop. One ask per issue. |
| "It's probably critical" | Critical is money, security, legal, public, data loss, or all P0 blocked. Everything else is blocking or question. |
| "The human will see it in chat" | Chat is not a record. The issue is. |
| "I'll notify the human now" | Only the attention check reaches the human. Filers file. |
| "They haven't answered, I'll guess" | Record the question, leave the item open, do other work. |
