# Graphify For OpenCode

Use Graphify only as an optional OpenCode aid for existing knowledge graph
results. Do not create or update graphs automatically during normal tasks.

## Scope

- Keep Graphify configuration in the root-owned `plugin/` directory, not in the
  shared `.opencode/` release submodule.
- Do not create a root `AGENTS.md` for Graphify instructions.
- Store any future Graphify analysis output under `docs/graphify/` so multiple
  project graphs can be kept in a consistent documentation location.

## Usage

- If a relevant graph already exists under `docs/graphify/`, read its
  `GRAPH_REPORT.md` before answering architecture or cross-module questions.
- Prefer `graphify query`, `graphify path`, or `graphify explain` only when a
  matching existing `graph.json` is available.
- Do not run `graphify install`, `graphify update`, `graphify extract`, or other
  graph-building commands unless the user explicitly asks for graph generation.
