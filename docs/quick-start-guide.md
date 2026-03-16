---
title: "Quick start guide"
description: "A quick start guide which will tell you how to install and configure spacevim, also provides a list of resources for learning spacevim."
---

# Quick start guide

This is a quick start guide for spacevim. It will show you how to install,
configure, and use spacevim. It also lists a series of resources for learning spacevim.

If you've never heard of spacevim, this is the best place to start.
It will give you a good idea of what spacevim is like.

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
  - [Linux and macOS](#linux-and-macos)
  - [How to install spacevim manually?](#how-to-install-spacevim-manually)
  - [Can I try spacevim without overwriting my vimrc?](#can-i-try-spacevim-without-overwriting-my-vimrc)
- [Configuration](#configuration)
- [Learning spacevim](#learning-spacevim)
- [User experiences](#user-experiences)

<!-- vim-markdown-toc -->

## Installation

First of all, you need to [install Neovim](posts/2017-02-20-install-vim-or-neovim-with-python-support.md), preferably with `+python3` support enabled.
Also, you need to have `git` and `curl` installed in your system, which are needed for downloading plugins and fonts.
If you are using a terminal emulator, you will need to set the font in the terminal configuration.

### Linux and macOS

```bash
curl -sLf https://spacevim.org/install.sh | bash
```

After spacevim is installed launch `spacevim`, all plugins will be downloaded **automatically**.

For more info about the install script, please check:

```bash
curl -sLf https://spacevim.org/install.sh | bash -s -- -h
```

By default the latest version of spacevim will be installed.
If you want to switch to specific version, for example `v1.8.0`, run following command in your terminal.

```
cd ~/.spacevim
git checkout v1.8.0
```

If you got a vimproc error like this:

```
[vimproc] vimproc's DLL: "~/.spacevim/bundle/vimproc.vim/lib/vimproc_linux64.so" is not found.
```

Please read `:help vimproc` and make it, you may need to install make (from `build-essential`)
and a C compiler (like `gcc`) to build the dll.

### How to install spacevim manually?

The following section will document how to install spacevim manually on Linux.
First, you need to clone the repository to `~/.spacevim`.

```
git clone https://spacevim.org/git/repos/spacevim/ ~/.spacevim
```

Then, backup your old Neovim/Vim configuration file:

```
mv ~/.vimrc ~/.vimrc_back
mv ~/.vim ~/.vim_back
mv ~/.config/nvim ~/.config/nvim_back
```

Link `~/.spacevim` to Vim and Neovim user folder:

```
ln -s ~/.spacevim ~/.vim
ln -s ~/.spacevim ~/.config/nvim
```

### Can I try spacevim without overwriting my vimrc?

The spacevim install script will move your `~/.vimrc` to `~/.vimrc_back`. If you want to have a try spacevim without
overwriting your own Vim configuration you can:

Clone spacevim manually.

```sh
git clone https://spacevim.org/git/repos/spacevim/ ~/.spacevim
```

Then, start Vim via `vim -u ~/.spacevim/vimrc`. You can also put this alias into your bashrc.

```sh
alias svim='vim -u ~/.spacevim/vimrc'
```

## Configuration

The default configuration file of spacevim is `~/.spacevim.d/init.toml`.
This is an example for basic usage of spacevim.
For more info, please check out [documentation](../documentation/) and [available layers](../layers/).

```toml
# This is a basic configuration example for spacevim

# All spacevim options are below [options] snippet
[options]
    # set spacevim theme. by default colorscheme layer is not loaded,
    # if you want to use more colorscheme, please load the colorscheme
    # layer, the value of this option is a string.
    colorscheme = "gruvbox"
    colorscheme_bg = "dark"
    # Disable guicolors in basic mode, many terminal do not support 24bit
    # true colors, the type of the value is boolean, true or false.
    enable_guicolors = true
    # Disable statusline separator, if you want to use other value, please
    # install nerd fonts
    statusline_separator = "nil"
    statusline_iseparator = "bar"
    buffer_index_type = 4
    # Display file type icon on the tabline, If you do not have nerd fonts
    # installed, please change the value to false
    enable_tabline_filetype_icon = true
    # Display current mode text on statusline, by default It is disabled,
    # only color will be changed when switch modes.
    enable_statusline_mode = false

# Enable autocomplete layer
[[layers]]
    name = "autocomplete"
    auto-completion-return-key-behavior = "complete"
    auto-completion-tab-key-behavior = "cycle"

[[layers]]
    name = "shell"
    default_position = "top"
    default_height = 30

# This is an example for adding custom plugins lilydjwg/colorizer
[[custom_plugins]]
    repo = "lilydjwg/colorizer"
    merged = false
```

If you want to use vim script to configure spacevim, please check out the
[bootstrap function](../documentation/#bootstrap-functions) section.

If there are errors in your `init.toml`, the setting will not be applied. See [FAQ](../faq/#why-are-the-options-in-toml-file-not-applied). There should be only one `[options]` section in `init.toml`.

## Learning spacevim

- [spacevim Documentation](../documentation).
  The spacevim Documentation will introduce you to the main topics important to using spacevim.
- [Hack-spacevim](https://github.com/Gabirel/Hack-spacevim). Teaches you how to hack spacevim.

## User experiences

Here is a list of User experiences about using spacevim:

- [Vim as an IDE, not the text editor](https://blog.ghaiklor.com/2019/10/12/vim-as-an-ide-not-the-text-editor/) - Eugene Obrezkov
