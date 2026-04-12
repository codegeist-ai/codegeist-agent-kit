# AI-Ready Documentation

Write repo-owned docs and comments so a later AI session can recover context
quickly.

## Apply To

- Non-trivial scripts owned by the repo.
- Workflow rules and config files with behavior impact.
- Tests with non-obvious setup or safety constraints.
- Files that connect several entrypoints, services, or mounted paths.

## Standards

- Start non-trivial scripts or config files with a short header that explains
  purpose, key inputs, important side effects, and related files.
- Document why, constraints, and sharp edges; avoid line-by-line narration of
  obvious code.
- Name related entrypoints explicitly when they matter, for example
  `run.sh`, `build.sh`, `test.sh`, or `scripts/common.sh`.
- Keep destructive or environment-sensitive behavior documented close to the
  code that triggers it.
- Keep documentation proportional; tiny files do not need large comment blocks.

## Suggested Header

```bash
#!/usr/bin/env bash
# script.sh - one-line purpose
#
# Why this exists:
# - ...
#
# Inputs:
# - ...
#
# Related files:
# - ...
```

## Reminder

- Comments stay in English.
- Durable docs default to English unless the repo records an explicit language
  exception for a documentation tree such as `docs/`.
- Prefer concise, high-signal context over large templates copied everywhere.
