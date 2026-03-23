#!/usr/bin/env sh
# apt
if command -v apt &> /dev/null; then
  sudo apt update
  sudo apt upgrade
  sudo apt autoremove
fi

# brew
if command -v brew &> /dev/null; then
	brew bundle check || brew bundle install
  brew update
  brew upgrade
  # check for differences
  brew bundle cleanup
fi

# cargo
if command -v cargo &> /dev/null; then
  rustup update
  cargo install-update -a
fi

# uv
if command -v uv &> /dev/null; then
  uv self update
fi

# ollama
$HOME/.dotfiles/ollama/update_ollama_images.sh
