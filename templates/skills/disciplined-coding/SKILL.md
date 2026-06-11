---
name: disciplined-coding
description: Use for any code change that requires disciplined implementation rigor — not trivial one-liners.
---

# disciplined-coding

## before you write code
- State your assumptions explicitly. If uncertain, ask.
- If the task is ambiguous, list the possible interpretations — don't pick silently.
- If a clearly simpler approach exists, recommend it. Push back if warranted.
- If you are confused about any aspect, stop and ask.

## while you write code
- Write the minimum code that solves the exact problem. Nothing more.
- Do not add features, abstractions, or configuration options beyond what was asked.
- Touch only the lines that need to change. Match existing style exactly.
- Do not add error handling for impossible scenarios.
- When removing code, clean up imports and variables that YOUR change made unused.

## after you write code
- Can every changed line be traced to the user's request? If not, undo it.
- Would a senior engineer say this is overcomplicated? If yes, simplify.
- Run the project's validation commands and fix any issues before declaring done.

## verification pattern
For any multi-step change, structure your plan as:
```
1. [step] → verify: [how you will check]
2. [step] → verify: [how you will check]
3. [step] → verify: [how you will check]
```
