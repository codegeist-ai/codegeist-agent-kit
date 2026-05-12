---
description: Rebase current branch and sync base branch
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
   `git init`, treat the sync as a successful no-op and report that no base
   branch could be resolved.
5. Otherwise stop and report if no suitable local base branch can be determined.
6. Stop and report if the current branch is that base branch.
7. Verify that the local base branch exists.
8. Determine whether the base branch is already checked out in another
   worktree.
9. Stop and report if the current worktree is not clean.
10. If the base branch is checked out elsewhere, stop and report if that
   worktree is not clean.
11. Execute @.opencode/commands/rebase.md with the resolved base branch as the
    explicit branch argument.
12. Record the current branch name, the resolved base branch, and the rebased
    HEAD commit.
13. Determine whether the rebased branch HEAD is already reachable from the
    local base branch.
14. If the rebased branch HEAD is not yet on the base branch and that branch is
    checked out elsewhere, fast-forward it there with
    `git -C <base-worktree> merge --ff-only <recorded-branch>`.
15. If the rebased branch HEAD is not yet on the base branch and that branch is
    not checked out elsewhere, switch to the local base branch in the current
    worktree.
16. If you switched to the base branch, fast-forward it with
    `git merge --ff-only <recorded-branch>`.
17. Verify that `git rev-list --left-right --count <base-branch>...<recorded-branch>`
    reports `0 0`.
18. Stop and report if the base branch and `<recorded-branch>` are still
    divergent.
19. Report the final synchronized commit hash, the current branch name, the
    resolved base branch, and whether that base branch was updated in the
    current worktree or another worktree.

Do not create a merge commit; only a fast-forward update of the base branch is
allowed.
Do not stash, clean, or modify unrelated changes; this workflow requires both
worktrees to already be clean.
Do not push to any remote.
