# OpenCode Shared Workspace

Shared OpenCode commands, rules, and skills intended to be reused across
multiple repositories via a checked-out `.opencode/` directory.

## Purpose

- keep a small reusable command set for common repository workflows
- keep durable rules that guide editing, documentation, testing, and git usage
- provide shared skills for targeted workflows such as commit-message validation
- leave project-specific behavior to local overlays instead of baking it into
  the shared core

## Layout

- `ai-scripts/` - repo-local helper scripts for repeated AI workflows
- `commands/` - shared slash-command definitions
- `rules/` - shared durable workflow and editing rules
- `skills/` - shared reusable skills
- `docs/tasks/` - local task guide and implementation specifications for accepted
  repository work
- `CONTRIBUTING.md` - repository-specific source contribution workflow
- `LICENSE` - Zero-Clause BSD license for Codegeist-owned material
- `README.md` - this source repository's contributor and maintainer guide; it is
  not copied into the generated release
- `README_release.md` - release consumer guide copied to `README.md` in the
  generated `.opencode` bundle
- `INDEX.md` - root agent navigation index for this source repository; it is not
  copied into the generated `.opencode` release submodule
- `opencode.json` - OpenCode config for loading the shared rule set
- `playwright-mcp.json` - Playwright MCP browser launch configuration copied
  into the generated `.opencode` release submodule

## Integration Model

- This repository is designed to be used as a git submodule or checked-out
  workspace directory mounted at `.opencode/` inside a consuming repository.
- The instruction paths in `opencode.json` intentionally use the
  `.opencode/...` prefix and should stay that way.
- Project-specific extensions should live beside it in a local overlay such as
  `@.oc_local/` rather than being added to the shared core.

## Submodule Usage

Consuming repositories should add the generated `release` branch as their
`.opencode` submodule. The release branch contains only the files needed at
runtime: `.gitignore`, `LICENSE`, `README.md`, `opencode.json`,
`playwright-mcp.json`, `ai-scripts/`, `commands/`, `rules/`, and `skills/`.

```bash
git submodule add -b release <repository-url> .opencode
git submodule update --init --recursive
```

To update an existing consuming repository to the latest release branch commit:

```bash
git submodule update --remote .opencode
```

After source review, maintainers build and push the release branch from this
repository with:

```bash
task release-build
```

## Contributing

Source work starts from `main` and a topic branch, never from the generated
`release` branch or a consuming repository's `.opencode/` checkout. Read the
[local contribution guide](CONTRIBUTING.md), find public work in
[Issues](https://github.com/codegeist-ai/codegeist-agent-kit/issues) and the
[Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1), and use the
[local task guide](docs/tasks/README.md) for accepted implementation
specifications. In projects that mount this kit as `.opencode`, `/task spec`
keeps the local task authoritative and creates one concise Issue only after
confirming the declared GitHub mirror and receiving explicit approval for the
exact preview; existing Issues may be reused. GitHub CLI work requires
`GH_TOKEN` in the OpenCode process environment. A verified implementation closes
its validated Issue as completed before the local task becomes `solved`.

The canonical normal check is non-publishing:

```bash
task test
```

Effective account-wide guidance is provided by the shared
[contribution policy](https://github.com/codegeist-ai/.github/blob/main/CONTRIBUTING.md),
[Code of Conduct](https://github.com/codegeist-ai/.github/blob/main/CODE_OF_CONDUCT.md),
[security policy](https://github.com/codegeist-ai/.github/blob/main/SECURITY.md),
and [support guide](https://github.com/codegeist-ai/.github/blob/main/SUPPORT.md).
Codegeist-owned material is available under the [0BSD license](LICENSE).

The visible [Codegeist account profile](https://github.com/codegeist-ai) is
sourced from [`codegeist-ai/codegeist-ai`](https://github.com/codegeist-ai/codegeist-ai).
The separate [`codegeist-ai/.github`](https://github.com/codegeist-ai/.github)
repository remains the source of shared community defaults.

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
- Skills: currently `skills/commit-message-guard/SKILL.md`
- Directory indexes: `rules/directory-index.md` defines agent-owned `INDEX.md`
  files for navigable local context in large directories. A repository-root
  `INDEX.md` lists known directory indexes and is loaded by `opencode.json`
  when present outside the `.opencode` submodule.
- Release boundary: `opencode.json` intentionally references `INDEX.md` so a
  consuming repository can own that root file. Never add `INDEX.md` to
  `RELEASE_PATHS` or create `.opencode/INDEX.md` in the generated release.

## Development Notes

- Run `task test` after source changes. It validates a temporary release copy
  without creating or publishing a release branch.
- Release publication is maintainer-only after review.
- `node_modules/` is ignored.
- `package.json` and `package-lock.json` are local-only plugin files and are
  ignored because consuming workspaces do not require pinned plugin versions.
