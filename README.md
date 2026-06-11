# loop-kit

**Bootstrap loop engineering into any codebase in one command.**

A structured starter kit that adds the five pieces of [loop engineering](https://addyosmani.com/blog/loop-engineering/) to your project — memory, skills, sub-agents, automations, and worktrees — plus the [Karpathy disciplined coding](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md) operating principles.

```
curl -fsSL https://raw.githubusercontent.com/matheo-lm/loop-kit/main/scripts/loop-init.sh | bash
```

That's it. Six files land in your repo. The agent reads them, understands how to operate, and the loop begins.

---

## Why

Until mid-2026, getting work out of a coding agent meant writing a good prompt every time. You type, it responds, you type again. The agent is a tool and you are holding it.

Loop engineering changes that. You design a system that finds the work, hands it out, checks it, writes down what's done, and decides the next thing — and you let that system poke the agents instead of you.

> "I don't prompt Claude anymore. I have loops running that prompt Claude and figuring out what to do. My job is to write loops." — Boris Cherny, head of Claude Code at Anthropic

Loop-kit gives you the five pieces, ready to drop in:

| Piece | File | What it does |
|-------|------|-------------|
| **Memory** | `STATE.md` | Persistent session state. Agent reads at start, writes at end. The model forgets; the repo doesn't. |
| **Skills** | `SKILL.md` | Codified project knowledge. Conventions, build steps, rationale — written once, read every run. |
| **Sub-agents** | `.agents/reviewer.md` | Maker/checker separation. One writes, a second verifies. |
| **Automations** | `.github/workflows/` | Scheduled discovery and triage without human prompting. |
| **Worktrees** | `AGENTS.md` | Documented `git worktree` pattern for parallel agents. |

Plus the **Karpathy operating principles** at the top of `AGENTS.md`: think before coding, simplicity first, surgical changes, goal-driven execution.

---

## What gets created

After running the bootstrap, your repo gets:

```
SESSION.md                        ← session-start prompt (give this to your agent)
AGENTS.md                         ← operating model + principles
STATE.md                          ← session memory
SKILL.md                          ← disciplined coding skill
docs/soul.md                      ← quality gap tracker
docs/done_soul.md                 ← completed items archive
.agents/reviewer.md               ← code review sub-agent
.agents/security-auditor.md       ← security audit sub-agent
```

**AGENTS.md** is the spine. It contains:
- Operating Principles (Karpathy's 4 rules)
- Loop Engineering methodology (the 5 pieces + session workflow)
- Placeholders for your project's structure, commands, and conventions

Fill in the placeholders, commit, and the loop is ready to run.

---

## How to use

### One-shot setup

```bash
curl -fsSL https://raw.githubusercontent.com/matheo-lm/loop-kit/main/scripts/loop-init.sh | bash
```

Then edit `AGENTS.md` with your project's:
- Build/test/typecheck commands
- Project structure
- Coding style conventions
- Testing guidelines

### Start every session with this prompt

After setup, **`SESSION.md` is what you give your agent** at the start of each session. It tells the agent:

```
Read AGENTS.md → read STATE.md + docs/soul.md → run 5-phase operating loop → commit → loop
```

Open your agent's chat/terminal and paste:

```
Read SESSION.md and follow it. The project is at <path-to-repo>.
```

Or reference the file path directly if your agent supports file reading:

```
Read <path-to-repo>/SESSION.md and follow it.
```

The agent then runs the full ritual: gather evidence, build candidates, commit to one item, implement, verify, bookkeep, and loop until done.

---

### Two-shot with audit

```bash
curl -fsSL https://raw.githubusercontent.com/matheo-lm/loop-kit/main/scripts/loop-init.sh | bash
# then manually:
code docs/soul.md  # populate via codebase audit
```

Run a deep audit of your codebase (grep for common issues, inspect components, check test coverage) and populate `docs/soul.md` with findings. This gives the agent a ranked backlog to work from.

### Add project skills

Domain-specific skills go under `skills/<name>/SKILL.md`. Loop-kit ships with one starter skill — `skills/design/SKILL.md` — adapted from [Anthropic's frontend-design skill](https://agenticskills.io/skills/frontend-design). Add more:

```
skills/
  design/SKILL.md                  ← frontend design (included)
  react-best-practices/SKILL.md    ← Vercel's 70 React rules
  react-native-best-practices/     ← Callstack's RN perf guide
  systematic-debugging/            ← 4-phase debug methodology
  webapp-testing/                  ← Playwright testing guide
```

---

## Agent workflow

Every session follows the phased loop in `SESSION.md`:

```
SESSION.md → AGENTS.md → STATE.md + soul.md → gather evidence → build candidates →
commit to one → implement → verify → bookkeep → commit + push → loop
```

The user's part: give `SESSION.md` to your agent at session start.

The agent's part: everything else — planning, implementation, verification, bookkeeping, looping.

---

## Philosophy

Loop-kit is built on three convictions:

1. **The model forgets; the repo doesn't.** Everything important lives on disk — not in context. State, skills, and principles are files, not prompts.

2. **The agent that writes should never be the agent that grades.** Sub-agents with different instructions catch what the implementer talked itself into.

3. **Simple > clever.** A markdown file for memory is dumber than a vector database. It also works every time, costs nothing, and every agent can read it.

---

## Project status

This is a starter kit, not a framework. It gives you the files and the pattern. You supply the project-specific conventions, build commands, and domain expertise.

The templates are universal — they work with any coding agent (Claude Code, opencode, Codex, Cursor, Copilot) and any language or stack.

---

## License

MIT
