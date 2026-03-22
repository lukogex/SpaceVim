# format.nvim

> _format.nvim_ is an asynchronous code formatting plugin based on spacevim job api.

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Install

1. Using `format.nvim` in spacevim:

```toml
[[layers]]
  name = 'format'
  format_method = 'format.nvim'
```

2. Using `format.nvim` without spacevim:

```
Plug 'wsdjeg/format.nvim'
```

## Configuration

```lua
require('format').setup({
  custom_formatters = {
    lua = {
      exe = 'stylua',
      args = { '-' },
      stdin = true,
    },
  },
})
```


## Usage

- `:Format`: format current buffer
