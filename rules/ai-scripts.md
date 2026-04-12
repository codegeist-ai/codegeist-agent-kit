# AI Scripts Usage

Reserve `.opencode/ai-scripts/` for project-specific helper scripts that load
context or gather repeatable research data for AI sessions.

## Current State

- This repo does not currently ship `.opencode/ai-scripts/`.
- Prefer built-in file and search tools unless a script clearly reduces repeated
  multi-file work.

## When To Add One

- Bulk context loading for a stable group of files.
- Repeatable research or inspection with structured output.
- Repo-specific helper behavior that would otherwise require many manual steps.

## Requirements

- Output must be structured and easy to scan.
- Scripts that walk directories should respect ignored or generated files.
- Add or update a small README entry when new AI scripts appear.
- Update this rule when the directory gains new helper scripts or conventions.
- Do not replace precise built-in file tools for single-file work.
