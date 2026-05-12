---
description: Compress the current chat into docs/memory-bank/chat.md
agent: build
---
Review the current repository state and the active chat context.
Follow @.opencode/rules/chat.md.

Then update @docs/memory-bank/chat.md so that it becomes a compact, living summary of the
current chat.

Requirements:
1. Keep only the information that is still useful and true.
2. Add important new decisions, completed work, and still-relevant next steps.
3. Remove or rewrite obsolete content when the newer context supersedes it.
4. Prefer a concise, lively markdown structure over a transcript.
5. Make sure the result matches the current repository state.
6. Do not add routine final commit ids, rebased HEAD ids, push results, or sync
   summaries only so they can be committed after the task commit. Those belong
   in the assistant response unless the identifier is itself durable project
   state, such as a release or deployment anchor.
