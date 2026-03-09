#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then #osx
  echo "OSX detected"
  export OS_NAME="osx"
elif [[ "$(uname -r)" == *"WSL2" ]]; then #wsl
  echo "WSL detected"
  export OS_NAME="wsl"
fi

ln -fs $(pwd)/alacritty/alacritty.${OS_NAME}.toml ~/.config/alacritty/alacritty.toml
ln -fs $(pwd)/urlview/${OS_NAME}.urlview ~/.urlview
