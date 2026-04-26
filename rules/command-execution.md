# Command Execution Rule

Use these rules whenever you choose or run commands in this project.

## Preference Order

- Prefer repo-local memory and workflow commands:
  `@.opencode/commands/update-chat.md`, `@.opencode/commands/learn.md`,
  `@.opencode/commands/save.md`, `@.opencode/commands/rebase.md`, and
  `@.opencode/commands/git-sync.md`.
- When a repo-local skill already defines a specialized workflow, prefer
  invoking that skill from commands instead of duplicating its step-by-step
  procedure in the command file.
- When a task needs GitHub CLI access, check `gh auth status` first. If the
  current session is not authenticated, use
  `@.opencode/skills/gh-auth/SKILL.md` before continuing with `gh` commands.
- Prefer non-interactive command forms whenever a tool might prompt or open a
  pager.
- Prefer the repo-local `/commit` or `/save` workflow for commit-style tasks
  because those commands already bundle project-memory, learn, rebase, and
  branch-sync steps.
- A plain chat request to commit, save, or record changes is also sufficient in
  this repo when the user is explicitly asking for that git write workflow.
- When commit-like work is requested outside `/commit` or `/save`, still follow
  the same project commit, memory, learn, rebase, and branch-sync rules instead
  of refusing only because the request came from normal chat.
- Apply the same allowance and the same safety checks to submodule commits,
  parent gitlink updates, and any other git steps whose purpose is to create or
  record a commit.
- For git read commands, prefer `git --no-pager ...`.
- Prefer read-only inspection, documentation, and repo-local workflow commands
  over speculative implementation commands.
- For save-style returns to the local base branch in a linked-worktree repo,
  update that base branch in the worktree that already has it checked out
  instead of switching the current worktree away from its branch.
- When a repo-local rebase workflow resolves the current branch as the same as
  the local base branch, treat that rebase step as a valid no-op instead of a
  failure.
- When a repo-local rebase or branch-sync workflow cannot resolve a base branch
  only because the repository has no remote default branch yet, or is a purely
  local `git init` repository, treat that step as a valid no-op instead of a
  failure.
- When using `@.opencode/commands/save.md`, include the refreshed
  `docs/memory-bank/chat.md` and
  any relevant rule updates from the learn step in the same commit, then let it
  continue through the branch rebase, the final fast-forward update of the
  local base branch, and when that base branch has an upstream, the final
  synchronization and push of the local and remote base-branch refs. When the
  task touches submodules, finish the same local and remote branch
  synchronization there before recording the parent gitlink whenever those
  submodule branches have configured upstreams.
- Prefer `@.opencode/commands/git-sync.md` when you want to synchronize the
  current branch and the local base branch without creating a commit.
- Never use `git reset` or `git revert` unless the user explicitly asks for
  that exact action.
- Keep throwaway worktrees or probes in explicit temporary paths instead of the
  repo root unless the task is specifically about repo-managed worktrees.

## Verification Style

- Prefer short, direct checks that match the current lightweight workflow.
- Prefer read-only inspections when they answer the question.
- Re-run the affected git or submodule command after changing git or submodule
  behavior.
- Avoid broad environment dumps unless the task truly requires them.
