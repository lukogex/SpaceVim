# Spacevim

## Project Purpose

Find the project description in the `README.md` file.

**Where to find the details:**

- **README.md#spacevim** - Project description
- **README.md#features** - List of Spacevim features
- **README.md#project-layout** - Project directory layout

## Documentation

The documentation provides essential information and context for Spacevim implementation and usage.

Detailed documentation for Spacevim and its layers is organized in `docs` folders:

**When to read detailed docs:**

- **docs/quick-start-guide.md** - Quick start guide
- **docs/_index.md** - Spacevim documentation main page
- **docs/layers/_index.md** - Spacevim available layers
- **docs/development/_index.md** - Development conventions and guidelines
- **docs/api/_index.md** - Spacevim api documentation

Help documentation is located in `doc` folder following Neovim plugins directory structure.

## Development

### Guidelines

**Where to find development guidelines:**

- **docs/development/architecture.md** - Spacevim architecture and ADRs (Architecure Decision Records)
- **docs/development/lua.md** - Lua development guidelines
- **docs/development/markdown.md** - Markdown guidlines
- **docs/development/vimscript.md** - Vimscript development guidelines

Always keep guidelines and ADRs in mind when developing new things.
Furthermore always leave code you touch better then you found it.
There is a continuous change ongoing to transform Spavevim for the [new goals from version v3.0.0 onwards](README.md#forked-project).

### Git Commit Policy

**DO NOT create git commits unless explicitly requested by the user.**

- You may use `git add`, `git rm`, `git mv`, and other git commands.
- You may stage changes and prepare them for commit.
- **DO NOT** run `git commit` - the user handles commits manually.
- When changes are ready, inform the user: "Changes are staged and ready for you to commit".

**Exceptions - commits ARE allowed ONLY when:**

- User explicitly requests: "create a commit" or "commit these changes".
- Commit messages must follow [the commit style guide](docs/development/_index.md#commit-style-guide).
- Commit messages must NOT include co-authorship attribution.
- No "Co-Authored-By: <agent name>" or similar text.
- These are the user's commits, not the agent's.

### Releasing

- Releases are simply Git tags of this repository.
- We use semantic releasing to create new versions dfrom Git history.
- **It is crucial to follow conventional commits and mention BREAKING CHANGES in the related commit messages.**
