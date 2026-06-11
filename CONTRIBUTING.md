# Contributing

Loop-kit is a starter kit, not a framework. The goal is to keep the templates universal and minimal — good defaults that work for any project.

## Principles

- **Universal templates.** Every template should work for any language, stack, or agent tool. No project-specific assumptions.
- **Minimum viable.** Each file should be the smallest thing that does its job. No feature creep in the bootstrap.
- **One command.** The init script is the entry point. Everything must work via `curl | bash`.

## How to contribute

### Templates

Templates live in `templates/`. Each template is a standalone file that gets copied into the target repo. Guidelines:

- Use `<>` placeholders for project-specific values (e.g., `<branch>`, `<build command>`).
- Keep explanations short. The README is for context; templates are for direct use.
- No emoji, no markdown flair in templates — agents parse them for instructions, not humans.

### Skills

Skills live in `templates/skills/<name>/SKILL.md`. They should be:
1. Adapted from existing public skills with clear attribution
2. Universal enough to work in any codebase (use `<placeholder>` for project-specific details)
3. Limited to high-impact patterns — not every skill belongs in a starter kit

### Init script

`scripts/loop-init.sh` is a single portable bash script. No dependencies beyond `curl` and `mkdir`. Run `shellcheck` on changes.

## PR process

1. Open an issue describing the change
2. Fork, branch, commit
3. PR with a clear title using conventional commits (`feat:`, `fix:`, `chore:`)
4. Ensure the init script still works: `bash scripts/loop-init.sh /tmp/test-project`

## Release

Releases are tagged manually. Each release bumps the version in the README install command.
