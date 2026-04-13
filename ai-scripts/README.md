# AI Scripts

Repo-local helper scripts for repeatable AI workflows.

## Scripts

- `commit-message-guard.sh` - validates `ARG_COMMIT_SUBJECT` and
  `ARG_COMMIT_BODY`, rejects literal `\n` escape sequences, prints the exact
  safe `git commit` command, and can execute plus post-verify the commit when
  `ARG_EXECUTE=1`.

## Usage

```bash
ARG_COMMIT_SUBJECT='docs: example' \
ARG_COMMIT_BODY='Explain why the docs changed.

Keep real newlines in the body.' \
bash ".opencode/ai-scripts/commit-message-guard.sh"

ARG_COMMIT_SUBJECT='docs: example' \
ARG_COMMIT_BODY='Explain why the docs changed.

Keep real newlines in the body.' \
ARG_EXECUTE=1 \
bash ".opencode/ai-scripts/commit-message-guard.sh"
```

## Notes

- Keep commit subjects and bodies in separate environment variables.
- Use real line breaks in `ARG_COMMIT_BODY`; do not pass literal `\n` escapes.
- The script expects staged changes when `ARG_EXECUTE=1` is used.
