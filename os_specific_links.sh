#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]; then
  echo "OSX detected"
  export OS_NAME="osx"
elif [[ "$(uname -r)" == *"WSL2" ]]; then
  echo "WSL detected"
  export OS_NAME="wsl"
fi

[[ -n "$OS_NAME" ]] && ln -fs "$(pwd)/urlview/${OS_NAME}.urlview" ~/.urlview

if [[ "$OS_NAME" == "wsl" ]]; then
  APPDATA_WSL="$(wslpath "$(cmd.exe /C 'echo %APPDATA%' 2>/dev/null | tr -d '\r')")"
  mkdir -p "$APPDATA_WSL/alacritty"
  cp -f "$(pwd)/alacritty/alacritty.wsl.toml" "$APPDATA_WSL/alacritty/alacritty.toml"
elif [[ "$OS_NAME" == "osx" ]]; then
  ln -fs "$(pwd)/alacritty/alacritty.${OS_NAME}.toml" ~/.config/alacritty/alacritty.toml
fi
