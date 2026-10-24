# Laundry-list chain

Internal. This is the standing brief for a chain of agent sessions that works through `docs/laundry_list.md` one bundle at a time. Every chain session reads it first and updates "Queue" and "Chain log" in its own PR. `AGENTS.md` stays the source of truth for project rules; the working agreement below adds the human's standing decisions for chain sessions.

## Start a session

Start a new agent session on this repository with this one-line prompt:

> Continue the laundry-list chain: read docs/laundry-chain.md and run the next session.

The session runs the start checks below, takes the first bundle under "Queue" and follows everything else here. To keep the chain going without starting each session yourself, schedule a daily run (for Claude Code, a scheduled task `<repo>-chain` that starts a fresh session with the same prompt, with the repository attached in the Routines UI). The human-attention check (`docs/attention-check.md`) records human answers; schedule the chain an hour after its digest so the next run picks them up. The start checks keep a scheduled run and a spawned session from working at the same time. New items also arrive from the intake check (`docs/intake.md`), which files what the human drops in the intake channel.

## Start checks (every session, before any work)

1. **One chain session at a time.** List open pull requests. If any open PR's title starts with `Chain `, another chain session is still working or waiting to merge. Stop, and report that PR and its state. Exception (human, 2026-10-24): if that PR's head commit is more than 3 hours old, the session that held it is dead (a run can die mid-bundle on the account's usage limit); check out its branch, continue its bundle and keep the PR as the lock, noting the adoption in the PR body and the Chain log.
2. **Session number.** N is the highest session number in "Chain log" plus 1. If N is above <limit> (the human raises this number to continue), stop and post the final report (see Hand-off).
3. **Queue.** If "Queue" holds no agent-doable bundle, stop and post the final report.
4. **Title.** Name the branch's PR `Chain N/<limit> — <theme> (<items>)`. The PR title is the lock that check 1 reads, so open the draft PR as soon as the branch has its first commit.
5. **Human answers first.** Open `human-action` issues with a human reply newer than their last `attention-recorded` comment: record the answer per `skills/human-attention/SKILL.md` before taking a bundle. Skip any bundle blocked on an open `human-action` issue.

## Working agreement (<human>, <yyyy-mm-dd>)

- **Questions.** Ask with the agent's structured question tool (Claude Code: AskUserQuestion), never buried in plain text. Recommend one option and say why. Ask whenever a decision is the human's, and before overriding an earlier recorded decision. If a question gets no answer in the session (for example, a scheduled run nobody is watching), do not guess: record it in the item\'s Status line as `WAITING ON HUMAN — <date>: <the question, the options, the recommended one>` and under "Open questions" below, leave that item open, and finish the rest of the bundle.
- **Merges.** <Choose one and delete the other.>
  - Approval-gated: chain sessions stop at the Ship gate like any other session.
  - Autonomous (human exception to the Ship gate, chain sessions and the human-attention check's answer-recording PRs only): squash-merge without asking when the project's checks are green (CI, or the clean-environment test, lint and audit commands when the repository has no CI), the default branch is merged into the branch with no conflict, the review agent's findings are fixed, the PR body carries the evidence, and the diff touches nothing under `.github/workflows/`. Then delete the branch, verify the default branch holds the result, record it in the Chain log, and check production read-only where there is one. (Claude Code cloud sessions: `gh api -X POST repos/O/R/pulls/N/ccr/ready_for_review`, then `gh api -X PUT repos/O/R/pulls/N/merge -f merge_method=squash`; GraphQL is refused.)
- **Production writes.** Ask before every production write (migration, data change, ingestion, paid batch job, outward send), each time. Access to a system is not approval.
- **Style.** Factual and concise. Byte-cap command output. Append "Confidence Level x%" when confidence is below 97%.
- **Off limits.** <items, PRs or areas chain sessions must not touch>.

## Session procedure

1. **Setup.** Fetch the default branch (the local ref can be stale), branch from it, install dependencies from the lockfile.
2. **Work the bundle** with the operating loop in `SESSION.md`. Read each item in `docs/laundry_list.md` first and verify its status against code and git.
3. **Verify.** Narrow tests first, then the full validation from a clean environment (`env -i PATH="$PATH" HOME="$HOME" <test command>` when the session environment carries production keys). For UI changes, attach before/after screenshots.
4. **Review.** A separate review agent (`.agents/reviewer.md`, run in the background) checks the diff before merge. Fix its findings, and re-run it after large fixes.
5. **Ship.** One branch and one draft PR per bundle. In the same PR, update docs and laundry state (move DONE blocks whole), give follow-up work new numbered items, and update this file:
   - Remove the finished bundle from "Queue".
   - Add one line to "Chain log".
   - Triage the next bundle into "Queue" (rules below).
6. **Merge** per the working agreement, check production read-only, then hand off.

## Hand-off

- **Pick the next bundle.** ONE bundle of 2–5 related items that agents can finish. Exclude paused, human-action-only, on-hold, design-first items and items owned by another open PR. Prefer coherent themes and higher priority.
- **If such work remains and N is below <limit>:** a scheduled run does not spawn; the schedule starts the next session (routine-fired sessions have no `create_session` or `list_sessions`). A session started by hand may start the next one with `create_session` (this repository as source, title `Chain N+1/<limit> — <theme> (<items>)`, the one-line prompt above); if that is refused (for example, a nesting limit), the queue is already up to date: end with the one-line prompt for the human.
- **Otherwise:** do not spawn. Post a final report listing what is left and why, each with the one thing the human must do. If an item is critical by the bar in `skills/human-attention/SKILL.md`, file the `human-action` issue and the attention check carries it from there; otherwise its `WAITING ON HUMAN` line is the record.
- **Last message:** the next session's title and ID, or the final report.

## Queue

1. **<theme> (<items>):** <one line on scope and anything the session must ask>.

## Chain log

| Session | Date | Bundle | PRs | Result |
| --- | --- | --- | --- | --- |

## Open questions

None.

## Open human actions

Home: open `human-action` issues (`skills/human-attention/SKILL.md`). Link them here; never restate them.

## Environment notes

<what sessions learned about the environment: blocked hosts, local stack setup, keys to unset>
