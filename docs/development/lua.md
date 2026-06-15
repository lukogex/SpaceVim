---
title: "Lua Guide"
description: "Guidelines about Lua development in Spacevim."
---

# [Development](../) >> Lua guide


<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Modules](#modules)

<!-- vim-markdown-toc -->

## Intro



## Modules

Calling the module in the module file `M` should be prevented as it has some downsides in regards of naming.
If you import a module the variable name is the base for all the module function names.
Having internally used `M`, but after require use a real name, is a difference which can be misleading when naming functions.

For example a module file `spacevim/api/vim/buffer.lua`:
```lua
local M = {}

function M.create_buffer(listed, scratch)
  return vim.api.nvim_create_buf(listed, scratch)
end
```

Has after import dublication in the naming.
```lua
local svim_buffer = require('spacevim.api.vim.buffer')

buffer = svim_buffer.create_buffer(true, true)
```

It leads to better naming when we call the modules similar file internally and when imported.
Module file `spacevim/api/vim/buffer.lua`:
```lua
local Buffer = {}

function Buffer.create(listed, scratch)
  return vim.api.nvim_create_buf(listed, scratch)
end

return Buffer
```

No dublication in call anymore.
```lua
local svim_buffer = require('spacevim.api.vim.buffer')

buffer = svim_buffer.create(true, true)
```
