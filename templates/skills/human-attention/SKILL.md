---
name: human-attention
description: Use the moment an item cannot move without the owner (a human-only decision, credential, account, payment, legal or identity matter) and every agentic alternative is exhausted. Defines where the ask goes (live in the chat when the owner is present, recorded in the item when nobody can answer), the one case that becomes an issue (critical), the issue format, the rate limits and the answer loop. Human attention is the scarcest resource in the loop; spend it only when nothing else can move the work.
---

# human-attention

The human is not the loop's per-cycle prompter and not its fallback. They engineer the loop and answer real questions; they do not want a queue of chores. Three rules decide where a human-only need goes (owner decision 2026-10-24, replacing "every human-only need is an issue"):

1. **Attended session: ask live.** When the owner is in the chat, ask with the structured question tool (AskUserQuestion): options first, one recommended with its reason, and the paste-ready text or the exact steps when the ask is an action. Record the answer the same session: as a comment on the laundry issue, and in `STATE.md` and `MEMORY.md` when it outlives the item. No `human-action` issue is filed.
2. **Unattended session: record and continue.** When nobody can answer (a scheduled run, a chain), take the reversible default when one exists and record it. Otherwise label the issue `waiting-on-human` and add one comment with the one question, the options and the recommended one, add one line under "blockers" in `STATE.md` when the whole goal is stuck, leave that issue open and finish the rest of the work. The daily changelog and the attention check's digest list every open `waiting-on-human` issue under "Needs you" and "Waiting on you"; the owner answers in a comment, in the next attended session or in the intake channel, and the answer is recorded as a comment with the label removed. No `human-action` issue is filed.
3. **Critical: an issue.** Only a need that is human-only, has every alternative exhausted in writing, is critical and is not already open becomes a GitHub issue labelled `human-action` and `severity:critical`, filed in the repository it concerns (cross-repository ones in the control repository). The attention check tells the owner at its next run. One queue: `is:open label:human-action user:<owner>`.

Never: an issue for a chore the owner could do in two minutes while they are in the chat; an issue for a question that is not critical; a direct notification to the owner from a filer. Only the attention check reaches the owner, and only for issues.

## Try first, then ask for the capability

Before any ask, live or recorded, the agent tries the action itself and keeps the refusal (the API message, the classifier reason or the UI-only setting); an ask is never made on the assumption that something is refused. When the blocker is a permission, scope, setting, credential or attachment the agent lacks, option A asks the owner to grant it once (a permission rule, a token scope, a connector, a repository setting) so future runs act without them; the one-off action by the owner is option B. When the capability cannot be granted (a platform limit the owner does not control), the ask says so in one line, the limit is recorded once in the control repository's registry (`docs/scheduled-tasks.md`, "Capabilities"), and later asks point at that record instead of re-explaining it. The owner is asked to do a chore only when no grant exists.

## The bar for an issue

File an issue only when all five hold, and the issue says what the agent did instead (the reversible default it took, or the item it deferred):

1. **Human-only.** The need is on the Stay-the-Engineer list in `AGENTS.md`, or requires something only the owner has: credentials, accounts, money, a legal or contractual reading, the owner's identity (voice, name, face), or a decision the docs record as theirs.
2. **Alternatives exhausted, in writing.** Each of these was tried or ruled out, and the issue says what happened: (a) the action itself, attempted, with the refusal quoted; (b) another approach inside the item; (c) a reversible safe default, taken and recorded instead of asked; (d) deferring the item and doing other backlog work; (e) a recorded decision in the docs, laundry lists, done lists or chain log that already answers it.
3. **Critical.** Money, security, legal, public exposure, data loss, or every P0 item of the repository blocked. A P1 item or a vertical that cannot move is not critical: it is a `waiting-on-human` label and comment.
4. **Not already open.** No open `human-action` issue covers it. Search first; add to the existing issue instead of opening a second.
5. **One ask.** The issue asks for exactly one decision or one action, with options and a recommendation. Bundled asks are split or dropped.

If any condition fails: ask live when the owner is in the chat, otherwise label the issue `waiting-on-human` with the question as a comment, leave it open, finish the rest of the work. No `human-action` issue, no notification.

## Severity

| Label | Meaning | Reaches the owner |
|---|---|---|
| `severity:critical` | Money, security, legal, public exposure, data loss, or every P0 item blocked | The next attention check (every four hours) |
| `severity:blocking` | Retired 2026-10-24; not filed any more | Issues that still carry it: the 08:34 UTC digest, until the queue empties |
| `severity:question` | Retired 2026-10-24; not filed any more | Issues that still carry it: Monday's roll-up, until the queue empties |

Rate limits, enforced by the attention check and not by the filer: at most one critical push per repository per 24 hours (the rest queue into the digest), one digest per day, nothing sent when nothing is new. Open issues from before 2026-10-24 that carry a retired label are answered in chat or on the issue and closed; nobody relabels them.

## Filing

Labels: `human-action` plus `severity:critical`; create them if missing. Title: `[HUMAN] <one-line ask>`. Body in this order (`.github/ISSUE_TEMPLATE/human-action.md` carries it):

