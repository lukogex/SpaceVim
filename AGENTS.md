# Spacevim

## Project Purpose

Find the project description in the `README.md` file.

**Where to find the details:**

- **README.md#spacevim** - Project description
- **README.md#features** - List of Spacevim features
- **README.md#project-layout** - Project directory layout

## Documentation Organization

This file provides project overview and essential context.

Detailed documentation for Spacevim and its layers is organized in "docs" folders:

**When to read detailed docs:**

- **docs/quick-start-guide.md** - Quick start guide
- **docs/_index.md** - Spacevim documentation main page
- **docs/layers/_index.md** - Spacevim available layers
- **docs/development.md** - Development conventions and guidelines
- **docs/api.md** - Spacevim api documentation

## CRITICAL: Git Commit Policy

**DO NOT create git commits unless explicitly requested by the user.**

- You may use `git add`, `git rm`, `git mv`, and other git commands
- You may stage changes and prepare them for commit
- **DO NOT** run `git commit` - the user handles commits manually
- When changes are ready, inform the user: "Changes are staged and ready for you to commit"

**Exceptions - commits ARE allowed ONLY when:**

- User explicitly requests: "create a commit" or "commit these changes"
- Commit messages must follow [the commit style guide](docs/development/_index.md#commit-style-guide)
- Commit messages must NOT include co-authorship attribution
- No "Co-Authored-By: <agent name>" or similar text
- These are the user's commits, not the agent's
