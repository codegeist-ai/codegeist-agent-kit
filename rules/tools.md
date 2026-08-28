# Bash Tool Access

Use this rule when deciding which Bash, shell, system, or installed CLI tools a
coding agent may run.

## Priority

- Prefer built-in and internal OpenCode tools when they solve the task directly,
  especially for precise file reads, file searches, structured edits, todos, and
  user questions.
- Prefer existing repository entrypoints, scripts, Taskfile tasks, and shared
  OpenCode commands over ad-hoc shell logic when they already cover the workflow.
- Use Bash and installed command-line tools freely when they are clearer, more
  direct, or necessary for the task.

## Bash Command Access

- Coding agents may use every command available through Bash and the current
  environment. Do not maintain or infer a narrow command allowlist.
- Do not ask only because a command is system-level, unfamiliar, network-capable,
  or not listed in another rule.
- Shell built-ins, pipes, redirects, shell scripts, Python snippets, Python
  scripts, Git, Docker, package managers, test runners, build tools, and any
  installed CLI tools are allowed.
- Network and remote-access tools such as `ssh`, OpenSSH utilities, `scp`,
  `sftp`, and `rsync` are allowed when they fit the task. Use configured
  credentials and never print or request secrets in chat.
- Prefer non-interactive command forms and commands with explicit paths or
  repo-root working directories when automation needs repeatability.

## Test Repositories And Sandboxes

- Repositories, worktrees, clones, directories, containers, or other fixtures
  created for testing during the current task are disposable sandboxes.
- Agents may freely manipulate disposable test repositories, including changing
  files, creating commits, rewriting branches, deleting branches, resetting
  state, changing remotes, and cleaning them up when the test is done.
- Keep disposable repositories in explicit temporary or test paths unless the
  task specifically requires a repo-managed fixture.
- Do not apply sandbox permissions to the user's real project checkout,
  persistent submodules, production repositories, or external systems unless the
  user explicitly requests that manipulation.

## Git And GitHub Commands

- `git` and `gh` commands are allowed tools. Do not ask only because a task uses
  Git, GitHub, remotes, pull requests, issues, releases, checks, workflows, or
  repository metadata.
- Run task-scoped `git` and `gh` actions directly when they are useful for
  inspection, verification, repository setup, CI checks, issue or PR research,
  release lookup, workflow inspection, or other requested work.
- Direct changes in GitHub need extra care because they affect shared remote
  state. Inspect the target, prefer non-interactive commands, and keep changes
  narrowly tied to the user's task.
- Run `gh` only when `GH_TOKEN` is present and valid, force
  `GH_HOST=github.com`, and disable interactive prompting. Never expose the token
  or fall back to another token variable, stored GitHub CLI credentials, or an
  interactive login flow.
- Follow the repository's commit and command-execution rules for commits,
  pushes, branch rewrites, pull-request creation, and other history-changing
  operations in non-disposable repositories.

## Tool Discovery

- Agents may check what is installed before choosing an implementation, for
  example with `command -v`, version flags, package-manager queries, or short
  probe commands.
- Prefer using a suitable installed tool over rebuilding equivalent behavior in
  fragile one-off shell code.
- Keep discovery focused on the task; avoid broad environment dumps unless they
  materially help diagnosis.

## Scripts And Python

- Shell scripts and Python code are allowed when they make work clearer, safer,
  more repeatable, or easier to verify than a sequence of manual commands.
- Prefer shell scripts for command orchestration, repository workflows, and
  straightforward automation when they fit the problem.
- Use Python instead when it is the better tool for the problem, such as for
  structured data processing, non-trivial parsing, transformations, or logic
  that would be fragile or unclear in shell.
- Keep throwaway scripts in explicit temporary paths unless the task is to add a
  repo-owned script.
- Repo-owned scripts must follow the repository's script, documentation, and
  test rules.
- For durable manual file edits, prefer `apply_patch`. Use formatters,
  generators, or repo entrypoints when they are the intended way to update files.

## Installing Missing Tools

- In a devcontainer, agents may install missing tools with `apt-get` without
  asking first after checking that the tool is not already available.
- Before installing with `apt-get`, verify that the session is running inside a
  devcontainer or equivalent containerized development environment.
- Outside a devcontainer, do not install packages without permission. Ask before
  installing, and prefer project-local or temporary tooling when possible.
- Keep package installation minimal and task-focused. Do not make host-level
  package-manager changes outside the devcontainer without explicit approval.

## Safety Boundaries

- Do not print secrets, tokens, private keys, passwords, or credential material.
- Do not run destructive commands unless the user's request clearly requires the
  destructive action or the user explicitly approves it.
- Do not use irreversible Git actions such as hard resets, forced history
  rewrites, or branch deletion unless explicitly requested and verified.
- Keep commands scoped to the current task and avoid modifying unrelated files,
  submodules, services, or external systems.

## Related Files

- `devcontainer-tools.md` lists common tools expected in the shared
  devcontainer image.
- `command-execution.md` defines command preference, Git safety, and repository
  workflow behavior.
- `scripting-best-practices.md` and `bash-scripts.md` define standards for
  repo-owned shell automation.
