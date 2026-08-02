# Contributing To Codegeist Agent Kit

This repository owns the generic OpenCode rules, commands, skills, helper
scripts, plugins, and configuration shared by otherwise unrelated consuming
repositories.

## Shared Policies

The account-wide Codegeist policies apply alongside this repository-specific
guide:

- [Contribution policy](https://github.com/codegeist-ai/.github/blob/main/CONTRIBUTING.md)
- [GitHub account and repository model](https://github.com/codegeist-ai/.github/blob/main/GITHUB_ACCOUNT_MODEL.md)
- [Code of Conduct](https://github.com/codegeist-ai/.github/blob/main/CODE_OF_CONDUCT.md)
- [Security policy](https://github.com/codegeist-ai/.github/blob/main/SECURITY.md)
- [Support guide](https://github.com/codegeist-ai/.github/blob/main/SUPPORT.md)

Do not report vulnerabilities or sensitive information in a public issue.

## Choose The Owning Repository

Changes belong here only when they are useful across repositories with
unrelated products, architectures, and deployment models. Project-specific
paths, workflows, deployment behavior, and product conventions belong in the
consuming repository's `.oc_local/` commands, rules, or skills.

Open an issue before starting when ownership or generic applicability is
unclear.

## Source Workflow

1. Find or open a repository [Issue](https://github.com/codegeist-ai/codegeist-agent-kit/issues) and check the [Codegeist roadmap](https://github.com/users/codegeist-ai/projects/1).
2. An Issue labeled `status:ready` must link its canonical specification under
   [`docs/tasks/`](docs/tasks/README.md). For a small unplanned fix, a maintainer may
   confirm that no new task is needed; state the reason in the pull request. Always
   use an existing task when one defines the work.
3. Create a topic branch from the source `main` branch.
4. Edit the source paths at the repository root. The generated `release` branch and consuming `.opencode/` checkouts are distribution outputs, not implementation targets.
5. Run the normal repository check:

```bash
task test
```

6. Open a pull request that links the Issue and applicable local task, summarizes
   the source and release impact, and reports verification. If no new task was
   required, state `No local task needed:` and the maintainer-approved reason.

`task test` copies and validates the release bundle without creating commits,
publishing a release, or updating submodules. Release publication through
`task release-build` is maintainer-only and happens after source review.

## License

Codegeist-owned material and submitted contributions are accepted under the
[Zero-Clause BSD License](LICENSE), SPDX identifier `0BSD`, without a separate
CLA or DCO requirement. Preserve third-party licenses and notices.
