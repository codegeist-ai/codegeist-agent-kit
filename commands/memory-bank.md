---
description: Refresh the repo memory file using the repo memory rules
agent: build
---
Review the current repository state and the active chat context.
Follow @.opencode/rules/memory-bank.md.

If the repo keeps its lightweight memory in `docs/memory-bank/chat.md`, also follow
@.opencode/rules/chat.md when updating it.

If the user provided extra context, use it as an additional hint for what to
preserve or rewrite:
$ARGUMENTS

Then:
1. Identify the repo's current lightweight memory file, usually
   @docs/memory-bank/chat.md.
2. Read the relevant rules under @.opencode/rules/ and inspect the affected
   repo files directly before changing the memory file.
3. Rewrite the memory so it stays compact, current, and aligned with the
   repository's actual state instead of becoming a transcript.
4. Keep one clear source of truth for durable project state and remove or
   rewrite obsolete entries when newer context replaces them.
5. Report which memory file was updated and the main changes that were made.

Do not add speculative plans or stale history.
Do not record secrets, credentials, or transient command output unless a result
materially changes project state.
