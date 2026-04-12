# Commit Rule

Use these rules whenever you create a git commit for this project.

## Format

- Prefer Conventional Commit style: `<type>(<scope>): <subject>` or `<type>: <subject>`.
- Allowed types: `feat`, `fix`, `refactor`, `docs`, `test`, `build`, `ci`, `chore`, `style`.
- Use a scope when it helps, for example `run`, `build`, `image`, `tests`, `opencode`, `rules`, or `chat`.
- Write the subject and body in English.
- Write the subject in imperative mood, for example `add --cmd support`.
- Keep the subject concise and ideally under 72 characters.
- Do not end the subject with a period.

## Content

- Describe the result or intent, not a vague action like `update stuff`.
- Make sure the staged diff matches the message.
- Keep one commit focused on one coherent change.
- Keep the message aligned with the current branch or worktree scope instead of
  mixing unrelated cleanup into the same commit.
- When workflow behavior changes, include matching project-memory or rule
  updates in the same commit when they belong to that change.
- Do not include unrelated files, secrets, or generated noise.

## Body

- Add a body only when extra context is useful.
- Use the body to explain why the change exists, notable constraints, or follow-up notes.
- Use short bullets when several related outcomes or constraints matter.
- Keep body lines readable and roughly wrapped at 72 characters.
- When constructing commit messages via shell flags or automation, use real line
  breaks in the body; never leave literal `\n` escape sequences in the final
  committed message.
- Prefer `git commit -m "<subject>" -m "<body>"` or `git commit -F <file>` over
  embedding escaped newline sequences inside a single `-m` string.

## Examples

- `feat(run): add --cmd support`
- `test(run): verify --cmd returns OK`
- `docs(opencode): add commit command and rule`
- `docs(rules): generalize command workflow`
