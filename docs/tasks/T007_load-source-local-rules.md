# Load Local And Shared Rules With Globs

- **ID:** T007
- **Type:** fix
- **Parent:** none
- **Status:** solved
- **Public Tracking:** not requested
- **Tracking Key:** 35f682ac-8c97-4fe4-a299-babfcc08b3f9

## Goal

Load local and shared Markdown rules through explicit instruction globs in new
OpenCode sessions.

## Context

The devcontainer sets `OPENCODE_CONFIG_DIR` to the repository's `.oc_local/`,
but that directory has no `opencode.json`. Markdown files in `rules/` are not
automatically loaded as instructions. Its generated ignore file also hides a
new local configuration from Git. The user selected a source-repository-only
fix for local rule loading, then requested a glob for the shared rules as well.
The follow-up is consolidated here; the unused task ID T008 remains reserved
and must not be recycled.

## Scope

- Add `.oc_local/opencode.json` with `.oc_local/rules/*.md` instructions.
- Make the local configuration and its ignore exceptions versionable.
- Document the config directory, rule loading, and restart requirement.
- Replace individual shared-rule entries with `.opencode/rules/*.md`, keeping
  `INDEX.md` as a separate instruction.
- Update the release config assertion and shared rule-loading documentation.
- Keep new local rules, commands, and skills visible to Git while ignoring
  generated dependency files.
- Extend the explicit read denial and watcher exclusion to
  `.codegeist/secrets.env`, matching the updated devcontainer contract.

## Acceptance Criteria

- A fresh OpenCode process configured with this repository's `.oc_local/`
  loads the contents of all three local rule files alongside the shared rules.
- Git discovers the new configuration and its ignore file normally.
- Source documentation explains local rule loading and its ownership boundary;
  the generated release still excludes `.oc_local/`.
- Source and generated release instructions are exactly `INDEX.md` followed by
  `.opencode/rules/*.md`, including every Markdown file directly under `rules/`.
- `task test` and `git --no-pager diff --check` pass.
- `.codegeist/secrets.env` has an explicit read denial and watcher exclusion.
- New local overlay files are not ignored; dependency artifacts remain ignored.

## Files

- `.oc_local/opencode.json`
- `.oc_local/.gitignore`
- `.oc_local/rules/project-release-source.md`
- `README.md`
- `INDEX.md`
- `opencode.json`
- `README_release.md`
- `tests/release-copy.sh`

## Non-Goals

- Editing the generated `.opencode/` checkout or changing the devcontainer kit.
- Publishing, creating commits, or updating submodules.

## Implementation Hints

- Keep instruction paths project-relative, including the `.oc_local/` prefix.
- `OPENCODE_CONFIG_DIR` must point to `<repository-root>/.oc_local`; the
  devcontainer already supplies it. Restart OpenCode after configuration changes.

## Verification

```bash
OPENCODE_CONFIG_DIR="$PWD/.oc_local" opencode debug config \
  | jq -e '(.instructions | index(".oc_local/rules/*.md")) and (.instructions | index(".opencode/rules/*.md"))'
git ls-files --others --exclude-standard -- .oc_local/opencode.json .oc_local/.gitignore
task test
git --no-pager diff --check
```

Results:

- Before the shared-glob follow-up, OpenCode 1.19.4 accepted the local
  configuration and resolved 19 instruction entries, including the local glob,
  shared rules, and root index.
- A fresh OpenCode process using the real repository configuration, isolated
  user/session directories, and a loopback-only model stub verified the complete
  contents of `gitea-git.md`, `project-release-source.md`, and `readme-release.md`
  in its system prompt, together with shared `command-execution.md` and `INDEX.md`.
  The stub intentionally returned HTTP 400 after inspection, so OpenCode exited
  with code 1 while the probe passed. No external model was invoked.
- Git discovers the new config and ignore file normally; generated local
  package files and `node_modules/` remain ignored.
- `task test` passed, including the release exclusion of `.oc_local/`.
- After the shared-glob follow-up, source instructions were verified as exactly
  `INDEX.md` and `.opencode/rules/*.md`. OpenCode accepted the shared glob and
  preserved the local glob; `task test` passed with the updated release assertion.
  The shared glob additionally includes `bash-scripts.md`, `semver.md`, and
  `rules/README.md`, previously absent from the explicit instruction list.
- `git --no-pager diff --check` passed.
- Follow-up configuration audit: `task test` passed with assertions for the
  `.codegeist/secrets.env` read denial and watcher exclusion. Git ignore checks
  confirmed new local rules, commands, and skills are visible and generated
  dependencies remain ignored.
- Release `ba6baee5016b8d11ff2ed23ff0d641ca1c83eb79` was published through the
  authorized release workflow and received through the GitHub mirror. Both shared
  submodules were refreshed to their configured release upstreams.
- After the release update, the effective instructions are exactly `INDEX.md`,
  `.opencode/rules/*.md`, and `.oc_local/rules/*.md`; the secret watcher exclusion
  and read entry are present. `debug config` redacts the read entry's value.

## Dependencies

- OpenCode and the existing `task test` dependencies.

## Open Questions

None.
