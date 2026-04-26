# OpenCode Rules

Shared AI rules intended to work across repos.

## Purpose

- Keep durable workflow guidance close to the repo.
- Preserve a small shared rule core instead of carrying project-specific process
  everywhere.
- Move project-only assumptions into repo-local docs instead of treating them as
  shared defaults.

## Core Rules

- `chat.md` - how to maintain `docs/memory-bank/chat.md` when a repo uses it as
  lightweight
  project memory.
- `learn.md` - capture durable project guidance in the right rule file.
- `command-execution.md` - how commands should be chosen and run.
- `commit.md` - concise commit requirements used by repo workflows.

## Supporting Rules

- `commit-conventions.md` - longer-form commit guidance.
- `language-policy.md` - English for code and durable repo text.
- `ai-ready-documentation.md` - documentation standards for non-trivial files.
- `bash-scripts.md` - minimal Bash style for repo-owned shell scripts.
- `scripting-best-practices.md` - shell and automation guidance.
- `software-documentation.md` - how repo-local software documentation should be
  structured and maintained.
- `software-tests.md` - how to write, update, and verify software tests.
- `taskfile-and-script-creation.md` - how to add wrappers and Taskfiles safely.
- `task-workflow.md` - lightweight workflow for scoped implementation work.
- `memory-bank.md` - how to handle repo memory without forcing a heavy system.
- `session-titles.md` - short, searchable session title conventions.
- `ai-scripts.md` - policy for future `.opencode/ai-scripts/` helpers.
- `excalidraw.md` - editable `.excalidraw.svg` export requirements.

## Project-Specific Notes

- Keep repo-specific architecture, branch workflow, and planning assumptions in
  repo-local docs or local overlays such as `@.oc_local/rules/*.md`.
- Keep the shared rule set repo-agnostic and move project-only details into the
  consuming repo instead of the shared rule core.
