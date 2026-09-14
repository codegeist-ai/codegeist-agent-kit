# OpenCode Rules

Shared AI rules intended to work across repos.

## Purpose

- Keep durable workflow guidance close to the repo.
- Preserve a small shared rule core instead of carrying project-specific process
  everywhere.
- Move project-only assumptions into repo-local docs instead of treating them as
  shared defaults.

## Core Rules

- `learn.md` - capture durable project guidance in the right rule file.
- `command-execution.md` - how commands should be chosen and run.
- `commit.md` - concise commit requirements used by repo workflows.

## Supporting Rules

- `commit-conventions.md` - longer-form commit guidance.
- `tools.md` - Bash, system command, script, and package-install access rules
  for coding agents.
- `devcontainer-tools.md` - coding-relevant tools available in the devcontainer.
- `directory-index.md` - agent-owned, repository-root or directory-local
  `INDEX.md` navigation files for large directories, outside shared `.opencode`
  release content.
- `language-policy.md` - English for code and durable repo text.
- `ai-ready-documentation.md` - source comments, diagnostics, and documentation
  standards for reviewable non-trivial behavior.
- `bash-scripts.md` - direct, documented, and observable Bash style.
- `scripting-best-practices.md` - shell automation and structured logging
  guidance, including output consumed by LLMs.
- `software-documentation.md` - how repo-local software documentation should be
  structured and maintained.
- `software-tests.md` - how to write, update, and verify software tests.
- `taskfile-and-script-creation.md` - how to add wrappers and Taskfiles safely.
- `temporary-storage.md` - keep disposable artifacts outside persistent
  workspaces and persistent secrets under `.codegeist/secrets/`.
- `task-workflow.md` - canonical local task workflow with `spec`, `impl`,
  `cancel`, and `backlog`, plus Issue linkage and verified completion closure for
  confirmed GitHub mirrors.
- `session-titles.md` - short, searchable session title conventions.
- `ai-scripts.md` - policy for future `.opencode/ai-scripts/` helpers.
- `excalidraw.md` - editable `.excalidraw.svg` export requirements.
- `semver.md` - how to choose and format project release versions.

## Project-Specific Notes

- Keep repo-specific architecture, branch workflow, and planning assumptions in
  repo-local docs or local overlays such as `@.oc_local/rules/*.md`.
- Keep the shared rule set repo-agnostic and move project-only details into the
  consuming repo instead of the shared rule core.
