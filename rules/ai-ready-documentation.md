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
- For source code, prefer explanatory class and function comments when they help
  a later coding agent understand behavior quickly. Explain what the class or
  function does, important inputs, returned values, side effects, failure paths,
  constraints, and major branches when those details are not immediately obvious.
- Detailed explanatory comments are acceptable when they make non-trivial code
  easier to modify safely. Keep them accurate and update them in the same task
  when the described behavior changes.
- Still avoid comments that merely restate one obvious statement at a time; make
  comments useful at the class, function, block, or contract level.
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
- Durable docs stay in English. Summarize multilingual chat context in English
  before committing it to repo-owned documentation.
- Prefer concise, high-signal context over large templates copied everywhere.
