# OpenCode Shared Workspace

Shared OpenCode commands, rules, and skills intended to be reused across
multiple repositories via a checked-out `.opencode/` directory.

## Purpose

- keep a small reusable command set for common repository workflows
- keep durable rules that guide editing, documentation, testing, and git usage
- provide shared skills for targeted workflows such as GitHub CLI
- leave project-specific behavior to local overlays instead of baking it into
  the shared core

## Layout

- `commands/` - shared slash-command definitions
- `rules/` - shared durable workflow and editing rules
- `skills/` - shared reusable skills
- `opencode.json` - OpenCode config for loading the shared rule set

## Integration Model

- This repository is designed to be used as a git submodule or checked-out
  workspace directory mounted at `.opencode/` inside a consuming repository.
- The instruction paths in `opencode.json` intentionally use the
  `.opencode/...` prefix and should stay that way.
- Project-specific extensions should live beside it in a local overlay such as
  `@.oc_local/` rather than being added to the shared core.

## Shared Vs Local

Keep this repository repo-agnostic.

Project-specific workflows, paths, deployment steps, product conventions, and
analysis flows should live in local overlays such as:

- `@.oc_local/commands/*.md`
- `@.oc_local/rules/*.md`
- `@.oc_local/skills/*/SKILL.md`

## Current Shared Surface

- Commands: see `commands/README.md`
- Rules: see `rules/README.md`
- Skills: currently `skills/gh-auth/SKILL.md`

## Development Notes

- `node_modules/` is ignored.
- `package.json` and `package-lock.json` are part of the repo because they pin
  the plugin dependency used by this workspace.
