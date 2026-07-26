# README Release Documentation

Use this rule when creating or updating `README_release.md`.

## Purpose

- Treat `README_release.md` as the source documentation for the generated
  `.opencode/README.md` that consuming repositories receive from the `release`
  branch.
- Document the released OpenCode workspace contract for consumers, not general
  development notes for this source repository.

## What Belongs In `README_release.md`

- A concise description of what the released `.opencode` submodule provides.
- The runtime paths included in the generated `release` branch.
- How consuming repositories add and update the `.opencode` submodule.
- The expected consumer repository layout and where project-specific overlays
  belong.
- A `## Changelog` section with consumer-visible changes in the current version.
- Migration or update notes for consuming repositories and coding agents when a
  release changes setup, commands, rule loading, submodule expectations, local
  overlays, or workflow contracts.
- The upstream workflow for adding generic shared commands, rules, skills,
  scripts, config files, or release documentation to this agent kit.
- Agent startup guidance that applies inside consuming repositories.
- High-value shared commands that consumers should prefer for git, memory, task,
  submodule, and release-related workflows.
- Commit, git safety, GitHub CLI, documentation, memory, and local-rule guidance
  that consumers need immediately.
- Maintainer notes for this source repository only when they explain how the
  release branch is generated, tested, or synchronized.
- Troubleshooting entries for common release-submodule issues.

## Changelog Requirements

- Update the `## Changelog` section before running
  `.oc_local/commands/release-build.md`.
- Base the changelog on the diff between the latest `origin/release` commit and
  the current release bundle.
- Include changes that affect consumers of the generated `.opencode` submodule.
- Include update notes for other coding agents when they need to adjust
  consuming repositories to stay compatible with the current release.
- Mention changed commands, rules, skills, scripts, plugins, `opencode.json`
  instruction paths, release paths, submodule expectations, and migration steps.
- State when no consumer action is required.
- Keep entries concise and practical; avoid source-only implementation details
  that do not ship in the release bundle.

## What Does Not Belong

- Product-specific services, deployment environments, branch policies, customer
  workflows, or architecture assumptions from a consuming repository.
- Long source-repository development history that does not affect the released
  `.opencode` contract.
- Raw command output, temporary task notes, or one-off debugging details.
- Duplicate copies of rules that already live in `rules/` unless a short summary
  helps consumers find the right workflow.
- Instructions to edit generated `.opencode/` files directly as the normal
  implementation path.

## Maintenance

- Keep the file current with `Taskfile.yml` release paths and the release copy
  behavior.
- When shared commands, rules, skills, scripts, plugin files, or release
  workflows change, update `README_release.md` only if consumers need to know.
- Keep examples short, non-interactive, and safe to run.
- Keep durable documentation in English.
