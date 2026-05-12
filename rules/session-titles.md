# Session Titles

Keep OpenCode session titles short, searchable, and tied to the current branch
plus the most recent meaningful result from the session.

## Rules

- Keep titles ASCII and concise.
- Run `git --no-pager status --short --branch` first so the current branch is
  explicit before drafting the title.
- Always put the current git branch first in brackets.
- Follow the branch prefix with a short description of what was just changed,
  fixed, documented, or implemented.
- Prefer short result-oriented phrasing over generic task labels.
- Avoid vague suffixes such as `Work in progress`, `Misc updates`, or
  `More changes`.

## Recommended Format

`[<branch>] <Recent result>`

## Examples

- `[develop] Adjust opencode rules`
- `[main] Sync shared rules`
- `[feature/chat] Implement session streaming`

## Copy Note

If a human needs to copy a session title, wrap it in inline code or a fenced
code block so bracketed prefixes are preserved exactly.
