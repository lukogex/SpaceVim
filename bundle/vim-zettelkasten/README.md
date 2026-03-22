# vim-zettelkasten

> _vim-zettelkasten_ is a [Zettelkasten](https://zettelkasten.de) note taking plugin, which is forked from [zettelkasten.nvim@fe174666](https://github.com/Furkanzmc/zettelkasten.nvim/tree/fe1746666e27c2fcc0e60dc2786cb9983b994759).

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Usage](#usage)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Install

1. Using `vim-zettelkasten` in spacevim:

```toml
[[layers]]
  name = 'zettelkasten'
  zettel_dir = 'D:\me\zettelkasten'
  zettel_template_dir = 'D:\me\zettelkasten_template'
```

2. Using `vim-zettelkasten` without spacevim:

```vim
Plug 'wsdjeg/vim-zettelkasten'
let g:zettelkasten_directory = 'D:\me\zettelkasten'
let g:zettelkasten_template_directory = 'D:\me\zettelkasten_template'
```

## Usage

**Commands:**

| Command           | description                       |
| ----------------- | --------------------------------- |
| `:ZkNew`          | create new note                   |
| `:ZkBrowse`       | list note in browser window       |
| `:ZkListTags`     | filter tags in telescope          |
| `:ZkListTemplete` | filte note templates in telescope |
| `:ZkListNotes`    | filte note title in telescope     |

**Key bindings in browser window:**

| key bindings    | description                        |
| --------------- | ---------------------------------- |
| `F2`            | open zettelkasten tags sidebar     |
| `<LeftRelease>` | filter notes based on cursor tag   |
| `gf`            | open the note                      |
| `Ctrl-l`        | clear tags filter pattarn          |
| `Ctrl-] / K`    | preview note in vim preview-window |
| `[I`            | list references in quickfix-window |

## Feedback

The development of this plugin is in [`spacevim/bundle/vim-zettelkasten`](https://github.com/spacevim/spacevim/tree/master/bundle/vim-zettelkasten) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/spacevim/spacevim/issues)
