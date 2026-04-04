---
title: "Spacevim bookmarks layer"
description: "This layer provides bookmarking functionalities."
---

# [Available Layers](_index.md) >> bookmarks

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Keybindings](#keybindings)

<!-- vim-markdown-toc -->

## Description

Bookmark plugin for neovim.

## Install

To use this configuration layer, update your custom configuration file with:

```toml
[[layers]]
  name = "bookmarks"
```

## Keybindings

This layer includes `bookmarks.vim`, the following key binding can be used:

| key binding    | description               |
| -------------- | ------------------------- |
| `m m`          | toggle bookmark           |
| `m c`          | clear bookmarks           |
| `m i`          | add bookmark annote       |
| `m a`          | show all bookmarks        |
| `m n`          | jump to next bookmark     |
| `m p`          | jump to previous bookmark |
| `<Leader> f b` | fuzzy find bookmarks      |
