# Taskfile And Script Creation Rules

Standards for adding new automation without growing unnecessary wrapper layers.

## Defaults

- Do not add a Taskfile unless it clearly simplifies repeated workflows that the
  existing scripts do not already cover.

## Script Rules

- Prefer thin wrappers that delegate to the repo's existing entrypoints or test
  commands.
- Accept explicit inputs by flags or env vars and fail early when required
  values are missing.
- Keep defaults in one place instead of copying the same fallback logic across
  multiple wrappers.
- Keep non-interactive behavior by default.

## If A Taskfile Is Added

- Use absolute or repo-root-based paths.
- Keep task names short and action-based.
- Pass variables explicitly at the call site.
- Avoid deep include magic and self-referential templating that obscures where
  values come from.

## Related Rules

- `command-execution.md`
- `scripting-best-practices.md`
