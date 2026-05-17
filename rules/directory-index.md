# Directory Index Pattern

Use these rules when creating, reading, or updating agent-owned `INDEX.md`
files inside repository directories.

## Purpose

- Treat `INDEX.md` as a lightweight navigation map for coding agents working in
  large or dense directories.
- Help agents load the right local context quickly without scanning every file.
- Preserve directory-specific search hints, entrypoints, responsibilities, and
  sharp edges close to the files they describe.

## When To Use It

- Create an `INDEX.md` when a directory is large enough that future agents would
  otherwise need repeated discovery work to understand what belongs there.
- Read a nearby `INDEX.md` before changing files in that directory when it
  exists.
- Prefer the closest applicable `INDEX.md`; parent indexes should give broad
  orientation, while child indexes should describe local detail.
- Let an `INDEX.md` link to other `INDEX.md` files when that helps agents move
  between related directories without broad rediscovery.
- Keep the repository-root `INDEX.md` as the top-level index registry when one
  exists. It should list the paths to every known directory `INDEX.md` so agents
  can discover the available local maps quickly.
- Do not create indexes for tiny or obvious directories unless the directory has
  non-obvious responsibilities, generated files, or safety constraints.

## Content Contract

An `INDEX.md` should be compact, current, and useful for search. Include only
sections that add real value for the directory:

- Purpose and scope of the directory.
- When an agent should read this index.
- Directory map with important files and subdirectories.
- Links to related `INDEX.md` files when nearby local maps are useful.
- For the repository-root index, a list of every known `INDEX.md` path.
- Key workflows, entrypoints, commands, or related docs.
- Search hints such as symbols, filenames, config keys, or grep terms.
- Update triggers that explain when this index should change.
- Agent notes for constraints, generated files, ownership, or sharp edges.

## Recommended Shape

```markdown
# Directory Index

One-line summary of what this directory owns.

## When To Read This

- Read before editing ...

## Directory Map

- `path-or-file` - why it matters and when to open it.

## Key Workflows

- ...

## Search Hints

- `symbol`, `filename`, or `config-key`

## Update Triggers

- Update this file when ...

## Agent Notes

- ...
```

## Maintenance

- Update the relevant `INDEX.md` in the same task when files move,
  responsibilities change, important entrypoints appear, or search hints become
  stale.
- Update the repository-root `INDEX.md` whenever any directory `INDEX.md` is
  added, moved, or removed.
- Rewrite stale entries instead of appending contradictory notes.
- Keep indexes concise enough to load into context directly.
- Keep durable text in English and follow repo-local documentation rules.

## Boundaries

- Do not use `INDEX.md` as a transcript, task tracker, changelog, or replacement
  for project memory such as `docs/memory-bank/chat.md`.
- Do not store secrets, raw command output, large generated dumps, or temporary
  debugging notes.
- Do not duplicate every file in a directory; focus on the files future agents
  are most likely to need.
- Do not override human-facing documentation. Link to it when it is the better
  source of truth.
