# Commit Rule

Use these rules whenever you create a git commit for this project.

## Authorization

- This file defines how to create an already-authorized commit; it never grants
  authorization to create one.
- Apply the canonical Git Write Authorization gate in `command-execution.md`.

## Format

- Use Conventional Commit style: `<type>(<scope>): <subject>` or `<type>: <subject>`.
- Allowed types: `feat`, `fix`, `refactor`, `docs`, `test`, `build`, `ci`, `chore`, `style`.
- Write the subject and body in English.
- Write the subject in imperative mood, for example `add --cmd support`.
- Keep the subject concise and ideally under 72 characters.
- Do not end the subject with a period.
- Use a short scope that identifies the changed area when a scope adds useful
  context.

## Content

- Describe the result or intent, not a vague action like `update stuff`.
- Make sure the staged diff matches the message.
- Keep one commit focused on one coherent change.
- When a task intentionally changes a submodule, include the relevant submodule
  commit or commits together with the matching parent gitlink update.
- Treat a changed submodule commit ID in the parent repo as a real task change;
  do not leave an intended gitlink update out of the commit or commit the
  parent change without the corresponding submodule state.
- Treat parent gitlink updates for shared workspace submodules such as
  `.opencode` and `.devcontainer` as real task changes when they were refreshed
  by the task workflow; include them in the same commit instead of saving them
  separately.
- When workflow behavior changes, include matching documentation or rule updates
  in the same commit when they belong to that change.
- Do not include unrelated files, secrets, or generated noise.

## Body

- Add a body for non-trivial changes; omit it only when the subject fully explains
  a small change.
- Use the body to explain why the change exists, notable constraints, or follow-up notes.
- Wrap body lines around 72 characters when practical.
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
