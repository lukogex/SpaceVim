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
  - [Docker Image](#docker-image)
  - [Can I try spacevim without overwriting my vim configuration?](#can-i-try-spacevim-without-overwriting-my-vim-configuration)
- [Configuration](#configuration)
- [Learning Spacevim](#learning-spacevim)

<!-- vim-markdown-toc -->

## Installation

First of all, you need to [install Neovim](posts/2017-02-20-install-vim-or-neovim-with-python-support.md), preferably with `+python3` support enabled.
Also, you need to have `git` and `curl` installed in your system, which are needed for downloading plugins and fonts.
If you are using a terminal emulator, you will need to set the font in the terminal configuration.

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

You can symling the start script into a place in your $PATH.
`ln -s $spacevimBaseDir/scripts/svim.sh $HOME/.local/bin/svim.sh`

### Docker Image

This Dockerfile builds neovim `HEAD` and installs the latest available version of spacevim.

You might want to use this for several reasons:
- Have a consistent version of Neovim and spacevim as long as the machine supports Docker.
- Try spacevim without modifying your current Vim/Neovim configuration.
- Try the latest Neovim with spacevim.
- Try spacevim with a newer version of Python.
- Debug spacevim configurations. e.g. when posting a bug report if you can reproduce it in this container then there's a higher chance that it is a true bug and not just an issue with your machine.
- During the build we call `dein#install()` so all plugins are installed and frozen.
  Your custom configurations can be added as an additional build step using the Docker `COPY` command.

You can build using the supplied `Makefile`:
`make build-docker`

You can run the container using:
`docker run -it nvim`
More useful is mounting the current working directory inside the container:
`docker run -it -v $(pwd):/home/spacevim/src nvim`

### Can I try spacevim without overwriting my vim configuration?

If you want to have a try spacevim without overwriting your own Neovim configuration you can:

Clone spacevim manually.

```sh
git clone git@github.com:lukogex/spacevim.git ~/.spacevim
```

The start it with the make command `make -C ~/.spacevim/ run`.

## Configuration

The default configuration file of spacevim is `~/.spacevim.d/init.toml`.
This is an example for basic usage of spacevim.
For more info, please check out [documentation](_index.md) and [available layers](layers/_index.md).

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

If you want to use vim script to configure spacevim, please check out the [bootstrap function](_index.md#bootstrap-functions) section.

If there are errors in your `init.toml`, the setting will not be applied. See [FAQ](faq.md#why-are-the-options-in-toml-file-not-applied).
There should be only one `[options]` section in `init.toml`.

## Learning Spacevim

- [Spacevim Documentation](_index.md).
  The Spacevim Documentation will introduce you to the main topics important to using Spacevim.
- [Hack-spacevim](https://github.com/Gabirel/Hack-spacevim).
  Teaches you how to hack Spacevim.
