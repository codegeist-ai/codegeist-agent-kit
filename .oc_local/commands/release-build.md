---
description: Build release branch and save updated submodules
agent: build
---
Review the current repository state and `Taskfile.yml`.

Invoking `/release-build` is itself explicit authorization for the generated
release commit and push plus the full parent repository commit, shared-submodule
refresh, rebase, and push workflow performed by `/save`. Do not ask for a
separate confirmation after invocation.

Then:

1. Compare the latest release branch commit with the current release bundle:
   - Review `git diff --stat origin/release -- README_release.md opencode.json playwright-mcp.json ai-scripts commands rules skills plugin`.
   - Review `git diff origin/release -- README_release.md opencode.json playwright-mcp.json ai-scripts commands rules skills plugin`.
   - Include mapped `README_release.md` to `README.md` changes when drafting the changelog.
2. Update `README_release.md` `## Changelog` with consumer-visible changes and
   migration or update notes for consuming repositories and coding agents.
3. Run `task release-build` from the repository root.
4. Stop and report the exact failure if the release build fails.
5. Execute @.opencode/commands/save.md with release-build context so shared
   submodules are refreshed once and any updated
   parent gitlinks, docs, or workflow changes are committed, rebased,
   synchronized with the local base branch, and pushed when configured.
6. Report the release branch commit, any parent repository commit created by
   `save`, and final synchronization status.

Do not run `task release-build` before reviewing the release diff and updating
`README_release.md` `## Changelog`.
Do not commit or push manually from this command; let `task release-build` and
@.opencode/commands/save.md own their respective steps.
