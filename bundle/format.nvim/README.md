# format.nvim

> _format.nvim_ is an asynchronous code formatting plugin based on spacevim job api.

[![](https://spacevim.org/img/build-with-spacevim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Usage](#usage)
- [Feedback](#feedback)

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

## Feedback

The development of this plugin is in [`spacevim/bundle/format.nvim`](https://github.com/spacevim/spacevim/tree/master/bundle/format.nvim) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/spacevim/spacevim/issues)
