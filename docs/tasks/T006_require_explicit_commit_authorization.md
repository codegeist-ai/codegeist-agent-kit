# Require Explicit Commit Authorization

- **ID:** T006
- **Type:** fix
- **Parent:** none
- **Status:** solved
- **Public Tracking:** https://github.com/codegeist-ai/codegeist-agent-kit/issues/13
- **Tracking Key:** 09b0c503-d6e5-478b-8507-bb996784da39

## Goal

Prevent OpenCode workflows from creating commits in non-disposable repositories
unless the current user request explicitly authorizes a commit.

## Context

The shared rules mention explicit commit requests but do not make them a hard
precondition. Normal task completion can select `/save`, the release README is
loaded as a global instruction despite containing autonomous publication steps,
and several compound commands create commits as an implicit side effect.

## Scope

- Define one authoritative commit-authorization gate for non-disposable
  repositories.
- Prevent task completion, submodule updates, push requests, dirty worktrees,
  and general implementation work from implying commit authorization.
- Stop loading the human-facing release README as a global OpenCode instruction.
- Remove implicit commits from backlog capture and require explicit approval
  before compound upstream or release workflows enter commit-producing steps.
- Align command summaries, release documentation, and smoke tests with the new
  contract.
- Consolidate overlapping commit guidance so authorization, commit contents, and
  workflow side effects each have one canonical source.

## Acceptance Criteria

- A commit in a non-disposable repository is allowed only when the current user
  request invokes `/commit`, `/git-commit`, or `/save`, or explicitly asks to
  create or record a commit.
- Implementing, fixing, testing, documenting, finishing a task, updating a
  submodule, requesting a push, or observing a dirty worktree does not authorize
  a commit.
- Agents must not select or delegate to commit-producing workflows without the
  same explicit authorization.
- Direct `/save` invocation is sufficient authorization for its documented
  workflow and must not trigger another commit confirmation.
- Direct invocation of the repository-local `/release-build` workflow authorizes
  its documented release and parent `/save` writes without another confirmation.
- `/task backlog` records an idea without committing or pushing it.
- `/add-agent-kit` and the local `/release-build` workflow stop for explicit
  commit authorization before their first commit-producing step.
- `.opencode/README.md` is no longer loaded as a global instruction.
- Commit-format rules state that they govern only an already-authorized commit.
- Release smoke tests enforce the authorization guard and configuration boundary.
- A plain commit request selects `/commit`; `/save` remains limited to an
  explicitly requested commit, rebase, and push workflow.
- `/commit` stages only the intended coherent change set and does not push or
  synchronize submodule branches without a separate request.
- `commit.md` is the sole active commit-format contract, and navigation-only rule
  inventories are not loaded as global instructions.
- The source-local release workflow performs no duplicate submodule refresh.

## Files

- `rules/command-execution.md`
- `rules/commit.md`
- `rules/commit-conventions.md` (removed)
- `rules/tools.md`
- `rules/devcontainer-tools.md`
- `rules/task-workflow.md`
- `rules/README.md`
- `commands/commit.md`
- `commands/save.md`
- `commands/task.md`
- `commands/add-agent-kit.md`
- `commands/README.md`
- `.oc_local/commands/release-build.md`
- `.oc_local/rules/gitea-git.md`
- `.oc_local/rules/readme-release.md`
- `opencode.json`
- `README.md`
- `README_release.md`
- `docs/tasks/README.md`
- `CONTRIBUTING.md`
- `INDEX.md`
- `tests/release-copy.sh`

## Non-Goals

- Preventing commits inside disposable repositories created for tests.
- Introducing a new commit message format beyond the existing Conventional
  Commit contract.
- Changing `/save` branch synchronization after its full workflow is explicitly
  authorized.
- Publishing a new release as part of this implementation.

## Implementation Hints

- Keep authorization separate from tool availability: read-only Git inspection
  remains autonomous.
- Treat source files as authoritative and do not edit the generated `.opencode`
  release checkout directly.
- Make command side effects explicit rather than relying on users to infer them
  from implementation details.

## Verification

```bash
git --no-pager diff --check
task test
```

Both commands pass. The release smoke test verifies the focused instruction
list, explicit commit gate, non-committing backlog behavior, and compound command
authorization prompts without creating commits or publishing a release. It also
checks the complete instruction list, local-only `/commit` boundary, recursive
task hierarchy invariants, and single shared-submodule refresh path.

## Implementation Notes

- Commit authorization is scoped to the current user request and cannot be
  inferred from implementation work, task completion, a dirty worktree, or a
  request for another Git action.
- `/commit`, `/git-commit`, and `/save` remain explicit commit entrypoints. Plain
  chat authorization must unambiguously request creation of a Git commit.
- `/task backlog` now leaves one focused local edit for later review instead of
  committing and pushing it automatically.
- `/add-agent-kit` and the source-local `/release-build` workflow may prepare and
  verify changes, but stop before their first commit-producing step unless the
  current request names the full commit and publication side effects.
- The generated release README remains available as reference documentation but
  is no longer loaded through `opencode.json` as a global instruction.
- `command-execution.md` now owns commit authorization, while `commit.md` owns
  message and content requirements; the redundant `commit-conventions.md` rule
  and navigation-only rule index are no longer loaded globally.
- A plain commit request uses local-only `/commit`, which stages the intended
  coherent change set and leaves unrelated files and unrequested synchronization
  untouched. `/save` retains its separately authorized full workflow.
- Direct `/save` invocation is itself authorization for all documented side
  effects, so the command proceeds without a redundant commit confirmation.
- Direct `/release-build` invocation likewise authorizes the generated release
  commit and push plus the subsequent full `/save` workflow without another
  confirmation.
- `task-workflow.md` now keeps only always-on invariants and delegates detailed
  task execution to `/task`; the source-local release workflow delegates one
  shared-submodule refresh to `/save` instead of invoking it twice.
- GitHub Issue #13 was revalidated as the sole canonical match and remains closed
  with reason `completed` before this task returned to `solved`.

## Dependencies

- None.

## Open Questions

None.
