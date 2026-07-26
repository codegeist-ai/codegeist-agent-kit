---
description: Add or move shared behavior into the agent kit
agent: build
---
Add reusable shared behavior to the upstream `codegeist-agent-kit` source
repository, or move a generic local overlay from `.oc_local/` into that upstream
source. Then build the generated `release` branch and update this consuming
repository's `.opencode` submodule to the new release commit.

User request:
$ARGUMENTS

Expected argument shape:

```text
command|rule|skill|config <description of the shared behavior>
move <explicit .oc_local command, rule, or skill path>
```

Follow @.opencode/rules/command-execution.md,
@.opencode/rules/commit.md,
@.opencode/rules/commit-conventions.md,
@.opencode/rules/software-documentation.md,
@.opencode/rules/software-tests.md, and
@.opencode/rules/language-policy.md.

Before changing anything:

1. Review the consuming repository state with `git --no-pager status --short
   --branch`.
2. Verify that `.opencode` exists and is a Git checkout.
3. Verify that `.gitmodules` configures `.opencode` with `branch = release`.
4. Stop and report if `.opencode` is missing, is not a Git checkout, or has no
   configured branch.
5. Confirm from the user request whether the target is `command`, `rule`,
   `skill`, `config`, or `move`; if the type is missing or ambiguous, ask one
   short clarification question before proceeding.
6. Only continue with an upstream agent-kit change when the requested behavior
   is generic across repositories with unrelated domains, products,
   architectures, and deployment models. Shared additions must not encode
   product-specific services, customer workflows, environment names, domain
   assumptions, branch policies, or repository layouts beyond the shared
   OpenCode workspace contract.
7. If the behavior is specific to the current consuming repository, stop the
   upstream workflow and create or propose a local overlay such as
   `.oc_local/commands/`, `.oc_local/rules/`, or `.oc_local/skills/` instead.
8. If generic applicability is unclear, ask one short clarification question
   before editing the source checkout.

For `move` requests:

1. Require the user to name each selected overlay explicitly. Accept only
   concrete files under `.oc_local/commands/` or `.oc_local/rules/`, or concrete
   skill directories under `.oc_local/skills/<name>/`. Do not move an entire
   `.oc_local/` directory, do not bulk-move every command, rule, or skill, and
   do not infer additional files that the user did not select.
2. Locate each selected overlay. Stop and report if any requested overlay is
   missing or is outside `.oc_local/commands/`, `.oc_local/rules/`, or
   `.oc_local/skills/`.
3. Read every selected overlay and its nearby documentation before deciding to
   move it.
4. Continue only for selected overlays that are generic enough for repositories with
   unrelated domains, products, architectures, and deployment models. If it
   contains project-specific assumptions, leave that selected overlay in
   `.oc_local/` and report why it should remain local.
5. Preserve the intent of each accepted overlay while rewriting project-specific
   paths, names, examples, and assumptions into shared, repo-agnostic language
   before adding it to the upstream agent kit.
6. Do not delete any selected local `.oc_local/` source until the upstream
   source change is committed, the release branch has been built, `.opencode`
   has been updated to the new release, and the replacement shared file is
   verified in the updated submodule. Leave unselected `.oc_local/` files
   untouched.

Then perform the upstream source workflow autonomously:

1. Clone `https://github.com/codegeist-ai/codegeist-agent-kit.git` into an
   explicit user-owned temporary directory outside the consuming repository,
   unless the user or local workflow provides a trusted source checkout. Prefer
   a unique directory created with `mktemp -d "${TMPDIR:-/tmp}/opencode-agent-kit.XXXXXX"`;
   do not rely on a fixed `/tmp/opencode` path because shared environments may
   create it as root-owned and unwritable to the workspace user.
2. In the temporary source checkout, implement the smallest correct shared
   change in the source paths: `commands/`, `rules/`, `skills/`, `ai-scripts/`,
   `opencode.json`, `playwright-mcp.json`, and `README_release.md` as applicable.
   For `move`, copy and generalize the local
   overlay content into the matching source path instead of keeping
   consumer-specific assumptions.
3. Keep all durable repository text, command text, rule text, comments, commit
   messages, and user-facing help in English.
4. Update `commands/README.md`, `rules/README.md`, `README_release.md`, or other
   nearby documentation when the new shared behavior should be discoverable in
   future sessions.
5. Run `task test` in the source checkout and fix any failures before
   continuing.
6. Review the source checkout diff and create a focused Conventional Commit for
   the source change. Do not commit secrets, unrelated files, generated noise,
   or temporary clone paths.
7. Push the source branch when the remote is configured and the authenticated
   session has permission. If authentication is required for GitHub, verify it
   with `gh auth status` and use the `gh-auth` skill when needed.
8. Run `task release-build` in the source checkout so a normal commit is added
   to the generated `release` branch and pushed. The release branch history must
   stay reviewable; do not force-recreate it when the remote branch already
   exists.

After the release branch has been updated, return to the consuming repository
and update only `.opencode`:

1. Determine the configured branch for `.opencode` from `.gitmodules`.
2. Determine the configured upstream remote for that local branch inside
   `.opencode` when present; otherwise use `origin`.
3. Fetch the configured branch from that remote.
4. Run `git checkout -B <branch> <remote>/<branch>` inside `.opencode` so
   force-updated release branches are handled cleanly.
5. Verify that `.opencode` `HEAD` matches `<remote>/<branch>`.
6. Verify that `git status --short` inside `.opencode` is clean.
7. Run `git submodule status -- .opencode` in the consuming repository.
8. For `move`, remove only the selected original `.oc_local/` overlays after
   verifying that the updated `.opencode` release contains each replacement
   shared command, rule, or skill. Leave all unselected local overlays in place.
9. Report the `.opencode` path, branch, commit, upstream ref, moved local
   overlay path when relevant, and whether the
   parent repository now has a gitlink change that needs to be committed.

Do not update `.devcontainer` or any other submodule from this command unless
the user explicitly asks for that separate update. Do not delete local files
inside submodules. Do not commit or push the consuming repository's parent
gitlink update or `.oc_local/` removal unless the user explicitly asks for a
save or commit workflow.
