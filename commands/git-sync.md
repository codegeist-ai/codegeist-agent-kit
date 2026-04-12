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
4. Stop and report if no suitable local base branch can be determined.
5. Stop and report if the current branch is that base branch.
6. Verify that the local base branch exists.
7. Determine whether the base branch is already checked out in another
   worktree.
8. Stop and report if the current worktree is not clean.
9. If the base branch is checked out elsewhere, stop and report if that
   worktree is not clean.
10. Execute @.opencode/commands/rebase.md with the resolved base branch as the
    explicit branch argument.
11. Record the current branch name, the resolved base branch, and the rebased
    HEAD commit.
12. Determine whether the rebased branch HEAD is already reachable from the
    local base branch.
13. If the rebased branch HEAD is not yet on the base branch and that branch is
    checked out elsewhere, fast-forward it there with
    `git -C <base-worktree> merge --ff-only <recorded-branch>`.
14. If the rebased branch HEAD is not yet on the base branch and that branch is
    not checked out elsewhere, switch to the local base branch in the current
    worktree.
15. If you switched to the base branch, fast-forward it with
    `git merge --ff-only <recorded-branch>`.
16. Verify that `git rev-list --left-right --count <base-branch>...<recorded-branch>`
    reports `0 0`.
17. Stop and report if the base branch and `<recorded-branch>` are still
    divergent.
18. Report the final synchronized commit hash, the current branch name, the
    resolved base branch, and whether that base branch was updated in the
    current worktree or another worktree.

Do not create a merge commit; only a fast-forward update of the base branch is
allowed.
Do not stash, clean, or modify unrelated changes; this workflow requires both
worktrees to already be clean.
Do not push to any remote.
