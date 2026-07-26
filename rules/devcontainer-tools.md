# Devcontainer Tools

Use the development tools installed by `.devcontainer/Dockerfile` when they are
the smallest direct way to inspect, edit, build, test, or document the repo.

## Bash Command Access

- Coding agents may use Bash commands without command-level restrictions.
- Prefer non-interactive command forms and the repo's existing entrypoints.
- Keep commands focused on the task and avoid destructive actions unless the
  user explicitly asks for them.
- Prefer built-in OpenCode file tools for precise reads, searches, and manual
  edits unless a shell command is the clearer fit.

## Shells And CLI Basics

- `bash` runs POSIX-style shell scripts, repo entrypoints, and one-off command
  checks.
- `nushell` is available for structured shell pipelines when that is clearer
  than plain Bash.
- `curl` and `wget` fetch HTTP resources, installer scripts, release metadata,
  and API responses.
- `jq` parses and transforms JSON from config files, APIs, and CLI output.
- `rsync` copies or synchronizes directory trees while preserving useful file
  metadata.
- `nc` from `netcat-openbsd` checks local ports and simple TCP connectivity.

## Git And GitHub

- `git` handles repository inspection, diffs, branches, rebases, and commits.
- `gh` handles GitHub issues, pull requests, checks, releases, and API calls;
  verify authentication before using it for GitHub operations.
- `lazygit` is available for local interactive Git inspection, but prefer
  non-interactive `git` commands during agent workflows.

## Code Search And Analysis

- `rg` from `ripgrep` performs fast content searches across the workspace.
- `ast-grep` from `@ast-grep/cli` performs syntax-aware code search and rewrite
  work when text search is not precise enough.
- `scc` summarizes code size, languages, and file statistics.
- `repomix` packages local or remote codebases for AI analysis and MCP use.
- `tiktoken-cli` estimates token usage for prompts, docs, or packed code.

## AI And Research Helpers

- `opencode-ai` provides the OpenCode CLI runtime used by this workspace.
- `ddgr` performs DuckDuckGo searches from the command line.
- `trafilatura` extracts main text content from web pages and HTML documents.
- `lxml_html_clean` supports HTML cleaning workflows used by Python tooling.

## Languages, Runtimes, And Build Tools

- `node` and `npm` provide the Node.js 24.x runtime and package manager.
- `python3` and `pip` provide Python runtime and package installation support.
- `uv` provides fast Python package and tool management.
- `java` runs on GraalVM Community JDK 25.0.2 under `/opt/graalvm`.
- `native-image` builds GraalVM native executables when the project needs them.
- `maven` builds and tests Maven-based Java projects.
- `build-essential` provides compilers and common native build tools.
- `nix` is installed in single-user mode for package-management migration and
  reproducible tooling experiments.

## Containers And Devcontainers

- `docker` uses Docker Engine and CLI packages installed in the image.
- `docker compose` uses the Docker Compose v2 plugin.
- `docker buildx` uses the Docker Buildx plugin for extended image builds.
- `devcontainer` from `@devcontainers/cli` builds, opens, and inspects
  devcontainer environments.
- `containerd` is available as the container runtime dependency.

## Documentation, Diagrams, And Sites

- `hugo` builds and previews Hugo sites; this image installs Hugo Extended
  0.147.9.
- `mmdc` from `@mermaid-js/mermaid-cli` renders Mermaid diagrams.
- `code` provides the Visual Studio Code command-line entrypoint when useful in
  devcontainer workflows.

## FTP And Deployment Utilities

- `ftp` provides a simple FTP client.
- `lftp` provides a more capable FTP/SFTP client for scripted transfers.
