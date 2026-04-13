---
description: Refresh memory, commit, rebase, and sync base branch
agent: build
---
Review the current repository state and the active chat context.

If this repo uses `docs/memory-bank/chat.md` as lightweight project memory, execute
@.opencode/commands/update-chat.md first so the memory reflects the current repo
state and chat context.

Then execute @.opencode/commands/learn.md so durable project guidance from the
current repository state and chat context is captured before the commit.

Then review the current git status, staged and unstaged changes, and recent
commit messages. Follow @.opencode/rules/commit.md and
@.opencode/rules/commit-conventions.md.

If the user provided extra context, use it as an additional hint for the commit
message:
$ARGUMENTS

Then:
1. If the task changed any submodule contents, commit the relevant submodule
   changes first.
2. If the task changed submodule configuration such as path or URL, stage the
   matching `.gitmodules` update together with the intended parent gitlink
   update.
3. For each touched submodule, determine the intended branch and whether it has
   a configured upstream.
4. If a touched submodule branch has a configured upstream, verify that the
   referenced remote exists and can be fetched. Stop and report only when a
   configured upstream remote cannot be reached or refreshed.
5. For each touched submodule branch with a configured upstream, fast-forward or
   rebase the local branch onto the refreshed upstream when needed, push that
   branch, and verify that the local branch and upstream are synchronized. If a
   normal push is refused because the remote is a checked-out local repo,
   fast-forward that checked-out repo directly and verify the same
   synchronization before continuing.
6. Only stage the intended parent gitlink update after the submodule commit
   exists and any configured upstream synchronization for the touched
   submodules is complete.
7. Stage the relevant changes for the current task, including any refreshed
   project-memory or rule updates that belong to the task.
8. Draft a commit message that matches the project commit rule.
9. When `.opencode/ai-scripts/commit-message-guard.sh` exists, create the git
   commit through that script by setting `ARG_COMMIT_SUBJECT`, optionally
   `ARG_COMMIT_BODY`, and `ARG_EXECUTE=1`; otherwise use a direct `git commit`
   command that still follows `@.opencode/rules/commit.md`.
10. Execute @.opencode/commands/rebase.md on the current branch.
11. Record the current branch name, the resolved local base branch, and the
    rebased HEAD commit after the rebase succeeds.
12. Verify that the local base branch exists.
13. Determine whether the local base branch has a configured upstream.
14. If the local base branch has a configured upstream, verify that the
    referenced remote exists and can be fetched. Stop and report only when a
    configured upstream remote cannot be reached or refreshed.
15. If the local base branch has a configured upstream and is not synchronized
    with the refreshed upstream, update the local base branch with a
    fast-forward when possible
    or a rebase when needed.
16. If refreshing the local base branch changed the base commit for the current
    branch, execute @.opencode/commands/rebase.md on the current branch again
    and re-record the current branch name, the resolved base branch, and the
    rebased HEAD commit.
17. Determine whether the rebased branch HEAD is already reachable from the
    local base branch.
18. If the rebased branch HEAD is not yet on the local base branch, determine
    whether that base branch is already checked out in another worktree.
19. If the base branch is checked out elsewhere, record that worktree path and
    fast-forward the base branch there with
    `git -C <base-worktree> merge --ff-only <recorded-branch>`.
20. Otherwise switch to the local base branch in the current worktree.
21. If you switched to the base branch, fast-forward it with
    `git merge --ff-only <recorded-branch>`.
22. If the local base branch has a configured upstream, push the local base
    branch to that upstream.
23. If that push is rejected because the upstream moved, fetch that upstream,
    re-synchronize the local base branch, rebase the recorded branch onto the
    refreshed base branch, fast-forward the base branch again, and retry the
    push until the local and remote refs match or the workflow hits a conflict
    that must be reported.
24. Verify that the local base branch and `<recorded-branch>` are synchronized
    by checking that `git rev-list --left-right --count <base-branch>...<recorded-branch>`
    reports `0 0` in the worktree where the base branch is now checked out.
25. If the local base branch has a configured upstream, verify that the local
    base branch and its upstream are synchronized by checking the matching
    left-right commit counts after the final push.
26. Stop and report if the base branch and `<recorded-branch>` are still
    divergent.
27. Stop and report if the local base branch and its upstream are still
    divergent when an upstream is configured.
28. Report the final commit hash, commit message, source branch, whether
    the base branch was updated in the current worktree or another worktree,
    and whether the final base-branch push was skipped or succeeded.

Do not create an empty commit.
Do not commit secrets or unrelated files.
Do not ignore task-related submodule changes; either include the intentional
submodule update or stop and report why it could not be completed safely.
Do not create a merge commit for the final base-branch update; only a
fast-forward update is allowed.
Do not treat the workflow as finished until the local base branch and the
rebased task branch are synchronized.
When the local base branch has a configured upstream, do not treat the workflow
as finished until the local and remote base-branch refs are synchronized too.
When touched submodules are part of the task, do not treat the workflow as
finished until their local and remote branches are synchronized when those
submodule branches have configured upstreams.
Do not stop after a successful commit or rebase if the local base branch has
not been updated and, when configured, pushed yet.
Do not force-check out the base branch in the current worktree when another
worktree already has that branch checked out.
If commit or rebase fails, stop and report the exact failure.
Do not use literal `\n` escape sequences in commit-message inputs.
