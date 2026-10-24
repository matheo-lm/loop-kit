# Scheduled tasks

The registry of this loop's scheduled tasks (claude.ai Routines; the API calls them triggers). Each fires a fresh session with its stored prompt. This file changes in the same PR as any task is created, renamed, rescheduled, re-pointed, enabled or disabled. The "attached" columns record what the human set in the Routines UI, because the API cannot show a task's repositories or connectors; "Verified" is the last run that proved the attachment by using it.

| Task | Id | Schedule (UTC) | Repositories attached | Connectors | Prompt source | Verified |
|---|---|---|---|---|---|---|
| `<name>` | `<trig_…>` | `<cron or words>` | `<owner>/<repo>` | `<none or connector names>` | `<doc path>` | `<yyyy-mm-dd or not yet run>` |

Daily timeline (UTC): <when each task runs; chains an hour or more after the attention check's digest so recorded answers are picked up the same day>.

## Environment facts learned from runs

- <date>: <what a run taught about the environment: refused API paths, classifier refusals, connector behaviour, usage-limit failures>.
