---
title: "Logger API"
description: "Logger API provides some basic functions for log message."
---

# [Available APIs](../) >> logger

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Functions](#functions)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Intro

`logger` API provides some functions to create logger for plugin.
The Logger class can log messages via buffer, file, vim.notify and :messages.

## Functions

| name                  | description                       |
| --------------------- | --------------------------------- |
| `set_name(string)`    | set the name of current logger    |
| `set_level(number)`   | set the logger level              |
| `error(string)`       | log error message                 |
| `warn(string)`        | log string only when `level <= 2` |
| `info(string)`        | log string only when `level <= 1` |
| `debug(string)`       | log string only when `level <= 0` |

## Usage

```lua
local svim_logger = require("spacevim.api.logger"):new({ level = "debug", name = "spacevim" })

svim_logger:info(msg)
```

There is a deprecated Vimscript logger which simply forwards to the Lua logger.
It is there for backward compatibility only and shoud be replaced by the Lua implementation.
