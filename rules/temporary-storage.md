# Temporary Workspace Storage

Use this rule whenever creating disposable files, directories, fixtures, caches,
downloads, generated probes, or secret-bearing test data.

## Disposable Data

- Do not create new temporary directories or artifacts directly in a repository
  workspace. Use the workspace `.tmp/` path when it exists; devcontainer-kit
  workspaces expose it as a symlink to `/tmp/ws-data`.
- When `.tmp/` is unavailable, use an operating-system temporary directory
  outside the repository instead of inventing another workspace-local temp path.
- Treat everything under `.tmp/` as disposable. Do not rely on it for durable
  handoff state, committed inputs, or data that must survive environment cleanup.
- Do not migrate, delete, or rewrite existing repository-owned temporary paths
  merely to apply this convention; change them only when the current task
  explicitly includes that behavior.

## Persistent Secrets

- Store persistent secrets that are not disposable test fixtures under the
  ignored `.codegeist/secrets/` directory. Never place durable credentials,
  private keys, tokens, or other required secret state under `.tmp/`.
- Temporary secrets created only for isolated tests may live under `.tmp/` and
  must be removed with the rest of the test fixture.
- Never move, print, inspect, or delete existing secret files unless the user
  explicitly requests that operation and the repository workflow permits it.
