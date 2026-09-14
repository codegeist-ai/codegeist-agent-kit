---
description: Verify documentation completeness and consistency
agent: build
---
Review the current repository state.
Follow @.opencode/rules/language-policy.md,
@.opencode/rules/ai-ready-documentation.md, and
@.opencode/rules/software-documentation.md.

If the user provided extra focus, use it as a hint:
$ARGUMENTS

Then:
1. Inventory the repo's current documentation surface, including `README.md`,
   source comments and docstrings, `.opencode/rules/*.md`,
   `.opencode/commands/*.md`, and `docs/` content if present.
2. When a repository-root `docs/` directory exists, require `docs/index.html`
   and verify its contract from the software documentation rule. Check its
   required project guidance, authoritative facts, relative local links and
   fragments, no-JavaScript readability, inline CSS and classic JavaScript,
   progressive interactions, restrictive content security policy, compact
   developer-map structure, semantics, keyboard access, responsive behavior, and
   direct `file://` operation without runtime file reads or required external
   resources.
3. Classify each index problem as `missing`, `stale`, `broken`, or
   `file-incompatible`, and report the concrete evidence. Do not require or
   create the page when the repository has no root `docs/` directory.
4. Verify that command, rule, source-comment, and Markdown references point to
   real files and useful sections.
5. Check that command lists, file counts, and workflow descriptions still match
   the repo.
6. Flag stale references, broken paths, contradictory guidance, missing
   contract-level source context, unclear operation-boundary diagnostics, and
   obvious language-policy violations. Pay particular attention to output that
   an LLM or automation must evaluate.
7. Report the result as a concise verification summary with concrete file paths
   for any issues.

Do not make edits unless the user explicitly asks for fixes after the report.
