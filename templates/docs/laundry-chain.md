# Laundry-list chain

Internal. This is the standing brief for a chain of agent sessions that works through `docs/laundry_list.md` one bundle at a time. Every chain session reads it first and updates "Queue" and "Chain log" in its own PR. `AGENTS.md` stays the source of truth for project rules; the working agreement below adds the human's standing decisions for chain sessions.

## Start a session

Start a new agent session on this repository with this one-line prompt:

> Continue the laundry-list chain: read docs/laundry-chain.md and run the next session.

The session runs the start checks below, takes the first bundle under "Queue" and follows everything else here. To keep the chain going without starting each session yourself, schedule a daily run (for Claude Code, a scheduled task that starts a fresh session with the same prompt). The start checks keep a scheduled run and a spawned session from working at the same time.

## Start checks (every session, before any work)

1. **One chain session at a time.** List open pull requests. If any open PR's title starts with `Chain `, another chain session is still working or waiting to merge. Stop, and report that PR and its state.
2. **Session number.** N is the highest session number in "Chain log" plus 1. If N is above <limit> (the human raises this number to continue), stop and post the final report (see Hand-off).
3. **Queue.** If "Queue" holds no agent-doable bundle, stop and post the final report.
4. **Title.** Name the branch's PR `Chain N/<limit> — <theme> (<items>)`. The PR title is the lock that check 1 reads, so open the draft PR as soon as the branch has its first commit.
5. **Owner answers first.** Open `owner-action` issues with an owner reply newer than their last `attention-recorded` comment: record the answer per `skills/human-attention/SKILL.md` before taking a bundle. Skip any bundle blocked on an open `owner-action` issue.

## Working agreement (<human>, <yyyy-mm-dd>)

- **Questions.** Ask with the agent's structured question tool (Claude Code: AskUserQuestion), never buried in plain text. Recommend one option and say why. Ask whenever a decision is the human's, and before overriding an earlier recorded decision. If a question gets no answer in the session (for example, a scheduled run nobody is watching), do not guess: record it under "Open questions" below and in the item, leave that item open, and finish the rest of the bundle.
- **Merges.** <Choose one and delete the other.>
  - Approval-gated: chain sessions stop at the Ship gate like any other session.
  - Autonomous (human exception to the Ship gate, chain sessions only): squash-merge without asking when CI and the preview deployment are green, there is no conflict, and the review agent's findings are fixed. Then give a 5-line status and check production read-only.
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
- **If such work remains and N is below <limit>:** start the next session (Claude Code cloud: the `create_session` tool with this repository as source, title `Chain N+1/<limit> — <theme> (<items>)` and the one-line prompt above). If spawning is refused (for example, a nesting limit), the queue is already up to date: end with the one-line prompt for the human, or rely on the scheduled run.
- **Otherwise:** do not spawn. Post a final report listing what is left and why, each with the one thing the human must do. If an item meets the bar in `skills/human-attention/SKILL.md`, file the `owner-action` issue; the attention check carries it from there.
- **Last message:** the next session's title and ID, or the final report.

## Queue

1. **<theme> (<items>):** <one line on scope and anything the session must ask>.

## Chain log

| Session | Date | Bundle | PRs | Result |
| --- | --- | --- | --- | --- |

## Open questions

None.

## Open human actions

Home: open `owner-action` issues (`skills/human-attention/SKILL.md`). Link them here; never restate them.

## Environment notes

<what sessions learned about the environment: blocked hosts, local stack setup, keys to unset>
