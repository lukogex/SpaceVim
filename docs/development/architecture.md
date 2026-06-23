---
title: "Spacevim Architecture"
description: "ADRs (Architectural Decision Records) for Spacevim development."
---

# [Development](../) >> Architecture


<!-- vim-markdown-toc GFM -->

- [Architectural Decision Records](#architectural-decision-records)
  - [ADR-001 Spacevim API](#adr-001-spacevim-api)
  - [ADR-002 Spacevim Layers](#adr-002-spacevim-layers)

<!-- vim-markdown-toc -->

## Architectural Decision Records

Please read the CHANGELOG.md for details about what has changed.
Here only the overall architectural decisions are documented.
As soon as they are documented here the are in status **ACCEPTED**, every discussions about them are done in the related merge request.

### ADR-001 Spacevim API

**Context**

The combatibility of Spacevim has been reduced to Neovim only from version v3.0.0 onwards.
This might make the Spacevim API, which reason was to guarantee compatibility across Vim and Neovim obsolete.
But still such an abstraction layer can be very helpful for future changes.
All Spacevim logic is then decoupled from the Neovim implementations.

**Decision**

All Spacevim implementations should use the Spacevim API to decouple it from Neovim API.

**Consequences**

All calls to `vim.*` should happen from within the `spacevim.api` modules.
When importing Spacevim APIs prefix the variables with `svim_` to make it clear what is used.

```lua
local svim_buffer = require('spacevim.api.vim.buffer')
```

We expect the following advantages from it:
- Easy adaptions to future changes
- Fast changes and extensions to calls
- Consistent usage of Spacevim API across all layers
- Improved logging and monitoring cababilities
- Reuse of existing logic and improvements

### ADR-002 Spacevim Layers

**Context**

A layer is a bundle of plugins and related configuration which can be applied by Spacevim configuration.

**Decision**

Layers have a type which defines interfaces and key mappings.
We can have several layers of the same type prepared but we can only apply one of each type at a time.
A layer should wrap all necessary plugins and configurations at one place.

**Consequences**

We need a new layer implementation which covers the new way.

What should we do with old layers?

- I dont want to remove everything, lets keep all what might make sense.
  - We reduce to default types and for each of this types we have one default layer.
  - At first we maintain this one default layer per type.

What should we do with deprecated plugin manager?

- Lets find out how we can have it side by side for a long term migration process.
