#!/usr/bin/env sh

# apt
if command -v apt &> /dev/null; then
  sudo apt update
  sudo apt upgrade
fi

# cargo
cargo install-update -a

# uv
uv self update

# brew
if command -v brew &> /dev/null; then
	brew bundle check || brew bundle install
  brew update
  brew upgrade
  # check for differences
  brew bundle cleanup
fi

