#!/bin/bash

# Make this work when called over a symlink in a $PATH location.
basePath=$(readlink -f $0)
baseDir=$(dirname $basePath)
spacevimBaseDir=$(dirname $baseDir)
spacevimConfigDir=$HOME/.spacevim.d

# Temporary run which locates all custom configuration inside $tmpDir to not influence any system configuration.
tmpRun=${1-false}
tmpDir=$spacevimBaseDir/.tmp

# Change directory first to use correct tool versions.
cd $spacevimBaseDir

if [[ "$tmpRun" = "true" ]]; then
  xdgConfigHome=$tmpDir/.config
  spacevimConfigDir=$tmpDir/.spacevim.d
  mkdir -p $tmpDir $xdgConfigHome $spacevimConfigDir
  ln -s $spacevimBaseDir $xdgConfigHome/nvim
elif [[ -z "${XDG_CONFIG_HOME}" ]]; then
  # TODO: This can be changed when I dont use Spacevim 2.5.0 anymore.
  # Change the config dir to not import the default Neovim one where SpaceVim 2.5.0 is located.
  # It always uses "nvim" subdirectory which means we need a different parent location (`~/.lukogex/~/.config`).
  # Using `nvim -u ~/workspace/lukogex/spacevim/init.vim` still loads config from neovim default directory.
  xdgConfigHome=$HOME/.lukogex/~/.config
  # xdgConfigHome=$HOME/.config
  spacevimConfigDir=$HOME/.spacevim.d
else
  xdgConfigHome=$XDG_CONFIG_HOME
  # When XDG_CONFIG_HOME is set it also place the custom config there, eg. `~/.lukogex/~/.config/spacevim.d`.
  # Not sure yet how to set it up finally, by now I think this is too much changing of locations depending on environemnt variables.
  # Might be better to have always the same place and user can decide to tweak it by symlinks.
  # By now i want to have custom config in user home like before which can be set by SPACEVIMDIR.
  spacevimConfigDir=$HOME/.spacevim.d
fi

export XDG_CONFIG_HOME=$xdgConfigHome
export SPACEVIMDIR=$spacevimConfigDir
nvim
