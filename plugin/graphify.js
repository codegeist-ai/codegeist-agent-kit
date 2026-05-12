// graphify.js - OpenCode reminder for existing docs/graphify results.
//
// Why this exists:
// - This repo uses .opencode as a release submodule, so project-specific
//   OpenCode plugins must live outside that release checkout.
// - Graphify should not be executed automatically. The plugin only reminds the
//   session to use already generated graph outputs under docs/graphify.
//
// Related files:
// - plugin/graphify.md
// - opencode.json

import { existsSync } from "fs";
import { join } from "path";

const GRAPH_LOCATIONS = [
  "docs/graphify/current/graphify-out",
  "docs/graphify/graphify-out",
];

export const GraphifyPlugin = async ({ directory }) => {
  let reminded = false;

  return {
    "tool.execute.before": async (input, output) => {
      if (reminded) return;
      if (input.tool !== "bash") return;

      const graphDir = GRAPH_LOCATIONS.find((path) =>
        existsSync(join(directory, path, "graph.json")),
      );
      if (!graphDir) return;

      output.args.command =
        `printf '[graphify] Existing graph available at ${graphDir}. Read ${graphDir}/GRAPH_REPORT.md before architecture searches.\\n' && ` +
        output.args.command;
      reminded = true;
    },
  };
};
