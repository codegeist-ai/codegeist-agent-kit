# Semantic Versioning

Use these rules when choosing, validating, or documenting project release
versions.

## Format

- Use Semantic Versioning as `MAJOR.MINOR.PATCH`.
- Use Git release tags with a leading `v` by default, for example `v1.0.9`.
- Keep numeric version components non-negative integers without leading zeroes.
- Pre-release identifiers are allowed when the project intentionally publishes
  them, for example `v1.1.0-alpha.1` or `v2.0.0-rc.1`.
- Build metadata is valid SemVer, for example `v1.1.0+build.5`, but avoid it
  for normal release tags unless the project already uses that convention.
- Do not mix unrelated schemes such as dates, branch names, or environment names
  into SemVer release tags.

## Choosing The Next Version

- Increase `PATCH` for backwards-compatible fixes, documentation updates, test
  changes, CI or build fixes, refactors without observable behavior changes, and
  small maintenance improvements.
- Increase `MINOR` for backwards-compatible new features, new optional
  capabilities, or expanded public behavior that existing consumers can ignore.
- Increase `MAJOR` for breaking changes, removed or renamed public APIs,
  incompatible configuration changes, changed defaults that require migration, or
  removed files and entrypoints that consumers may depend on.
- When unsure, choose the smallest increment that honestly describes the
  user-visible or consumer-visible change.
- If a release contains multiple changes, choose the highest required increment.

## Determining The Version From Git

- Start from the latest SemVer release tag that belongs to the project:

```bash
git describe --tags --abbrev=0 --match 'v[0-9]*.[0-9]*.[0-9]*'
```

- Inspect commits and diffs since that tag before selecting the next version:

```bash
git log <last-tag>..HEAD --oneline
git diff <last-tag>..HEAD
```

- Treat Conventional Commits as useful hints, not a replacement for reviewing
  the actual changed behavior:
  - `fix` usually implies `PATCH`.
  - `feat` usually implies `MINOR`.
  - `BREAKING CHANGE` footers or `!` markers imply `MAJOR`.
  - `docs`, `test`, `ci`, `build`, `chore`, `style`, and `refactor` usually
    imply `PATCH` only when they are included in a release tag.
- Override the commit-message hint when the diff shows a different consumer
  impact.

## Validation

- A normal release tag should match:

```text
^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$
```

- A full SemVer tag with optional pre-release and build metadata should match
  the SemVer 2.0.0 grammar with the same leading `v` convention.
- Do not create a release tag if the same tag already exists locally or on the
  remote.
- Prefer annotated Git tags for human-facing releases.

## Project-Specific Policy

- Keep project-specific release files, branch names, artifact rules, and publish
  commands in local project docs, local rules, or repo tasks.
- This shared rule only defines version shape and version selection. It should
  remain applicable to software projects with different languages, build tools,
  packaging systems, and deployment workflows.
