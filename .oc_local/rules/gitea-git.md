# Internal Gitea Git Access

Use this source-repository-only rule for Git operations whose configured remote
is hosted at `git.codegeist.ai`.

## Contract

- Tea provides the Gitea login and Git credential helper; Git still performs
  `fetch`, `pull`, and `push`. Tea has no general replacement for `git pull`.
- Treat TLS trust and authentication as separate gates. A TLS bypass does not
  provide credentials, and a valid Tea token does not make Git trust the
  internal certificate chain.
- Use the exported `GITEA_TOKEN` only through process environment variables.
  Never print, inspect, persist manually, place in a remote URL, or ask the user
  to paste it into chat.
- Keep Tea's repository-specific login state under the ignored
  `.codegeist/secrets/tea-xdg/` directory so it survives normal workspace
  sessions without becoming repository content.
- Remove `GH_TOKEN` from every Tea process so a GitHub token is never offered to
  the internal Gitea host.
- Keep the TLS exception and credential-helper override local to this repository.
  Never disable SSL verification globally.
- Preserve dirty worktree and staged state. Do not stash, reset, clean, or modify
  unrelated files merely to pull remote changes.

## Tea Login

1. Resolve the repository root and Tea configuration location, verify that a
   representative file is ignored, then create the parent directory:

   ```bash
   repo_root=$(git rev-parse --show-toplevel)
   tea_config_home="${repo_root}/.codegeist/secrets/tea-xdg"
   git -C "${repo_root}" check-ignore -q --no-index \
     .codegeist/secrets/tea-xdg/tea/config.yml
   mkdir -p "${tea_config_home}"
   ```

   Stop before writing credentials when the ignore check fails.
2. Confirm privately that the selected root remote resolves to
   `git.codegeist.ai`. Do not print a raw URL that may contain credentials.
3. Require a non-empty token without displaying it:

   ```bash
   test -n "${GITEA_TOKEN:-}"
   ```

4. Inspect the repository-scoped login list with
   `env -u GH_TOKEN XDG_CONFIG_HOME="${tea_config_home}" tea login list`. When no
   matching `codegeist` login exists, create it non-interactively from the
   environment:

   ```bash
   env -u GH_TOKEN \
     XDG_CONFIG_HOME="${tea_config_home}" \
     GITEA_SERVER_TOKEN="${GITEA_TOKEN}" \
     tea login add \
       --name codegeist \
       --url https://git.codegeist.ai \
       --insecure
   ```

5. Validate the selected login without exposing its token:

   ```bash
   env -u GH_TOKEN XDG_CONFIG_HOME="${tea_config_home}" tea whoami
   ```

6. If a matching login exists but validation fails, report that the configured
   Gitea credential is invalid. Do not delete or replace the login, start an
   interactive login, or retry with another secret unless the user explicitly
   requests credential repair.

Tea stores the added token only in its managed configuration below the ignored
secret path. Never duplicate that token in tracked files or Git configuration.

## Repository-Local Git Setup

The internal host currently requires an explicitly approved TLS exception. Set
the exception for that host and repository only, then reset inherited credential
helpers before adding Tea. The empty helper entry prevents an earlier VS Code or
host helper from returning unrelated credentials before Tea runs.

```bash
git config --local http.https://git.codegeist.ai.sslVerify false
git config --local credential.helper ''
git config --local --add credential.helper \
  '!f() { root=$(git rev-parse --show-toplevel) || exit 1; env -u GH_TOKEN XDG_CONFIG_HOME="$root/.codegeist/secrets/tea-xdg" tea login helper "$@"; }; f'
```

Verify only non-secret configuration:

```bash
git config --local --get http.https://git.codegeist.ai.sslVerify
git config --local --get-all credential.helper
```

Do not use a global `http.sslVerify=false`, `GIT_SSL_NO_VERIFY`, a token-bearing
remote URL, or a command-line token literal.

## Pull And Push

Before network Git operations, inspect the current branch, upstream, staged
changes, unstaged changes, and submodule state. Keep those existing changes
intact.

- Use `git fetch <remote>` for a read-only refresh.
- Use `git pull --ff-only` when the current branch should only fast-forward to
  its upstream. If it has diverged, stop and follow the repository's documented
  rebase workflow instead of creating an implicit merge.
- Use the normal repository `/save` rules for feature-branch rebases and pushes.
- Use a normal non-force `git push` unless the active branch workflow explicitly
  permits `--force-with-lease` for a rebased non-base branch.
- After the operation, run `git --no-pager status --short --branch` and report
  the branch synchronization result without treating pre-existing dirty files as
  changes made by the network operation.

Typical base-branch pull:

```bash
git --no-pager status --short --branch
git pull --ff-only
git --no-pager status --short --branch
```

## Failure Diagnosis

- `server certificate verification failed` means the host-scoped local
  `sslVerify` exception is missing or not matching the remote URL.
- `could not read Username`, `Unauthorized`, or `Failed to authenticate user`
  means Git did not receive a valid Tea credential. Recheck `tea login list`,
  `tea whoami`, and the local helper order without exposing token output.
- If a fresh container or session has no Tea login, repeat the non-interactive
  login setup from `GITEA_TOKEN`; do not fall back to interactive prompts.
- If Git reports that local changes would be overwritten, stop and report those
  paths. Do not discard or hide the changes.
- A public GitHub mirror can confirm source availability, but it does not repair
  internal Gitea authentication and must not silently replace the configured
  `origin` for pull or push.
