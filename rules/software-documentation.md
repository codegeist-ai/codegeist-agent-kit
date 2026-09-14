# Software Documentation

Use these rules whenever you create or update repo-local software
documentation.

## Purpose

- Keep software documentation focused on current behavior, usage, and
  maintenance-relevant context.
- Help a later human or AI understand what the software does, how it is used,
  and where the sharp edges are.

## What To Document

- Purpose and scope.
- The current contract or behavior, not stale plans.
- Important entrypoints, commands, file paths, and related files.
- Inputs, outputs, dependencies, and relevant configuration.
- Constraints, failure modes, and operational sharp edges.
- Important runtime events, log fields, and diagnostic conventions when
  operators, tests, LLMs, or automation depend on them.
- Real workflows or examples when they make usage clearer.

## Recommended Structure

- Start with a clear title and a one-line summary.
- Split larger topics into small sections with concrete headings.
- Use short command examples or file references when they improve clarity.
- Name related files and entrypoints explicitly when readers need to move
  between them.
- Use stable repository-relative links and section anchors when source comments
  or other docs need deeper rationale, diagrams, examples, or operational detail.
- Prefer a focused Markdown document when the explanation would make source
  comments hard to scan. Keep a short contract summary in the source and link
  the document back to the relevant implementation files.
- Keep background material short unless it changes implementation or usage.

## Documentation Developer Map

- When a repository-root `docs/` directory exists, maintain a concise
  `docs/index.html` as a human-readable developer map of the project's
  documentation, important paths, commands, and workflows. Do not create a new
  `docs/` tree solely to add this page.
- Apply this contract only to documentation owned by the active source
  repository. Do not update generated, vendored, mounted, or dependency
  checkouts such as `.opencode/` or `.devcontainer/` as a side effect.
- Keep the page self-contained and directly usable through `file://`: place its
  essential content, CSS, and classic JavaScript in the HTML file. Do not require
  a server, runtime file reads, fetch or XHR requests, module imports, external
  scripts, styles, fonts, images, analytics, or a `<base>` URL.
- Use a restrictive inline content security policy that permits the page's
  embedded styles and classic script while denying runtime connections and
  external assets.
- Put the core documentation in semantic HTML so it remains readable without
  JavaScript. Use JavaScript only for progressive enhancements such as local
  search, filtering, or compact section navigation.
- Derive the project overview, starting points, important paths, documentation
  links, common commands, setup steps, and canonical test command from current
  authoritative repository files. Omit unavailable details instead of inventing
  them, and never include secrets or machine-specific absolute paths.
- Use repository-relative links from `docs/index.html` and verify that local
  targets and fragments exist. External navigation links are allowed, but the
  initial page load must not depend on network access.
- Treat the page as a functional map, not a marketing site or decorative
  dashboard. Prioritize information density, scan-friendly path and command
  lists, restrained typography, and clear navigation. Avoid oversized hero
  sections, ornamental cards, gradients, shadows, or animation unless a concrete
  project need makes one useful. Preserve useful map-oriented styling during
  refreshes; reuse graphics only when they clarify the project and embed required
  visuals directly, for example as inline SVG.
- Keep the page semantic, keyboard-accessible, responsive, and consistent with
  any intentional project visual language that does not compromise its role as a
  developer map.
- Treat the map as maintained documentation rather than a web application. Do
  not add a dedicated automated page test by default; use documentation review
  and a direct `file://` open, adding only a focused regression check when a
  concrete defect justifies one.
- Keep `docs/index.html` distinct from an agent-owned repository `INDEX.md`: the
  HTML page is a browser-readable developer map, while `INDEX.md` is a compact
  navigation map loaded as agent context.

## Diagrams

- Use diagrams when they give a faster overview than prose alone.
- Prefer PlantUML for structured technical views such as component, class,
  sequence, deployment, activity, or state diagrams.
- Prefer Excalidraw for editable overview sketches, freeform system maps, or
  diagrams that need lightweight annotation and discussion.
- Use diagrams both for high-level overviews and for focused detail views when a
  subsystem has non-obvious structure or flow.
- Keep diagram source files alongside the documentation they support so updates
  stay local and discoverable.
- When using Excalidraw exports, follow the separate `.excalidraw.svg` format
  rule in `excalidraw.md`.

## Writing Style

- Document the current truth, not an aspirational future state.
- Prefer concise, high-signal sections over long prose.
- Explain why and constraints; avoid paraphrasing obvious code.
- Make source-to-document relationships explicit enough that a reviewer can
  move in either direction without searching by guesswork.
- Rewrite stale sections instead of appending contradictory updates.
- Keep examples minimal and realistic.
- Call out assumptions or open gaps explicitly when they still matter.

## Maintenance

- Update documentation in the same task when behavior changes.
- Refresh `docs/index.html` when project entrypoints, important paths, common
  commands, setup, tests, or linked documentation change.
- Remove or rewrite obsolete statements promptly.
- Keep documentation proportional to the complexity of the software.
- Validate repo-relative source and documentation links when either side moves.
- Refresh related diagrams when the documented architecture or behavior changes.
- Follow repo-local path, structure, and language rules when a repo defines
  them.
