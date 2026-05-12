---
description: Update shared workspace submodules
agent: build
---
Review the current repository state and `.gitmodules`.

Then update these shared submodules to the branch configured in `.gitmodules`:

- `.opencode`
- `.devcontainer`

For each submodule:

1. Verify that the submodule path exists.
2. Verify that the path is a Git checkout.
3. Read the configured branch from `.gitmodules`.
4. Stop and report if no branch is configured for that submodule.
5. Determine the configured upstream remote for the local branch when present;
   otherwise use `origin`.
6. Verify that the remote can be fetched.
7. Fetch the configured branch from that remote.
8. Update the local branch to the fetched remote branch with
   `git checkout -B <branch> <remote>/<branch>` so force-updated release
   branches are handled cleanly.
9. Verify that `HEAD` matches `<remote>/<branch>`.
10. Verify that `git status --short` inside the submodule is clean.

After both submodules are updated:

1. Run `git submodule status -- .opencode .devcontainer` in the parent repo.
2. Report each submodule path, branch, commit, and upstream ref.
3. Report whether the parent repository now has gitlink changes that need to be
   committed.

Do not commit or push parent repository changes from this command.
Do not delete local files inside submodules.
Do not update any submodules other than `.opencode` and `.devcontainer`.
