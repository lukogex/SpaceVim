[Quick Start Guide](docs/quick-start-guide.md) \|
[Documentation](docs/documentation.md) \|
[Layers](docs/layers/)

# spacevim

The [spacevim project](https://github.com/wsdjeg/spacevim) originated in December 2016 and stopped maintenance on February 21, 2025.
Main Maintainer was [Eric Wong](https://github.com/wsdjeg).

spacevim is a modular configuration of Vim and Neovim.
It's inspired by Spacemacs.
It manages collections of plugins in layers, which help to collect related packages together to provide features.
This approach helps keep the configuration organized and reduces overhead for the user by keeping them from having to think about what packages to install.

## Forked Project

I use spacevim as my main editor and really love it.
Thus I decided to give it a try to proceed with the project on my own.
One consequence of this is that I'll reduce the project scope and features to the ones I'm using, mainly due to the limited time I have.

### Compatibility

In contrast to the former spacevim distribution the new version supports only [Neovim](https://github.com/neovim/neovim) and Linux.
I'm not sure about [Neovim QT](https://github.com/equalsraf/neovim-qt) and how much effort this is, I'll keep related configs by now.

Reasoning:
- I cant spare additional time to implement and test for other systems.
- I used spacevim with Vim for quite some time and had a lot of troubles, Neovim simply works far better.

### Credits

This project wouldn't exist without the work from Eric Wong and all the people who contributed.
Please check the [origin project](https://github.com/wsdjeg/spacevim) for further details.

## Features

The following features from origin spacevim implementation remains as goals:

- **Modularization:** Plugins and functions are organized in [layers](docs/layers/).
- **Great documentation:** ~~Online documentation~~ and `:h spacevim`.
  By now the "online documentation" are the markdown files in the Github repository.
- **Better experience:** Rewrite core plugins using lua.
- **Beautiful UI:** The interface has been carefully designed.
- **Mnemonic key bindings:** Key binding guide will be displayed automatically
- **Fast boot time:** Lazy-load 90% of plugins with [dein.vim](https://github.com/Shougo/dein.vim)
- **Lower the risk of RSI:** Heavily using the `<Space>` key instead of modifiers.
- **Consistent experience:** Consistent experience between terminal and gui.

**User Interface**

![spacevim user interface](docs/img/spacevim-demo-ui.png)

**IDE Example**

- colorscheme: one
- windows: Git remotes, outline, Todos, Code runner, Terminal, file explore.
- code completion engine: nvim-cmp

![spacevim ide](docs/img/spacevim-demo-ide.png)

## Project Layout

As the focus is on [Neovim](https://neovim.io/) we structure it after [Neovim plugin templates](https://github.com/ellisonleao/nvim-plugin-template).

```txt
├─ .ci/                           build automation
├─ .github/                       issue/PR templates
├─ .spacevim.d/                   project specific configuration
├─ after/                         overrule or add to the distributed defaults
├─ autoload/spacevim.vim          spacevim core file
├─ autoload/spacevim/api/         Public APIs
├─ autoload/spacevim/layers/      available layers
├─ autoload/spacevim/plugins/     builtin plugins
├─ autoload/spacevim/mapping/     mapping guide
├─ colors/                        default colorscheme
├─ docker/                        docker image generator
├─ bundle/                        bundle plugins
├─ lua/spacevim/plugin            builtin plugins(lua)
├─ doc/                           help
├─ docs/                          documentation
└─ test/                          tests
```
