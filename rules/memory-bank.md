# Repo Memory

Use a lightweight project-memory file when the repo benefits from one.

## Start Of Task

- Read the repo's current memory file when one exists, usually under
  `docs/memory-bank/`.
- Read the relevant rules under `.opencode/rules/`.
- Inspect the affected repo files directly before making assumptions.

## Memory File Location

- Store lightweight repo memory files under `docs/memory-bank/` in the current
  workspace.
- Prefer `docs/memory-bank/chat.md` as the default lightweight memory file
  unless the repo explicitly documents a different primary file in the same
  directory.
- If `docs/memory-bank/` does not exist yet, create it before writing or
  migrating memory files.
- If a repo uses additional memory files, keep them in `docs/memory-bank/` and
  keep one clearly documented primary memory file as the source of truth.
- When a repo still has a legacy root-level `chat.md`, treat it as migration
  debt and move or consolidate it into `docs/memory-bank/` when the repo
  workflow allows it.

## Update Triggers

- After durable workflow or behavior changes.
- After meaningful rule updates.
- When the user explicitly asks to refresh repo memory.
- When future sessions would miss important context without an update.

## Working Style

- Keep the memory file compact and current rather than turning it into a
  transcript.
- Prefer one source of truth for durable project state.
- If a repo later grows a larger memory structure, keep the relationship between
  the lightweight memory file and the heavier docs explicit.
