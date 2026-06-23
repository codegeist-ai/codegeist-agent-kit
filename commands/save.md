---
description: Refresh memory, commit, rebase, and push the current branch
agent: build
---
Review the current repository state and the active chat context.

This workflow is branch-aware:

- When the current branch is the resolved local base branch, save that branch by
  committing, rebasing it onto its refreshed upstream when needed, and pushing it.
- When the current branch is not the resolved local base branch, keep the work on
  the current branch: update the local base branch from its upstream first, rebase
  the current branch, and push only the current branch. Do not fast-forward or
  push the base branch to the current branch from this feature-branch path.

If this repo uses `docs/memory-bank/chat.md` as lightweight project memory, execute
@.opencode/commands/update-chat.md first so the memory reflects the current repo
state and chat context.

Then execute @.opencode/commands/learn.md so durable project guidance from the
current repository state and chat context is captured before the commit.

Then execute @.opencode/commands/update-submodules.md so `.opencode` and
`.devcontainer` are refreshed to their configured branches before the commit.

Then review the current git status, staged and unstaged changes, and recent
commit messages. Follow @.opencode/rules/commit.md and
@.opencode/rules/commit-conventions.md.

If the user provided extra context, use it as an additional hint for the commit
message:
$ARGUMENTS

Then:
1. Determine the current branch name and stop if `HEAD` is detached.
2. Determine the local base branch in this order:
   - a clearly documented local base branch from repo-local docs, if present
   - the local branch pointed to by `origin/HEAD`, if available
3. If no suitable local base branch can be determined because the repo has no
   remote default branch yet, or is a purely local repository created with
   `git init`, continue as a current-branch-only save and report that no base
   branch could be resolved.
4. Record whether the current branch is the local base branch.
5. If the task changed any submodule contents, commit the relevant submodule
   changes first.
6. If the task changed submodule configuration such as path or URL, stage the
   matching `.gitmodules` update together with the intended parent gitlink
   update.
7. For each touched submodule, determine the intended branch and whether it has
   a configured upstream.
8. If a touched submodule branch has a configured upstream, verify that the
   referenced remote exists and can be fetched. Stop and report only when a
   configured upstream remote cannot be reached or refreshed.
9. For each touched submodule branch with a configured upstream, fast-forward or
   rebase the local branch onto the refreshed upstream when needed, push that
   branch, and verify that the local branch and upstream are synchronized. If a
   normal push is refused because the remote is a checked-out local repo,
   fast-forward that checked-out repo directly and verify the same
   synchronization before continuing.
10. Only stage the intended parent gitlink update after the submodule commit
    exists and any configured upstream synchronization for the touched submodules
    is complete.
11. Stage the relevant changes for the current task, including any refreshed
    project-memory or rule updates that belong to the task. If
    @.opencode/commands/update-submodules.md changed the parent gitlinks for
    `.opencode` or `.devcontainer`, treat those gitlink updates as task changes
    and stage them in this same commit.
12. Draft a commit message that matches the project commit rule.
13. When `.opencode/ai-scripts/commit-message-guard.sh` exists, create the git
    commit through that script by setting `ARG_COMMIT_SUBJECT`, optionally
    `ARG_COMMIT_BODY`, and `ARG_EXECUTE=1`; otherwise use a direct `git commit`
    command that still follows @.opencode/rules/commit.md.

If the current branch is the local base branch:

14. Determine whether the base branch has a configured upstream.
15. If the base branch has a configured upstream, verify that the referenced
    remote exists and can be fetched, then fetch that upstream.
16. Rebase the current base branch onto the refreshed upstream when the upstream
    contains commits that are not local. If conflicts occur, resolve them only
    when the intended result is clear; otherwise stop and report.
17. Push the base branch to its configured upstream with a normal non-force push.
18. If that push is rejected because the upstream moved, fetch that upstream,
    rebase the base branch onto the refreshed upstream, and retry the normal push
    until the local and remote refs match or a conflict must be reported.
19. Verify that the base branch and its upstream are synchronized when an
    upstream is configured.
20. Report the final commit hash, commit message, base branch, and push result.

If the current branch is not the local base branch:

14. Verify that the local base branch exists when one was resolved.
15. Determine whether the local base branch has a configured upstream.
16. If the local base branch has a configured upstream, verify that the
    referenced remote exists and can be fetched, then fetch that upstream.
17. Update the local base branch before pushing the current branch:
    - If the base branch is checked out in another worktree, stop and report if
      that worktree is not clean, then rebase the base branch in that worktree
      onto its refreshed upstream when needed.
    - If the base branch is not checked out elsewhere, create a temporary
      worktree outside the repository for the base branch, rebase it there onto
      its refreshed upstream when needed, then remove the temporary worktree
      after the current branch has been rebased.
    - Do not switch the current worktree away from the current branch.
    - Do not push the base branch from this feature-branch save path.
18. Determine whether the current branch has a configured upstream.
19. If the current branch has a configured upstream, verify that the referenced
    remote exists and can be fetched, then fetch that upstream.
20. If the current branch has a configured upstream and the refreshed upstream
    contains commits that are not local, rebase the current branch onto that
    upstream first so remote branch changes are preserved.
21. Rebase the current branch onto the updated local base branch when a base
    branch was resolved.
22. If conflicts occur during either current-branch rebase, resolve them only
    when the intended result is clear; otherwise stop and report.
23. Push only the current branch:
    - If the current branch has no upstream and `origin` exists, push with
      `git push -u origin <current-branch>`.
    - If the current branch has an upstream and the rebase rewrote commits that
      are already on the upstream branch, push the current branch with
      `--force-with-lease` for that current branch only.
    - Otherwise use a normal push to the current branch upstream.
24. If the current-branch push is rejected because the upstream moved, fetch the
    current branch upstream, rebase the current branch onto that refreshed
    upstream, rebase the current branch onto the updated local base branch again
    when a base branch was resolved, and retry the current-branch push with the
    same current-branch-only `--force-with-lease` rule when the rebase rewrote
    upstream commits.
25. Verify that the current branch and its upstream are synchronized after the
    push when an upstream is configured or was created.
26. Verify that the current worktree is still on the original current branch.
27. Report the final commit hash, commit message, current branch, updated base
    branch, whether the base branch push was skipped, and the current-branch push
    result.

Do not create an empty commit.
Do not commit secrets or unrelated files.
Do not ignore task-related submodule changes; either include the intentional
submodule update or stop and report why it could not be completed safely.
Do not fast-forward the local base branch to the current feature branch.
Do not push the local base branch when the current branch is not the base branch.
Do not switch the current worktree away from a feature branch during the
feature-branch save path.
Do not create a merge commit; use rebase for branch synchronization.
Do not force-push the local base branch.
Use `--force-with-lease` only for the current non-base branch after a rebase and
only after fetching that branch's upstream.
Do not update `docs/memory-bank/chat.md` after the commit only to record the
commit hash, rebased HEAD, push result, or other routine completion metadata.
If commit, rebase, or push fails, stop and report the exact failure.
Do not use literal `\n` escape sequences in commit-message inputs.
