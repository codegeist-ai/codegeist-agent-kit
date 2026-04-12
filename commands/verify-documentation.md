---
description: Verify documentation completeness and consistency
agent: build
---
Review the current repository state.
Follow @.opencode/rules/chat.md,
@.opencode/rules/language-policy.md,
@.opencode/rules/ai-ready-documentation.md, and
@.opencode/rules/memory-bank.md.

If the user provided extra focus, use it as a hint:
$ARGUMENTS

Then:
1. Inventory the repo's current documentation surface, including `README.md`,
   any project-memory file such as `docs/memory-bank/chat.md`, `.opencode/rules/*.md`,
   `.opencode/commands/*.md`, and `docs/` content if present.
2. Verify that command and rule references point to real files.
3. Check that command lists, file counts, and workflow descriptions still match
   the repo.
4. Flag stale references, broken paths, contradictory guidance, and obvious
   language-policy violations.
5. Report the result as a concise verification summary with concrete file paths
   for any issues.

Do not make edits unless the user explicitly asks for fixes after the report.
