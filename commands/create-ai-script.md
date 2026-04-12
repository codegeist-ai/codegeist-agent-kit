---
description: Create a repo-local AI helper script
agent: build
---
Review the current repository state.
Follow @.opencode/rules/ai-scripts.md,
@.opencode/rules/ai-ready-documentation.md,
@.opencode/rules/scripting-best-practices.md, and
@.opencode/rules/language-policy.md.

User intent:
$ARGUMENTS

Then:
1. Decide whether a new script is justified instead of an existing command,
   rule, or built-in tool.
2. If a script is justified, create the smallest useful implementation under
   `.opencode/ai-scripts/`.
3. Keep the script non-interactive by default and make its output structured and
   easy for future AI sessions to scan.
4. Add or update `.opencode/ai-scripts/README.md` when the directory changes.
5. Refresh `@.opencode/rules/ai-scripts.md` if the new script changes durable
   guidance.
6. Make the script executable when appropriate.
7. Report the created files, usage, and why a script was the right choice.

Do not add an AI script if the repo's existing commands or tools already solve
the problem more cleanly.
