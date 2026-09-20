# Command Execution Rule

Use these rules whenever you choose or run commands in this project.

## Git Write Authorization

- In a non-disposable repository, never create a Git commit unless the current
  user request explicitly asks to create or record a commit, or explicitly
  invokes `/commit`, `/git-commit`, or `/save`.
- Direct invocation of `/commit`, `/git-commit`, or `/save` is the authorization;
  do not ask for a second commit confirmation. In particular, `/save` authorizes
  its documented commit, submodule synchronization, rebase, and push workflow.
- A repository command whose documented primary purpose necessarily creates and
  publishes commits may declare direct invocation as authorization for those
  enumerated side effects. Do not ask for a second confirmation when that
  command makes the authorization boundary explicit.
- Commit authorization is limited to the current request and applies equally to
  parent and submodule commits. Do not infer it from an earlier request, broad
  implementation autonomy, task completion, a dirty worktree, or a workflow that
  happens to contain a commit step.
- A plain chat request qualifies only when it unambiguously asks to create a Git
  commit. Requests merely to save files, persist edits, record task state, push,
  or synchronize do not satisfy the gate.
- Implementing, fixing, testing, documenting, finishing a task, updating a
  submodule, rebasing, synchronizing, or requesting a push does not authorize a
  commit.
- Do not select, invoke, or delegate to a commit-producing command on the user's
  behalf without the same explicit authorization. When an otherwise requested
  workflow requires a commit, stop before its first commit and ask one focused
  confirmation question that identifies the commits and pushes it would perform.
- The disposable test-repository exception in `tools.md` remains available for
  isolated fixtures created during the current task.

## Preference Order

- Prefer repo-local workflow commands: `@.opencode/commands/learn.md`,
  `@.opencode/commands/rebase.md`, and `@.opencode/commands/git-sync.md` when the
  user requests the behavior they own.
- When a repo-local skill already defines a specialized workflow, prefer
  invoking that skill from commands instead of duplicating its step-by-step
  procedure in the command file.
- Before any GitHub CLI command, require a non-empty `GH_TOKEN` environment
  variable, force `GH_HOST=github.com`, and set `GH_PROMPT_DISABLED=1`. Validate
  the token non-interactively with a read-only `gh api user` request before
  performing GitHub work.
- Use `GH_TOKEN` as the only supported GitHub token environment variable. Never
  print, inspect, persist, or ask the user to paste its value. Do not use stored
  GitHub CLI credentials, `gh auth login`, `gh auth status`, or browser
  authentication. Stop with a concise error when `GH_TOKEN` is missing or
  invalid.
- When `/task` uses `tea api` to inspect source-repository push mirrors, remove
  `GH_TOKEN` from the Tea process environment, keep the call non-interactive,
  and use only an already configured Tea login. Never invoke `tea login add` or
  expose the raw push-mirror response. Missing Tea capability, login, or access
  leaves mirror tracking blocked until the repository declares `GitHub Mirror:
  <URL|none>`.
- Prefer non-interactive command forms whenever a tool might prompt or open a
  pager.
- For an explicitly authorized commit task, use the repo-local `/commit` workflow
  by default. Use `/save` only when the current request invokes it or explicitly
  asks for its full commit, rebase, and push workflow.
- Prefer `/add-agent-kit` when a consuming repository needs a generic shared
  command, rule, or skill added upstream to this agent kit, or when explicitly
  selected generic `.oc_local/` overlays should move into the shared kit.
- Do not use `/add-agent-kit` for product-specific behavior; keep that in the
  consuming repository's `.oc_local/` overlays instead.
- When the current user explicitly requests a commit outside `/commit` or
  `/save`, follow the `/commit` workflow instead of adding `/save` side effects or
  refusing only because the request came from normal chat.
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
- When using `@.opencode/commands/save.md`, include any relevant rule updates
  from the learn step in the same commit. If the save workflow refreshes
  `.opencode` or `.devcontainer`, include the resulting parent gitlink updates in
  that same commit as task state. When a local base branch is resolved, refresh
  that local base branch from its configured upstream before it is used as a
  rebase base.
  When the current branch is the local base branch, continue through the
  base-branch rebase and normal non-force push when that base branch has an
  upstream. When the current branch is not the local base branch, refresh the
  local base branch from upstream, rebase the current branch over remote
  current-branch changes when needed, then rebase the current branch onto the
  refreshed local base branch and push only the current branch. In that
  feature-branch path, do not merge, fast-forward, or push the local base branch
  to the current branch. When the task touches submodules, finish the same local
  and remote branch synchronization there before recording the parent gitlink
  whenever those submodule branches have configured upstreams.
- In the feature-branch `@.opencode/commands/save.md` path, `git push
  --force-with-lease` is allowed only for the current non-base branch, only
  after fetching that branch's upstream, and only when a rebase rewrote commits
  already present on that upstream. Never force-push the local base branch.
- After a successful commit, rebase, push, or branch-sync step, report routine
  completion metadata in the response.
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
