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
3. If the change set includes modified submodule contents, commit those changes
   inside the relevant submodule first unless they are already committed.
4. For each touched submodule, determine the intended branch and whether it has
   a configured upstream.
5. If a touched submodule branch has a configured upstream, verify that the
   upstream remote can be fetched, synchronize the local branch with that
   upstream when needed, push the submodule branch when it has local commits,
   and verify that the local branch and upstream are synchronized.
6. Stage the full edited change set for that single commit, including docs,
   memory updates, workflow files, and other edited files even when they do not
   belong to the task's main implementation area.
7. If the change set includes submodule gitlink updates, stage the intended
   parent gitlink updates after the matching submodule commits and upstream
   synchronization are complete. Stage matching `.gitmodules` updates with the
   gitlink updates when submodule configuration changed.
8. Exclude only secrets, generated noise, or files the user explicitly asks to
   leave out.
9. Draft one commit message that matches the project commit rule and describes
   the overall result of the full staged change set.
10. When `.opencode/ai-scripts/commit-message-guard.sh` exists, create the git
   commit through that script by setting `ARG_COMMIT_SUBJECT`, optionally
   `ARG_COMMIT_BODY`, and `ARG_EXECUTE=1`; otherwise use a direct `git commit`
   command that still follows `@.opencode/rules/commit.md`.
11. Report the final commit hash and commit message, plus any committed
   submodule paths and their synchronized upstream refs.

Do not create an empty commit.
Do not commit secrets or generated noise.
Do not commit a parent submodule gitlink update without the corresponding
submodule commit and, when configured, upstream synchronization.
Do not omit edited files only because they appear outside the main task area.
Do not split the current task into multiple commits unless the user explicitly
asks for that split.
Do not use literal `\n` escape sequences in commit-message inputs.
