# scrollbar.vim

> _scrollbar.vim_ is floating scrollbar plugin for vim and neovim.

<!-- vim-markdown-toc GFM -->

- [Requirements](#requirements)
- [Installation](#installation)

<!-- vim-markdown-toc -->

## Requirements

- Vim: `exists('*popup_create')`
- Neovim: `exists('*nvim_open_win')`

## Installation

1. Using `scrollbar.vim` in spacevim:

```toml
[[layers]]
  name = 'ui'
  enable_scrollbar = true
```

2. Using `scrollbar.vim` without spacevim:

```
Plug 'wsdjeg/scrollbar.vim'
```
