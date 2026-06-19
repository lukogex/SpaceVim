---
title: "Development"
description: "General contributing guidelines and changelog of spacevim, including development information about spacevim"
---

# [Home](../_index.md) >> Development

Spacevim is a joint effort of all contributors.
This page describes the entire development process of Spacevim.

We have some guidelines that we need all contributors to follow.
You can only think about reading the part that is relevant to what you are going to do:

<!-- vim-markdown-toc GFM -->

- [Contributing code](#contributing-code)
  - [Conventions](#conventions)
  - [Commit style guide](#commit-style-guide)
  - [Contributing a layer](#contributing-a-layer)
  - [Contributing a keybinding](#contributing-a-keybinding)
  - [Language specified key bindings](#language-specified-key-bindings)
- [Bundle plugins](#bundle-plugins)

<!-- vim-markdown-toc -->


## Contributing code

The source code of Spacevim is hosted at [Github](https://github.com/lukogex/spacevim).
Code and documentation contributions of any kind are welcome. 

### Conventions

Spacevim is based on conventions, mainly for naming functions, keybindings definition and writing documentation.
Please read these conventions to make sure you understand them before you contribute code or documentation for the first time.

- [Architectural Decision Records](architecture.md)
- Language specific conventions
  - [Lua](lua.md)
  - [Markdown](markdown.md)
  - [Vimscript](vimscript.md)

### Commit style guide

Follow the [conventional commits guidelines](https://www.conventionalcommits.org/) to make reviews easier and to make the git logs more valuable.
The general structure of a commit message is:

```
<type>([optional scope]): <description>

[optional body]
```

**types:**

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `pref`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `ci`: Changes to our CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files
- `revert`: Reverts a previous commit

**scopes:**

Scope is optional and is used to reference issue tracker IDs.

**body:**

Not all commits are complex enough to warrant a body, therefore it is optional and only used when a commit requires a bit of explanation and context.

**Breaking change**

Breaking changes must be indicated by `!` after the type/scope, and a `BREAKING CHANGE:` body describing the change.

### Contributing a layer

The following example shows how to create a new layer named `foo`:

1. Fork spacevim repo.
2. Add a layer file `autoload/spacevim/layers/foo.vim` for `foo` layer.
3. Edit layer file, check out the example below:

```vim
""
" @section foo, layers-foo
" @parentsection layers
" This is the doc for this layer:
"
" @subsection Key Bindings
" >
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <leader>jA    generate accessors
"   normal    <leader>js    generate setter accessor
" <
" @subsection Layer options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   option1       Set option1 for foo layer               ''
"   option2       Set option2 for foo layer               []
"   option3       Set option3 for foo layer               {}
" <
" @subsection Global options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   g:pluginA_opt1    Set opt1 for plugin A               ''
"   g:pluginB_opt2    Set opt2 for plugin B               []
" <

function! spacevim#layers#foo#plugins() abort
  let plugins = []
  call add(plugins, ['Shougo/foo.vim', {'option' : 'value'}])
  call add(plugins, ['Shougo/foo_test.vim', {'option' : 'value'}])
  return plugins
endfunction


function! spacevim#layers#foo#config() abort
  let g:foo_option1 = get(g:, 'foo_option1', 1)
  let g:foo_option2 = get(g:, 'foo_option2', 2)
  let g:foo_option3 = get(g:, 'foo_option3', 3)
  " ...
endfunction

" add layer options:
let s:layer_option = 'default var'
function! spacevim#layers#foo#set_variable(var) abort
  let s:layer_option = get(a:var, 'layer_option', s:layer_option)
endfunction

" completion function for layer options:
function! spacevim#layers#foo#get_options() abort
    return ['layer_option']
endfunction
```

4. Create the layer's documentation file `docs/layers/foo.md` for `foo` layer.
5. Open `docs/layers/index.md`, and run `:call spacevim#dev#layers#update()` to update the layers list.
6. Send a PR to spacevim.

### Contributing a keybinding

Mappings are an important part of Spacevim.

First if you want to have some personal mappings.
This can be done in your bootstrap function.

If you think it is worth contributing new mappings, be sure to read the documentation to find the best mappings, then create a Pull-Request with your mappings.

ALWAYS document your new mappings or mapping changes inside the relevant documentation file.
It should be the layername.md and the [documentation](../documentation/).

### Language specified key bindings

All language specified key bindings have the prefix `SPC l`.

We recommend you to use the common language specified key bindings for the same purpose as the following:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `g d`       | jump to definition                               |
| `g D`       | jump to type definition                               |
| `SPC l r`   | start a runner for current file                  |
| `SPC l e`   | rename symbol                                    |
| `SPC l d`   | show doc                                         |
| `K`         | show doc                                         |
| `SPC l i r` | remove unused imports                            |
| `SPC l i s` | sort imports with isort                          |
| `SPC l s i` | Start a language specified inferior REPL process |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

All above key bindings are just recommended as default, but they are also based on the language layer itself.

## Bundle plugins

In `bundle/` directory, there are two kinds of plugins:

- Unmodified plugins, same as the upstream.
- Modified plugins based on specific commit.
- Detached plugins
  They have been implemented with spacevim as bundled plugin but were detached into an own repository with all needed script files to have them standalone usable as well.
  The detaching has been removed with version 3.0.0.
  We could migrate to the standalone plugins step by step.
  The origin author even has proceed with some of them despite discontinuing spacevim.
  Be aware that some of them switched from vim script to lua (vim to nvim).
  Following is the list of detached plugings from the former detach script:
  - [GitHub.vim](https://github.com/wsdjeg/github.nvim)
  - [JavaUnit.vim](https://github.com/wsdjeg/JavaUnit.vim)
  - [scrollbar.vim](https://github.com/wsdjeg/scrollbar.nvim)
  - [cpicker.nvim](https://github.com/wsdjeg/cpicker.nvim)
  - [cscope.vin](https://github.com/wsdjeg/cscope.vim-1)
  - [dein-ui.vim](https://github.com/wsdjeg/dein-ui.vim)
  - [flygrep.nvim](https://github.com/wsdjeg/flygrep.nvim)
  - [format.nvim](https://github.com/wsdjeg/format.nvim)
  - [git.vim](https://github.com/wsdjeg/git.nvim)
  - [iedit.vim](https://github.com/wsdjeg/iedit.nvim)
  - [nvim-plug](https://github.com/wsdjeg/nvim-plug)
  - [quickfix.nvim](https://github.com/wsdjeg/quickfix.nvim)
  - [record-key.nvim](https://github.com/wsdjeg/record-key.nvim)
  - [vim-todo](https://github.com/wsdjeg/vim-todo)
  - [winbar.nvim](https://github.com/wsdjeg/winbar.nvim)
  - [xmake.vim](https://github.com/wsdjeg/xmake.vim)
