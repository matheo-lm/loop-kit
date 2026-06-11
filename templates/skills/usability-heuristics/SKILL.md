---
name: usability-heuristics
description: Use when designing or reviewing any user-facing surface — evaluate against Nielsen's 10 usability heuristics, name the violated heuristic, and rate severity 0-4 so findings are prioritized fixes, not opinions.
---

# usability-heuristics

Condensed from the usability canon — Jakob Nielsen's 10 heuristics (NN/g), Don Norman's signifiers and feedback, Ben Shneiderman's golden rules, Dieter Rams' "less, but better". Structure inspired by [jpoindexter/design-and-ai-skills](https://github.com/jpoindexter/design-and-ai-skills).

A finding without a principle is an opinion; a finding without severity can't be prioritized. When you flag a problem: name the heuristic, rate the severity, propose the fix.

## the 10 heuristics

| # | Heuristic | Rule of thumb | Typical fix |
|---|-----------|---------------|-------------|
| H1 | Visibility of system status | Every action gives immediate feedback; every wait shows progress. | Loading states, disabled-on-submit, explicit success/failure confirmation. |
| H2 | Match the real world | Speak the user's language, never internal codes or jargon. | Translate errors to plain language; use the words real users use. |
| H3 | User control and freedom | Every state has a clearly marked exit; mistakes are reversible. | Cancel/Back everywhere; prefer an undo toast over a confirm nag. |
| H4 | Consistency and standards | Same word, color, and position for the same action; follow platform conventions. | One term per concept; use the design system, not bespoke variants. |
| H5 | Error prevention | Design so the error can't happen, rather than reporting it well. | Constrain inputs (pickers, masks, disabled invalid options); validate inline before submit. |
| H6 | Recognition over recall | Show options and carry context forward; never make users remember across screens. | Autocomplete, recents, visible choices, prefilled data, placeholders. |
| H7 | Flexibility and efficiency | Accelerators for experts that stay invisible to novices. | Shortcuts, bulk actions, saved views — behind progressive disclosure. |
| H8 | Aesthetic and minimalist design | Every extra element competes with the relevant ones. | Cut ruthlessly; one primary action per screen; disclose detail on demand. |
| H9 | Help users recover from errors | Errors say what happened, why, and how to fix it — in plain language, at the point of error. | Specific inline messages; preserve the user's input. |
| H10 | Help and documentation | Best is needing none; otherwise contextual, searchable, task-focused. | Tooltips and guided empty states over manuals. |

Also check (Norman): every interactive element has a visible signifier — nothing clickable should look like plain text, and nothing decorative should look clickable.

## evaluation method

1. Walk the interface twice: once for flow, once inspecting each element against every heuristic.
2. Log each problem: location, heuristic violated, why it's a problem, severity, recommended fix.
3. Sort by severity descending; fix top-down.

Severity scale (Nielsen, 0-4):

| Rating | Meaning | Action |
|--------|---------|--------|
| 0 | Not a usability problem | Ignore |
| 1 | Cosmetic | Fix if spare time |
| 2 | Minor | Schedule |
| 3 | Major | Fix before release |
| 4 | Catastrophe | Block release |

## common violations

- Silent submit button → double-charge from re-tapping (H1): disable on tap, show progress, confirm result.
- Raw error codes surfaced to users (`HTTP 500`, `EACCES`) (H2, H9): plain-language what/why/fix.
- Destructive or bulk action with no undo (H3, H5): undo window, or type-to-confirm for the irreversible.
- "Submit" / "Send" / "Go" all meaning the same action (H4): one term, everywhere.
- Free-text field where a picker fits; server-side-only validation (H5): constrain and validate inline.
- Form clears the user's input on error (H9): preserve everything they typed.

## when reviewing a diff

If the change touches anything user-facing, run the table above against the changed screens and report findings in the evaluation format: `location · heuristic · why · severity · fix`. Findings of severity 3+ block the ship.
