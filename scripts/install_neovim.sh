#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C

install_nvim() {
    local URL=https://github.com/neovim/neovim
    local tag=$1
    local tmp="$(mktemp -d)"
    local out="${DEPS}/_neovim/$tag"
    mkdir -p $out
    if [[ $tag == "nightly" ]]; then
      curl  -o $tmp/nvim-linux-x86_64.tar.gz -L "https://github.com/neovim/neovim/releases/download/$tag/nvim-linux-x86_64.tar.gz"
      tar -xzvf $tmp/nvim-linux-x86_64.tar.gz -C $tmp
      cp -r $tmp/nvim-linux-x86_64/* $out
    else
      curl  -o $tmp/nvim-linux64.tar.gz -L "https://github.com/neovim/neovim/releases/download/$tag/nvim-linux64.tar.gz"
      tar -xzvf $tmp/nvim-linux64.tar.gz -C $tmp
      cp -r $tmp/nvim-linux64/* $out
    fi
    chmod +x $out/bin/nvim
    # fix ModuleNotFoundError: No module named 'setuptools'
    python3 -m pip install -U setuptools
    python3 -m pip install pynvim
}

install() {
    local vim=$1
    local tag=$2

    if [[ -d "${DEPS}/_$vim/$tag/bin" ]]; then
        echo "Use a cached version '$HOME/_$vim/$tag'."
        return
    fi
    if [[ $vim == "nvim" ]]; then
        install_nvim $tag
    else
        echo "Only Neovim is supported from version v3.0.0 onwards."
    fi
}

install $@
