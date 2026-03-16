---
title: "spacevim tools#mpv layer"
description: "This layer provides mpv integration for spacevim"
---

# [spacevim Layers:](https://spacevim.org/layers) tools#mpv

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Options](#options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer provides mpv integration for spacevim.

## Install

To use this configuration layer, add it to your `~/.spacevim.d/init.toml`.

```toml
[[layers]]
  name = "tools#mpv"
```

## Options

- `musics_directory`: the directory of musics. By default this option is `~/Music`.
- `mpv_interpreter`: mpv executable path
- `loop_mode`: loop mode, default is `random`

example:

```toml
[[layers]]
    name = 'tools#mpv'
    mpv_interpreter = 'D:\Program Files\mpv\mpv.exe'
    musics_directory = 'F:\other\musics'
```

## Key bindings

| Key Binding | Description       |
| ----------- | ----------------- |
| `SPC m m l` | fuzzy find musics |
| `SPC m m n` | next musics       |
| `SPC m m s` | stop mpv          |
