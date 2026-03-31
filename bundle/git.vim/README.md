# git.vim

> _git.vim_ is a plugin to use _git_ command in vim and neovim.

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Usage](#usage)

<!-- vim-markdown-toc -->

## Install

1. Using `git.vim` in spacevim:

```toml
[[layers]]
  name = 'git'
```

2. Using `git.vim` without spacevim:

```
Plug 'wsdjeg/git.vim'
```

## Usage

- `:Git add %`: stage current file.
- `:Git add .`: stage all files
- `:Git commit`: edit commit message
- `:Git push`: push to remote
- `:Git pull`: pull updates from remote
- `:Git fetch`: fetch remotes
- `:Git checkout`: checkout branches
- `:Git log %`: view git log of current file
- `:Git config`: list all git config
- `:Git reflog`: manage reflog information
- `:Git branch`: list, create, or delete branches
- `:Git rebase`: rebase git commit
- `:Git diff`: view git-diff info
