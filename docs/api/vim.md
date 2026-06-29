---
title: "vim API"
description: "Proxy interface to the Neovim Lua standard library."
---

# [Available APIs](../) >> vim

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Additional Functions](#additional-functions)

<!-- vim-markdown-toc -->

## Intro

Spacevim `vim` api is an interface to the [Nvim Lua standard library](https://neovim.io/doc/user/lua/#_lua-standard-modules).
It should be used to consolidate all Neovim API calls and make them better observable and documented.

> [!note] Vim APIs
> All the different APIs and functions are quite confusing especially as I'm still rather new to Neovim.
> Its hard to follow [ADR-001](../../development/architecture.md#adr-001-spacevim-api) with all this different implemantations existing in Spacevim and this many ways to interact with Neovim.
> Because of this I want to use `spacevim.api.vim` as an interface to all calls to the Neovim lua standard module.
> This provides the opportunity to group and document calls to Neovim and helps me learning all the different methods.
> It might be one unecessary hop thats true but at the moment I need a single point to consolidate new things as I feel lost with all this different methods and dublicated implementations.
> Furthermore this might help in future compatibility implementations.

When using the Spacevim vim API its best practice to define a local variable with similar names as the forwarding API.
Like this its easy to anderstand whats its target and it could be replaced easily with the direct call to Lua standard library as well.

```lua
local fn = require('spacevim.api.vim').fn
local fs = require('spacevim.api.vim').fs
```

TODO: Mairmaid with API calls layer -> api -> vim!

## Additional Functions

**Type checking:**

- `is_number(var)`
- `is_string(var)`
- `is_func(var)`
- `is_list(var)`
- `is_dict(var)`
- `is_float(var)`
- `is_bool(var)`
- `is_none(var)`
- `is_job(var)`
- `is_channel(var)`
- `is_blob(var)`

here is an example for using type checking functions:

```vim
let s:VIM = spacevim#api#import('vim')
let var = 'hello world'
if s:VIM.is_string(var)
  echo 'It is a string'
endif
```

**Others:**

- `win_set_cursor(winid, pos)`: change the cursor position of specific window.
- `jumps()`: return the jump list
- `setbufvar(bufnr, dict)`: the second argv is a dictionary, set all the options based on the keys in `dict`.
for example:
  ```vim
  let s:VIM = spacevim#api#import('vim')
  call s:VIM.setbufvar(s:bufnr, {
        \ '&filetype' : 'leaderGuide',
        \ '&number' : 0,
        \ '&relativenumber' : 0,
        \ '&list' : 0,
        \ '&modeline' : 0,
        \ '&wrap' : 0,
        \ '&buflisted' : 0,
        \ }
  ```
