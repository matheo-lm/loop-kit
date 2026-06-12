---
name: surface-verification
description: Use before claiming any change works — verification is runtime observation at the surface where users meet the change, not test runs. Required in Phase 5 for every change with a runtime surface.
---

# surface-verification

**Verification is runtime observation.** You run the artifact, drive it to
where the changed code executes, and capture what you see. That capture is
your evidence. Nothing else is.

Tests, typecheck, lint, and build are CI's job — run them, but they prove
the change *compiles and satisfies its own assertions*, not that it works.
A change can be fully green and still invisible, inert, or wrong at the
surface, because tests pin what the author believed, not what the user sees.
The two failure classes are different: CI catches "the code broke a
contract"; only observation catches "the contract was never wired to
reality."

## The rule

For every change with a runtime surface, the ship gate requires **captured
evidence from the running artifact** — terminal output, response bodies,
screenshots, logs of observed behavior. "Tests pass" is not evidence of
working. Neither is "I read the code and it's correct" — reading code is
how the gap got shipped.

## Find the surface

The surface is where a user — human or programmatic — meets the change.
That's where you observe.

| Change reaches | Surface | You |
|---|---|---|
| CLI / TUI | terminal | run the command, capture the output |
| Server / API | socket | send the request, capture the response |
| GUI / web UI | pixels | drive it (headless browser if needed), screenshot |
| Library | package boundary | call through the public export, not internals |
| Prompt / agent config | the agent | run the agent, capture its behavior |
| Scheduled job / workflow | the runner | trigger it, read the run |

An internal function is not a surface — something calls it, and that caller
ends at one of the rows above. Follow it there. If no runtime surface
exists (docs-only, types-only, tests-only), say so explicitly: **SKIP — no
runtime surface** is a legitimate verdict; a test run standing in for
observation is not.

## Drive it

Take the smallest path that makes the changed code execute:

- Changed a flag? Run with it.
- Changed a handler? Hit that route.
- Changed error handling? Trigger the error.
- Changed UI state? Drive the UI into that state and look at it.

End-to-end, through the real interface. Pieces passing in isolation does
not mean the flow works — seams are where bugs hide. If users click
buttons, verify by clicking buttons, not by curling the API underneath.

If the change touches destructive paths (deletes, publishes, sends,
payments) and there is no dry-run or safe target, do not drive it live —
verify around it and state plainly which path was not exercised and why.

## Push on it

Confirming the claim is the first half, not the job. You know exactly what
changed — probe *around* it at the same surface: empty values, wrong
methods, repeated actions, interrupts, stale state, the adjacent case the
diff didn't touch. A probe that finds nothing is still a finding worth one
line — it tells the reviewer what was covered.

## Report candidly

The verdict is binary and the evidence travels with it:

- **WORKS** — you observed the change doing its job at the surface.
- **DOESN'T** — you observed it failing, missing, or breaking something
  else. Report it plainly with the capture, *then* fix and re-verify.
  A found failure is the verification working, not a verification failure.
- **BLOCKED** — you could not reach a state where the change is observable.
  Say exactly where it stopped. Not a verdict on the change.
- **SKIP** — no runtime surface exists. One line why.

No partial pass: "3 of 4 scenarios worked" is DOESN'T until the fourth
works or is explained away. Ambiguous output is DOESN'T with the raw
capture attached — don't interpret in the change's favor. When in doubt,
the change doesn't work: a false WORKS ships broken behavior; a false
DOESN'T costs one more look.

Observations beyond the verdict are the signal: anything that made you
pause, work around, or go "huh" is information the author doesn't have.
Surprises found while observing become laundry-list items, not silent
fixes.
