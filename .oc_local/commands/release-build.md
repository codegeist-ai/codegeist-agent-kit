---
description: Build release branch and save updated submodules
agent: build
---
Review the current repository state and `Taskfile.yml`.

Then:

1. Run `task release-build` from the repository root.
2. Stop and report the exact failure if the release build fails.
3. Execute @.opencode/commands/update-submodules.md so `.opencode` and
   `.devcontainer` are refreshed to their configured branches after the release
   branch push.
4. Execute @.opencode/commands/save.md with release-build context so any updated
   parent gitlinks, docs, memory, or workflow changes are committed, rebased,
   synchronized with the local base branch, and pushed when configured.
5. Report the release branch commit, any parent repository commit created by
   `save`, and final synchronization status.

Do not skip @.opencode/commands/update-submodules.md even though
@.opencode/commands/save.md also refreshes submodules before committing.
Do not commit or push manually from this command; let `task release-build`,
@.opencode/commands/update-submodules.md, and @.opencode/commands/save.md own
their respective steps.
