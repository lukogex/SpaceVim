---
title: "Spacevim Architecture"
description: "ADRs (Architectural Decision Records) for Spacevim development."
---

# [Development](../) >> Architecture


<!-- vim-markdown-toc GFM -->

- [Architectural Decision Records](#architectural-decision-records)
  - [ADR-001 Spacevim API](#adr-001-spacevim-api)

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

We expect the following advantages from it:
- Easy adaptions to future changes
- Fast changes and extensions to calls
- Consistent usage of Spacevim API across all layers
- Improved logging and monitoring cababilities
- Reuse of existing logic and improvements
