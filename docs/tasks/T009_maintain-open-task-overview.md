# Maintain An Open Task Overview

- **ID:** T009
- **Type:** feature
- **Parent:** none
- **Status:** solved
- **Public Tracking:** not requested
- **Tracking Key:** 02e25f7c-2ff2-419c-a1a1-056fe49ead30

## Goal

Maintain a concise project-owned `docs/tasks/OVERVIEW.md` listing open tasks,
their purpose, dependencies, and blockers through the shared `/task` workflow.

## Context

The user requested a quick view of unfinished work and selected shared workflow
support for all agent-kit consumers. Individual local task files remain the
source of truth; the overview is a derived navigation and planning aid.

## Scope

- Define overview creation and maintenance in the shared task command and rule.
- List top-level and nested tasks with status `open`, `specified`, `in progress`,
  or `blocked`; omit `solved`, `finalized`, and `cancelled` tasks.
- Use a compact table containing a linked task ID and title, status, one-sentence
  goal summary, dependencies, and blockers with the recorded next step when known.
- Link task dependencies to their canonical files; summarize external
  prerequisites without inventing relationships or impediments.
- Distinguish explicitly absent dependencies or blockers (`None`) from missing
  information (`Not recorded`). Show `No open tasks.` when no tasks qualify.
- Refresh the overview after task creation, status or content changes affecting
  the summary, cancellation, completion, and task path or hierarchy changes.
- Preserve the focused `/task backlog` contract: backlog capture does not update
  the overview or other task files.
- Reuse `Dependencies` and add a `Blockers` section to the task template.
- Document the convention and create this repository's initial overview.

## Acceptance Criteria

- The shared `/task` workflow creates or refreshes the consuming repository's
  `docs/tasks/OVERVIEW.md` for task changes, including blocked outcomes and
  completion, without adding a new task action.
- The overview includes every qualifying top-level and nested task exactly once
  and links to its canonical local path.
- Each row accurately summarizes the local status, goal, dependencies, and
  blockers; missing information is not presented as an explicit absence.
- Closing or cancelling a task removes its row; moving a task repairs overview
  links. An empty overview says `No open tasks.`.
- Overview maintenance uses local task records without introducing GitHub
  requests or changing public-tracking authorization and completion invariants.
- `/task backlog` continues to change only `docs/tasks/backlog.md`.
- Task files remain authoritative; the overview stays project-owned and is not
  shipped as a shared release file.
- The template, local guide, root index, and release documentation describe the
  convention consistently.
- Targeted verification, `task test`, and `git --no-pager diff --check` pass.

## Files

- `commands/task.md`
- `rules/task-workflow.md`
- `docs/tasks/template.md`
- `docs/tasks/README.md`
- `docs/tasks/OVERVIEW.md`
- `INDEX.md`
- `README_release.md`
- `tests/release-copy.sh`
- `docs/tasks/T009_maintain-open-task-overview.md`

## Non-Goals

- Building a task database, dashboard, generator, or scheduler.
- Listing backlog ideas or completed tasks in the open-task table.
- Bulk migration of historical task files or inferred task dependencies.
- Public Issue creation, release publication, or automatic commits.
- Editing generated `.opencode/` files.

## Implementation Hints

- Keep the overview deterministic, compact, and ordered by task ID.
- Follow standalone and nested canonical task representations recursively.
- Update the overview only after the task file reflects its actual outcome;
  preserve close-before-solved behavior for linked Issues.
- Keep existing templates and fallback behavior usable for consuming projects
  that have not yet added `Blockers` sections.

## Verification

- Verify all included and excluded statuses, nested task links, dependency links,
  missing-versus-empty fields, and the empty overview state.
- Verify refresh instructions cover task path changes, blocked outcomes,
  completion, and cancellation while preserving the backlog exception.
- Check this repository's overview against its canonical task records.
- Run `task test` and `git --no-pager diff --check`.

Results:

- `task test` passed. The release smoke test checks the shipped prompt contract
  for included/excluded statuses, recursive children, task and dependency links,
  missing-versus-empty fields, blocked exits, closure ordering, path repairs,
  the empty state, and the backlog exception. Project task files remain excluded
  from the release bundle.
- A direct local record/link check confirmed T009 was the only active task and
  its overview row linked to its canonical file while implementation was active.
- After successful verification, T009 became `solved` and the overview was
  refreshed to `No open tasks.`; the empty state was checked against all records.
- `git --no-pager diff --check` passed.
- Behavior is agent/prompt-driven, not a deterministic overview generator. The
  tests verify the workflow contract and actual local overview; autonomous
  execution against synthetic task hierarchies was not exercised.

## Dependencies

- None.

## Blockers

- None.

## Open Questions

None.
