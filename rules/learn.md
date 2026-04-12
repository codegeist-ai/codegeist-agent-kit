# Learn Rule

Use these rules whenever you are asked to capture new persistent project
guidance from the current chat or repository state.

## Purpose

- Turn durable project decisions into reusable rules.
- Prefer updating an existing rule file over leaving the knowledge only in chat.
- Keep the rule set compact, specific, and useful for future tasks.

## What To Learn

- Explicit user preferences that are likely to apply again.
- Repeated implementation patterns that now count as project convention.
- File-specific guidance for things like `Dockerfile`, `Taskfile`, shell
  scripts, tests, and repo workflows.
- Command-execution preferences, for example which repo entrypoints, scripts,
  Docker commands, or OpenCode commands should be preferred in future tasks.
- Tooling constraints or exceptions that should be remembered, for example when
  a mirrored default exists only to satisfy editor or Docker tooling.

## What Not To Learn

- One-off task details or temporary experiments.
- Raw command output or transient debugging notes.
- Secrets, tokens, credentials, or machine-specific noise.
- Accidental implementation details that were never explicitly chosen.

## How To Apply It

- Start from the active chat context and current repository state.
- Update the most relevant existing rule file first, usually
  `@.opencode/rules/command-execution.md` when the guidance is about command
  choice or execution behavior.
- When importing guidance from another repo, keep the intent but rewrite paths,
  branch names, task structures, and tooling assumptions to match this repo.
- When the learned guidance is about how commands should be chosen or run, check
  whether it belongs in `@.opencode/rules/command-execution.md` instead.
- Scan the context specifically for durable command preferences around repo
  entrypoints, verification commands, Docker usage, interactive vs.
  non-interactive runs, and preferred OpenCode workflow commands.
- If imported guidance conflicts with current repo behavior, merge the useful
  part into the existing rule instead of copying the conflict verbatim.
- Rewrite or remove obsolete guidance instead of stacking contradictory rules.
- Keep additions short, actionable, and clearly project-specific.
- If there is no durable new learning, leave the rules unchanged.

## Accuracy Checks

- Only record guidance that is explicit or strongly reinforced by the context.
- Make sure each learned rule matches the current repository state.
- Avoid broad process rules when a narrower project-specific rule is enough.
