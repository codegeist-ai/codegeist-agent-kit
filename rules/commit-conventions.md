# Commit Conventions

Detailed commit guidance that complements `commit.md`.

## Format

- Use Conventional Commits: `<type>(<scope>): <subject>` or
  `<type>: <subject>`.
- Preferred types: `feat`, `fix`, `refactor`, `docs`, `test`, `build`, `ci`,
  `chore`, `style`.
- Keep the subject in English, imperative, and without a trailing period.
- Keep the subject concise and ideally within 72 characters.
- Use a short scope that matches the changed area, for example `run`, `build`,
  `image`, `tests`, `opencode`, `rules`, or `chat`.

## Body

- Add a body for non-trivial changes.
- Explain why the change exists, important constraints, or follow-up notes.
- Wrap body lines around 72 characters when practical.
- Use bullet points when several related outcomes matter.
- When using CLI flags or automation to create commit messages, pass a real
  multiline body and do not commit literal `\n` sequences.
- Prefer multiple `-m` flags or `git commit -F <file>` when scripting commit
  messages; do not rely on escaped newlines inside one quoted `-m` argument.

## Scope And Context

- Keep one commit focused on one unit of work.
- If the change belongs to a named branch or worktree, keep the commit scope and
  message consistent with that work.
- When a task includes submodule work, keep the submodule commit or commits and
  the parent gitlink update aligned within the same unit of work.
- If repo memory or workflow rules change as part of the same task, include the
  matching project-memory or `.opencode/rules/*.md` updates in that commit.
- Do not use commit messages as a substitute for task planning; keep planning in
  repo-local planning docs and rule files.

## Relationship To `commit.md`

- Treat `commit.md` as the short mandatory rule set.
- Use this file for the longer explanation, preferred patterns, and examples
  when the shorter rule is not enough.

## Examples

- `feat(run): add default develop worktree`
- `fix(tests): reuse built image in e2e smoke`
- `docs(rules): simplify shared defaults`
- `chore(opencode): align save workflow docs`
