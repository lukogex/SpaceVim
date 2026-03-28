#!/bin/bash

# Temporary run which locates all custom configuration inside $tmpDir to not influence any system configuration.
file=${1-.}
tmpRun=${2-false}
debug=${3-false}

# Make this work when called over a symlink in a $PATH location.
basePath=$(readlink -f $0)
baseDir=$(dirname $basePath)
spacevimBaseDir=$(dirname $baseDir)
spacevimConfigDir=$HOME/.spacevim.d

tmpDir=$spacevimBaseDir/.tmp

if [[ "$tmpRun" = "true" ]]; then
  # Change directory to use correct tool versions.
  cd $spacevimBaseDir

  xdgConfigHome=$tmpDir/.config
  spacevimConfigDir=$tmpDir/.spacevim.d
  mkdir -p $tmpDir $xdgConfigHome $spacevimConfigDir
  ln -sfn $spacevimBaseDir $xdgConfigHome/nvim
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

if [[ "$debug" = "true" ]]; then
  echo Script parameters:
  echo file=$file
  echo tmpRun=$tmpRun
  echo debug=$debug

  echo Script variables:
  echo basePath=$basePath
  echo baseDir=$baseDir
  echo spacevimBaseDir=$spacevimBaseDir
  echo spacevimConfigDir=$spacevimConfigDir
  echo tmpDir=$tmpDir
  echo xdgConfigHome=$xdgConfigHome
  echo spacevimConfigDir=$spacevimConfigDir

  env
fi

nvim $file
