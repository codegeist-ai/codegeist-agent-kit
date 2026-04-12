---
description: Refresh documentation affected by recent changes
agent: build
---
Review the current repository state, recent git changes, and existing docs.
Follow @.opencode/rules/chat.md,
@.opencode/rules/learn.md,
@.opencode/rules/ai-ready-documentation.md, and
@.opencode/rules/memory-bank.md.

If the user provided extra focus, use it as a hint:
$ARGUMENTS

Then:
1. Identify which docs actually need updates based on the recent changes.
2. Prefer updating the small set of repo-owned docs most likely to drift, for
   example `README.md`, a project-memory file such as
   `docs/memory-bank/chat.md`,
   `.opencode/rules/README.md`, `.opencode/commands/README.md`, and any
   directly affected docs under `docs/` if that tree exists.
3. Refresh counts, command lists, and file-path references when they are now
   stale.
4. Keep documentation proportional; do not create a large new docs structure
   unless the change truly requires it.
5. Report which files were updated, what changed, and any remaining manual
   follow-up.

Do not rewrite unrelated documentation just to make it look uniform.
