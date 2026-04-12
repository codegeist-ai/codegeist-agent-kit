---
description: Generate a short session title for the current work
agent: build
---
Review @.opencode/rules/session-titles.md.

If the user provided input, use it as the first hint:
$ARGUMENTS

Then:
1. Run `git --no-pager status --short --branch` first.
2. Use the current git branch from that status output as the bracketed
   identifier at the start of the title.
3. Determine a short description of the most recent meaningful outcome from the
   session, using any user input only as a hint for that description.
4. Prefer short result-oriented phrasing such as `Adjust opencode rules` or
   `Implement feature flags` instead of generic task labels.
5. Enforce the repo rules: ASCII only, concise wording, branch-first brackets,
   and a recent-result suffix.
6. Return exactly one line wrapped in inline code.

Do not replace the leading branch identifier with a task id or user prefix.
