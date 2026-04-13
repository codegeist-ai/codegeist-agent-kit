---
description: Review changes and create a git commit
agent: build
---
Review the current git status, staged and unstaged changes, and recent commit messages.
Follow the commit guidance in @.opencode/rules/commit.md and
@.opencode/rules/commit-conventions.md.

Review @docs/memory-bank/chat.md when this repo uses it and it helps explain the current branch,
worktree, or task context for the commit.

If the user provided extra context, use it as an additional hint for the commit message:
$ARGUMENTS

Then:
1. Review the edited files as one intended change set for the current working
   state.
2. Unless the user explicitly asks for multiple commits, create exactly one
   commit for the full edited change set.
3. Stage the full edited change set for that single commit, including docs,
   memory updates, workflow files, and other edited files even when they do not
   belong to the task's main implementation area.
4. Exclude only secrets, generated noise, or files the user explicitly asks to
   leave out.
5. Draft one commit message that matches the project commit rule and describes
   the overall result of the full staged change set.
6. When `.opencode/ai-scripts/commit-message-guard.sh` exists, create the git
   commit through that script by setting `ARG_COMMIT_SUBJECT`, optionally
   `ARG_COMMIT_BODY`, and `ARG_EXECUTE=1`; otherwise use a direct `git commit`
   command that still follows `@.opencode/rules/commit.md`.
7. Report the final commit hash and commit message.

Do not create an empty commit.
Do not commit secrets or generated noise.
Do not omit edited files only because they appear outside the main task area.
Do not split the current task into multiple commits unless the user explicitly
asks for that split.
Do not use literal `\n` escape sequences in commit-message inputs.
