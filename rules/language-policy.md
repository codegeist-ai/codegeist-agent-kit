# Language Policy

Use English for code and all durable repo-local project text.

## Must Be In English

- Code comments and identifiers.
- Rule files, README-style docs, and script help text.
- Repo-owned documentation under `docs/`, including user docs, developer docs,
  and task docs.
- Repo-owned source files, configuration files, comments, identifiers, and
  examples.
- Commit messages.
- Test names and assertions.
- Error messages and log output.

## May Follow The User's Language

- Direct conversation with the user.
- Clarifying questions.
- Short explanations during discussion.
- User-facing chats, prompts, and transient conversation text that are not
  committed as durable project documentation.

## Notes

- Keep commands, file paths, env vars, and code snippets in English even inside
  non-English discussion.
- If chat content needs to be recorded in the repository, summarize it in
  English instead of committing raw multilingual chat logs.
- Do not add localized copies of repo-owned documentation under `docs/`. Vendored
  third-party snapshots under `docs/third-party/` keep their upstream language
  structure unless the third-party import workflow explicitly filters them.
- Do not record repo-local language exceptions for durable documentation or
  source artifacts in this project.
