# Excalidraw Export Format

Keep `.excalidraw.svg` files editable in VS Code and compatible Excalidraw
tools.

## Rules

- For editable SVG exports, use Excalidraw's payload marker comments:
  - `<!-- svg-source:excalidraw -->`
  - `<!-- payload-type:application/vnd.excalidraw+json -->`
  - `<!-- payload-version:2 -->`
  - `<!-- payload-start -->...<!-- payload-end -->`
- The payload between `payload-start` and `payload-end` should decode to a valid
  Excalidraw scene wrapper.
- Do not embed raw scene JSON in `CDATA` when the file is meant for the VS Code
  extension.
- Validate both SVG parsing and payload decoding before handing the file off.
