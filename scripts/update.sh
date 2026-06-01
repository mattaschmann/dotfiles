#!/usr/bin/env bash
set -uo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_FILE="$BASEDIR/packages.toml"

parse_toml_list() {
  local section="$1"
  local key="$2"
  [ -f "$PACKAGES_FILE" ] || return
  awk -v section="$section" -v key="$key" '
    /^\[/ { in_section = ($0 == "[" section "]"); next }
    in_section && $0 ~ "^"key" *=" { reading = 1; next }
    reading && /^]/ { reading = 0; next }
    reading && /^\[/ { exit }
    reading && /"/ {
      gsub(/^[^"]*"/, "")
      gsub(/"[^"]*$/, "")
      if ($0 != "") print
    }
  ' "$PACKAGES_FILE"
}

# --- apt (Linux) ---
if command -v apt &> /dev/null; then
  if sudo -n true 2>/dev/null; then
    echo "==> Updating apt packages..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y

    echo "==> Ensuring apt packages from packages.toml..."
    apt_packages=$(parse_toml_list "apt" "install")
    if [ -n "$apt_packages" ]; then
      echo "$apt_packages" | xargs sudo apt install -y
    fi
  else
    echo "==> Skipping apt (sudo not available without password prompt)"
    echo "    Run 'sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y' manually."
  fi
fi

# --- brew (macOS) ---
if command -v brew &> /dev/null; then
  echo "==> Generating Brewfile..."
  "$BASEDIR/scripts/generate-brewfile.sh"

  echo "==> Installing/updating brew packages..."
  brew bundle check --file="$BASEDIR/Brewfile" || brew bundle install --file="$BASEDIR/Brewfile"
  brew update
  brew upgrade
  brew cleanup
  brew autoremove
fi

# --- cargo ---
if command -v cargo &> /dev/null; then
  echo "==> Updating Rust toolchain..."
  rustup update

  if ! command -v cargo-binstall &> /dev/null; then
    echo "==> Installing cargo-binstall..."
    cargo install cargo-binstall
  fi

  echo "==> Installing/updating cargo packages..."
  cargo_packages=$(parse_toml_list "cargo" "install")
  if [ -n "$cargo_packages" ]; then
    echo "$cargo_packages" | xargs cargo binstall -y
  fi

  cargo_git=$(parse_toml_list "cargo" "git")
  if [ -n "$cargo_git" ]; then
    echo "==> Installing/updating cargo git packages..."
    while IFS= read -r repo; do
      cargo install --git "$repo" 2>/dev/null || true
    done <<< "$cargo_git"
  fi

  echo "==> Checking for cargo updates..."
  cargo install-update -a

  echo "==> Cleaning cargo cache..."
  cargo cache --autoclean
fi

# --- uv ---
if command -v uv &> /dev/null; then
  echo "==> Updating uv..."
  uv self update

  echo "==> Installing/updating uv tools..."
  uv_packages=$(parse_toml_list "uv" "install")
  if [ -n "$uv_packages" ]; then
    while IFS= read -r pkg; do
      uv tool install "$pkg" 2>/dev/null || true
    done <<< "$uv_packages"
  fi
  uv tool upgrade --all
  uv cache prune
fi

# --- npm ---
if command -v npm &> /dev/null; then
  echo "==> Updating global npm packages..."
  npm update -g

  npm_packages=$(parse_toml_list "npm" "install")
  if [ -n "$npm_packages" ]; then
    echo "$npm_packages" | xargs npm install -g
  fi
fi

# --- vscode ---
if command -v code &> /dev/null; then
  echo "==> Installing VS Code extensions..."
  vscode_extensions=$(parse_toml_list "vscode" "extensions")
  if [ -n "$vscode_extensions" ]; then
    while IFS= read -r ext; do
      code --install-extension "$ext" --force 2>/dev/null || true
    done <<< "$vscode_extensions"
  fi
fi

echo "==> Update complete."
