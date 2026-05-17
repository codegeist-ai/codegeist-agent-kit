---
description: Create or refresh an agent-owned directory INDEX.md
agent: build
---
Create or refresh an `INDEX.md` navigation file for a directory.

Follow @.opencode/rules/directory-index.md,
@.opencode/rules/software-documentation.md, and
@.opencode/rules/language-policy.md.

User intent or target path:
$ARGUMENTS

Then:
1. Resolve the target directory from the user's request. If no directory is
   clear, use the current work scope and ask one short clarification question
   only when needed.
   If the target is the repository root, write `INDEX.md` at the repository root,
   not inside `.opencode/`.
2. Inspect the target directory, nearby parent `INDEX.md` files, and directly
   relevant docs or config files before writing.
3. Create or rewrite the target directory's `INDEX.md` so it is compact,
   current, and useful for future coding agents to load into context.
4. Include practical search hints, important files, related entrypoints, and
   update triggers. Omit sections that do not add useful local context.
5. Link to other `INDEX.md` files when that helps agents navigate related
   directories. If an `INDEX.md` is added, moved, or removed, update the
   repository-root `INDEX.md` list of known directory indexes.
6. Preserve human-facing docs as the source of truth when they already explain a
   topic well; link to them instead of duplicating long prose.
7. Report the updated `INDEX.md` path and the main navigation hints added.

Do not create indexes for tiny directories unless there is a non-obvious reason.
Do not add secrets, transcripts, raw command output, or speculative plans.
Do not create `.opencode/INDEX.md`; the shared `.opencode` submodule must not
own project-specific root navigation context.
