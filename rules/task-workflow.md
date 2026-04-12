# Task Workflow

Keep task handoff small, traceable, and easy to resume.

## Before You Change Code

- Read the relevant rules and repo docs.
- Read the project memory file when the repo keeps one, often
  `docs/memory-bank/chat.md`.
- Inspect the current scripts, docs, and dirty worktree directly.
- Choose the smallest reasonable scope for the change.

## Working Style

- Prefer a dedicated branch or worktree when the change is more than trivial.
- Keep one task focused on one behavior or workflow change.
- Use repo-local commands, docs, and reference material when they already
  exist.
- When behavior changes, update the matching docs and project memory in the same
  task when the repo keeps them.

## Repo Task Files

- Use local `docs/tasks/` when the repo needs tracked task handoff files.
- Use top-level task files as `docs/tasks/TNNN_<slug>.md` by default, starting
  at `T001`.
- When a task gains child tasks, migrate it to `docs/tasks/TNNN_<slug>/task.md`
  and create child tasks under `docs/tasks/TNNN_<slug>/tasks/`.
- When a migrated task no longer has child tasks, collapse it back to the flat
  `docs/tasks/TNNN_<slug>.md` form and remove the empty task directory.
- Use the same migration rule recursively for child tasks under
  `<parent-task-dir>/tasks/`.
- Use child task ids as `<parent-id>_NN`, for example `T001_01` or
  `T001_01_01`.
- Keep one canonical representation per task: either `TNNN_<slug>.md` or
  `TNNN_<slug>/task.md`, never both.
- Keep each task self-contained; a task under another task still needs its own
  goal, acceptance criteria, verification, and file targets, with the `Parent`
  field linking back to the owning task.
- Follow the repo's language rules for task docs under `docs/`. If the repo
  does not define a language for that documentation tree, default to English.
- Use `specify` to clarify a task with the user in depth before implementation.
- Capture concrete solution directions, suggestions, and alternatives when they
  help specify the work more clearly, but keep `specify` focused on defining
  the work rather than executing it.
- Use the repo-local `/task` command for `create`, `specify`,
  `solve`, `cancel`, and `backlog` work when that workflow fits the task.
- Use `/task backlog <title>` when you want to save an idea quickly without
  turning it into an active task yet.
- For `/task backlog`, only local `docs/tasks/backlog.md` should be staged and
  committed; unrelated worktree changes must stay out of that quick-save path.

## Finishing A Task

- Run targeted verification for the changed behavior.
- Capture durable rule changes in `.opencode/rules/` when they belong in the
  shared workflow.
- Refresh project memory when future sessions would otherwise miss important
  context.
- Use `@.opencode/commands/update-chat.md`, `@.opencode/commands/learn.md`, or
  `@.opencode/commands/save.md` when that workflow fits the repo.

## Future Expansion

- If the repo adopts task files, issue ids, or stricter branch naming, record
  those exact conventions in repo-local docs instead of relying on implicit
  habits.
