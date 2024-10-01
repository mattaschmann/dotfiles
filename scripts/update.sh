#!/usr/bin/env sh

# brew
if command -v brew &> /dev/null; then
  brew update
  brew upgrade
fi

# apt
if command -v apt &> /dev/null; then
  sudo apt update
  sudo apt upgrade
fi

# cargo
cargo install-update -a

# antidote
antidote update
