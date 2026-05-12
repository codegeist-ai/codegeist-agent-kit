---
name: gh-auth
description: verify GitHub CLI auth and trigger the interactive browser login when needed
trigger: /gh-auth
---

# /gh-auth

Use this skill when a task needs `gh` and the current OpenCode session may not
be authenticated yet.

## Usage

```text
/gh-auth
```

## Purpose

This skill standardizes the interactive GitHub CLI login flow for OpenCode
sessions:

- check whether `gh` is already authenticated
- if not, start `gh auth login`
- let the user finish the browser flow
- verify that `gh` is usable before continuing with the GitHub task

## Workflow

1. Run `gh auth status`.
2. If `gh` is already authenticated, report success and continue with the
   original GitHub task.
3. If `gh auth status` reports that no login is present, run `gh auth login`.
4. Tell the user to complete the browser-based authentication flow and wait for
   the CLI command to finish.
5. After the login command returns, run `gh auth status` again.
6. Only continue with `gh repo`, `gh pr`, `gh issue`, `gh api`, or other
   GitHub CLI commands once the second status check succeeds.
7. If the second status check still fails, stop and report the exact failure
   instead of guessing.

## Commands

Use direct shell commands such as:

```bash
gh auth status
gh auth login
gh auth status
```

## Rules

- Do not use `--insecure-storage`.
- Do not read, print, echo, or inspect secret environment variables.
- Do not ask the user to paste tokens, passwords, or credential-store content
  into chat when the browser flow can complete the login.
- Do not continue with GitHub CLI work until `gh auth status` confirms the
  session is authenticated.