1. **Decision or action needed**: one sentence, then options A, B, C with the recommended one first and why.
2. **Why only you**: the rule, or the thing only the owner has.
3. **What was tried**: the five alternatives from the bar, each with what happened, the attempted action and its refusal first.
4. **Impact of waiting**: what is critical about it, and the date it starts to cost (a deadline, an expiring key, a policy date).
5. **How to answer**: reply on the issue with the option letter or `done`. The next attention check records it and closes the issue. Nothing else is needed from the owner.
6. **Links**: the laundry issue, the PR or run, the evidence.

In the same change, comment the `human-action` issue's link on the laundry issue and label it `waiting-on-human`. Never file in a public repository: use the first (private) repository the attention check lists and link the public one. Filers never notify the owner directly, in any channel.

## The attention check (scheduled, fresh session, every four hours)

The prompt is `docs/attention-check.md`; the owner creates the scheduled task from it once, in the claude.ai Routines UI, with the repositories attached (a routine created from a session carries none, and unattended sessions cannot attach any). Every run lists the open `human-action` issues of the attached repositories over the GitHub REST API, and then:

- For each `severity:critical` issue without an `attention-notified` comment in the last 24 hours: include it in the run's final summary (repository, title, link, the one ask) and comment `attention-notified <yyyy-mm-dd hh:mm UTC>` on it.
- At the digest hour the prompt names, also include every `severity:blocking` issue without an `attention-digested` comment and comment `attention-digested <timestamp>` on each; list the other open blocking issues under "still waiting"; list open agent pull requests (`Chain ` and `chore: record human answer`) under "PRs waiting for your review"; and on Mondays append a roll-up of open `severity:question` issues (title and link), without commenting on those. These digest steps serve the issues filed before 2026-10-24 and go quiet as the queue empties.
- For each `human-action` or `waiting-on-human` issue with a human comment newer than its last `attention-recorded` comment, or closed by the human without one: comment `attention-recorded <timestamp>: <the answer>` on the issue, remove the `waiting-on-human` label, close a `human-action` issue if it is still open and the answer chose an option or said `done`, and open the `attention/<n>` PR only when the answer is a standing decision that belongs in `STATE.md`. An attended session that records an answer itself leaves the same `attention-recorded` comment so the check does not record it twice.
- For each recorded answer, name the chain scheduled task that picks it up at its next daily run. Routine sessions cannot fire other tasks (verified 2026-10-24), so the chain's schedule is the kick; schedule it an hour after the digest.
- If nothing above applied, end with exactly: `Human attention: nothing to escalate.`

The final summary of a run that found something starts with `HUMAN ATTENTION:` and lists one line per issue. The run never changes a severity, never files new issues, never widens its repositories, and never messages anywhere but its own summary. A repository it cannot attach is named in the summary as unreachable.

## The answer loop

For a live question: the owner answers in the chat; the session writes the answer into the item, `STATE.md` and, when it outlives the item, `MEMORY.md`, in the same PR as the work.

For a `waiting-on-human` issue: the owner answers in a comment on the issue, in the next attended session, or in the intake channel naming the repository and issue; the attention check, the session or the intake check comments the answer with the date and removes the label; the repository's next chain run reads it from the thread (start check 5 in `docs/laundry-chain.md`).

For an issue:

1. The owner replies on the issue with an option letter, `done` or a sentence, or simply closes it. A question in the reply gets a short answer on the issue from the next check, grounded in the repository's docs, and the issue stays open.
2. The next attention check records the answer: an `attention-recorded` comment with the answer on the issue (and on the laundry issue it links), the issue closed, and, only for a standing decision, a branch `attention/<n>` with one `STATE.md` line, a draft PR squash-merged under the chain brief's working agreement. A closed issue drops out of the queue.
3. The repository's chain scheduled task picks the answer up at its next daily run, scheduled an hour after the digest.
4. The chain session reads human answers first and takes the next bundle.

Each repository that runs a chain has a scheduled task (`<repo>-chain`: daily, a fresh session, the repository attached in the Routines UI, prompt = the chain start line from `docs/laundry-chain.md`), and the attention check's prompt names those tasks and their run times.

## Red flags

| Thought | Reality |
|---|---|
| "I'll file an issue to be safe" | A `human-action` issue is for critical only. The owner in the chat: ask now. Nobody answering: label the issue `waiting-on-human`, comment the question, continue. |
| "The owner is right here, but the rule says file" | The rule says ask. Options, a recommendation, the paste-ready text; then write the answer down. |
| "Chat is not a record" | The chat is not; the answer written into the item, `STATE.md` or `MEMORY.md` the same session is. |
| "Two small questions in one ask" | One ask per question or issue. Batch live questions into one structured call. |
| "It's probably critical" | Critical is money, security, legal, public, data loss, or every P0 blocked. Everything else waits in the item. |
| "I'll notify the owner now" | Only the attention check reaches the owner, and only for issues. Filers file; recorders record. |
| "They haven't answered, I'll guess" | Record the question, leave the item open, do other work. |
| "I'll ask them to do it" | First try it and quote the refusal. Then ask them to make you able to do it; the chore is option B. |
| "It was refused before, so it is human-only" | A refusal is a dated fact in the registry; try again when the environment changed. |
