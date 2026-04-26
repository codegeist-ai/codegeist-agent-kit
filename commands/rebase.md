---
description: Rebase the current branch onto the local base branch
agent: build
---
Review the current git branch and working tree state.

Then:
1. Determine the current branch name.
2. Stop and report if `HEAD` is detached.
3. Determine the local base branch in this order:
   - the explicit branch name from `$ARGUMENTS`, if provided
   - a clearly documented local base branch from repo-local docs, if present
   - the local branch pointed to by `origin/HEAD`, if available
4. If no suitable local base branch can be determined because the repo has no
   remote default branch yet, or is a purely local repository created with
   `git init`, treat the rebase as a successful no-op and report that no base
   branch could be resolved.
5. Otherwise stop and report if no suitable local base branch can be
   determined.
6. If the current branch is already that base branch, treat the rebase as a
   successful no-op and report the current branch name, base branch, and current
   `HEAD` commit.
7. If the working tree is not clean, including staged, unstaged, or untracked
   changes, create a temporary stash first with `git stash push
   --include-untracked` so the rebase can proceed cleanly.
8. If task-related submodule changes would block the rebase, create temporary
   stashes inside those touched submodules as well.
9. Rebase the current branch onto the local base branch.
10. If the rebase stops on conflicts, do not discard anything.
11. Resolve rebase conflicts directly when the intended result is clear from the
    current task and repository state, then continue the rebase.
12. After a successful rebase, restore any temporary stash you created in the
    parent repo.
13. If you created temporary stashes inside submodules, first make sure each
    checked-out submodule revision matches the rebased branch's recorded gitlink,
    then restore the matching submodule stash.
14. If restoring either stash or continuing the rebase introduces conflicts,
    resolve them directly when the intended result is clear from the current
    task and repository state.
15. If any remaining conflict is not clear enough to do safely, report the
    conflicted files and the exact next commands the user should run.
16. If the rebase succeeds, report the current branch name, base branch, and
    new `HEAD` commit.

Do not switch away from the current branch.
Do not fetch from remotes or rebase onto a remote-tracking branch.
Do not use merge for this workflow.
Do not ignore task-related submodule changes during the rebase; stash and
restore them explicitly when needed.
