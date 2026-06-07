---
title: "codingagent layer"
description: "AI agentic coding integration for SpaceVim"
---

# [Layers](../index.md) >> codingagent

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
  - [External Dependencies](#external-dependencies)
- [Key Bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

The `codingagent` layer provides AI-driven coding assistance directly in Neovim using `opencode.nvim`.
It features a persistent chat interface, context-aware suggestions, and project-wide agentic actions.

## Install

To use this configuration layer, add it to your custom configuration file:

```toml
[[layers]]
  name = "codingagent"
```

### External Dependencies

This layer requires the `opencode` CLI tool to be installed and available in your `PATH`.
Follow the instructions at [opencode.ai](https://opencode.ai) to install the agent.

## Key Bindings

| Key Bindings | Descriptions |
| :--- | :--- |
| `SPC a c t` | Toggle OpenCode Chat Panel |
| `SPC a c c` | Chat with current buffer or selection |
| `SPC a c f` | Add current file to agent context |
| `SPC a c r` | Clear/Reset agent session |
| `SPC a c s` | Stop agent generation |
