---
description: Verify documentation completeness and consistency
agent: build
---
Review the current repository state.
Follow @.opencode/rules/language-policy.md and
@.opencode/rules/ai-ready-documentation.md.

If the user provided extra focus, use it as a hint:
$ARGUMENTS

Then:
1. Inventory the repo's current documentation surface, including `README.md`,
   source comments and docstrings, `.opencode/rules/*.md`,
   `.opencode/commands/*.md`, and `docs/` content if present.
2. Verify that command, rule, source-comment, and Markdown references point to
   real files and useful sections.
3. Check that command lists, file counts, and workflow descriptions still match
   the repo.
4. Flag stale references, broken paths, contradictory guidance, missing
   contract-level source context, unclear operation-boundary diagnostics, and
   obvious language-policy violations. Pay particular attention to output that
   an LLM or automation must evaluate.
5. Report the result as a concise verification summary with concrete file paths
   for any issues.

Do not make edits unless the user explicitly asks for fixes after the report.
