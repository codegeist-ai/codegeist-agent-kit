---
description: Capture durable project guidance from the current context
agent: build
---
Review the current repository state and the active chat context.
Follow @.opencode/rules/learn.md.

If the user provided extra context, use it as an additional hint for what to
capture:
$ARGUMENTS

Then:
1. Identify durable project-specific guidance that should be remembered.
2. Update the most relevant rule files first, and prefer the narrowest existing
   rule that fits the guidance instead of creating overlap.
3. Rewrite or remove obsolete guidance if newer decisions replace it.
4. Update @docs/memory-bank/chat.md when this repo uses it and the learned guidance materially
   changes project memory.
5. Report what was learned, what changed, and which files were updated.

Do not add speculative rules.
Do not record secrets or transient debugging details.
