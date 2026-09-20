---
description: Review changes and create a git commit
agent: build
---
Review the current git status, staged and unstaged changes, and recent commit messages.
Follow the commit guidance in @.opencode/rules/commit.md.

Execute this workflow only when the current user request explicitly invokes
`/commit` or `/git-commit`, or otherwise asks to create or record a commit.

If the user provided extra context, use it as an additional hint for the commit message:
$ARGUMENTS

Then:
1. Identify the intended coherent change set from the current user request and
   task context. Keep unrelated pre-existing changes unstaged and report them.
2. Unless the user explicitly asks for multiple commits, create exactly one
   commit for that intended change set.
3. If the change set includes modified submodule contents, commit those changes
   inside the relevant submodule first unless they are already committed.
4. Do not fetch, rebase, synchronize, or push a touched submodule unless the
   current user request separately asks for that operation. Record any local
   submodule commit that remains unpushed.
5. Stage only the intended coherent change set, including matching documentation,
   tests, submodule gitlinks, and `.gitmodules` updates when they belong to it.
6. Exclude unrelated files, secrets, generated noise, and anything the user asks
   to leave out.
7. Draft one commit message that matches the project commit rule and describes
   the intended staged change set.
8. When `.opencode/ai-scripts/commit-message-guard.sh` exists, create the git
   commit through that script by setting `ARG_COMMIT_SUBJECT`, optionally
   `ARG_COMMIT_BODY`, and `ARG_EXECUTE=1`; otherwise use a direct `git commit`
   command that still follows `@.opencode/rules/commit.md`.
9. Report the final commit hash and message, any local submodule commits, and any
   unrelated dirty files intentionally left out.

Do not create an empty commit.
Do not commit secrets or generated noise.
Do not commit a parent submodule gitlink update without the corresponding
submodule commit.
Do not push any repository or submodule unless the current user request
separately authorizes that push.
Do not include unrelated edited files merely because they are present in the
worktree.
Do not split the current task into multiple commits unless the user explicitly
asks for that split.
Do not use literal `\n` escape sequences in commit-message inputs.
