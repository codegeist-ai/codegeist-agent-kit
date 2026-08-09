# AI-Ready Documentation

Write repo-owned docs, comments, and diagnostics so a later human or AI session
can recover context and review behavior quickly.

## Apply To

- Non-trivial scripts owned by the repo.
- Non-trivial source files, modules, classes, and functions.
- Workflow rules and config files with behavior impact.
- Tests with non-obvious setup or safety constraints.
- Files that connect several entrypoints, services, or mounted paths.

## Standards

- Start non-trivial scripts or config files with a short header that explains
  purpose, key inputs, important side effects, and related files.
- Document non-trivial modules, classes, and functions with comments or
  docstrings that let a reviewer establish the contract without reconstructing
  it from the implementation. Cover purpose, important inputs and outputs,
  side effects, failure paths, invariants, constraints, and major branches.
- Add block comments around important state transitions, external side effects,
  destructive actions, compatibility constraints, and decisions whose rationale
  is not visible from the statements alone.
- Keep explanatory comments accurate and update them in the same task whenever
  the documented behavior changes. Do not omit contract context merely because
  the code appears self-explanatory to its current author.
- Avoid comments that only restate one obvious statement at a time. Comments
  should explain a module, class, function, block, contract, decision, or sharp
  edge.
- A comment may point to a repo-owned Markdown file and section for deeper
  rationale, examples, diagrams, or operational detail. Use a stable
  repository-relative path, summarize the locally relevant contract in the
  comment, and update the comment and document together.
- Make runtime behavior reviewable with meaningful logs at operation boundaries,
  including start, important decisions, externally visible side effects,
  completion, and failure. Pure helpers and trivial accessors do not need
  entry-and-exit logging.
- When logs are intended for an LLM or other automation, use stable event names,
  explicit fields, and concise result or failure summaries so the execution can
  be understood without parsing incidental prose.
- Name related entrypoints explicitly when they matter, for example
  `run.sh`, `build.sh`, `test.sh`, or `scripts/common.sh`.
- Keep destructive or environment-sensitive behavior documented close to the
  code that triggers it.
- Scale detail to the risk and complexity of the behavior, but keep enough local
  context for a reviewer to understand the contract and find deeper docs.

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
