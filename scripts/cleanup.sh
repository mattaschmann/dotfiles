#!/usr/bin/env bash
set -uo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_FILE="$BASEDIR/packages.toml"

parse_toml_list() {
  local section="$1"
  local key="$2"
  [ -f "$PACKAGES_FILE" ] || return
  awk -v section="$section" -v key="$key" '
    function extract_values(line) {
      while (match(line, /"[^"]*"/)) {
        val = substr(line, RSTART + 1, RLENGTH - 2)
        if (val != "") print val
        line = substr(line, RSTART + RLENGTH)
      }
    }
    /^\[/ { in_section = ($0 == "[" section "]"); next }
    in_section && $0 ~ "^"key" *=" {
      line = $0
      sub("^"key" *= *", "", line)
      if (match(line, /^\[.*\]$/)) {
        extract_values(line)
      } else {
        extract_values(line)
        reading = 1
      }
      next
    }
    reading && /^]/ { reading = 0; next }
    reading && /^\[/ { exit }
    reading && /"/ { extract_values($0) }
  ' "$PACKAGES_FILE"
}

filter_known() {
  local section="$1"
  local key="$2"
  local known
  known=$(parse_toml_list "$section" "$key" | sed 's/\[.*$//')
  local ignored
  ignored=$(parse_toml_list "$section" "ignore")
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    local skip=0
    if [ -n "$known" ]; then
      while IFS= read -r pkg; do
        if [ -n "$pkg" ] && [ "$line" = "$pkg" ]; then
          skip=1
          break
        fi
      done <<< "$known"
    fi
    if [ "$skip" -eq 0 ] && [ -n "$ignored" ]; then
      while IFS= read -r pkg; do
        if [ -n "$pkg" ] && [ "$line" = "$pkg" ]; then
          skip=1
          break
        fi
      done <<< "$ignored"
    fi
    if [ "$skip" -eq 0 ]; then
      echo "$line"
    fi
  done
}

# --- Brew ---
echo "=== Brew Drift ==="
if command -v brew &> /dev/null; then
  if [[ "$(uname)" == "Darwin" ]]; then
    BREW_OS="osx"
  else
    BREW_OS="linux"
  fi

  installed_formulae=$(brew leaves 2>/dev/null)
  installed_casks=$(brew list --cask -1 2>/dev/null)

  os_formulae=$(parse_toml_list "brew.${BREW_OS}" "formulae")
  os_casks=$(parse_toml_list "brew.${BREW_OS}" "casks")

  new_formulae=$(echo "$installed_formulae" | filter_known "brew" "formulae")
  if [ -n "$os_formulae" ]; then
    new_formulae=$(echo "$new_formulae" | while IFS= read -r line; do
      echo "$os_formulae" | grep -qxF "$line" || [ -z "$line" ] || echo "$line"
    done)
  fi
  new_casks=$(echo "$installed_casks" | filter_known "brew" "casks")
  if [ -n "$os_casks" ]; then
    new_casks=$(echo "$new_casks" | while IFS= read -r line; do
      echo "$os_casks" | grep -qxF "$line" || [ -z "$line" ] || echo "$line"
    done)
  fi

  if [ -n "$new_formulae" ]; then
    echo "Formulae installed but not in packages.toml:"
    echo "$new_formulae"
  fi
  if [ -n "$new_casks" ]; then
    echo "Casks installed but not in packages.toml:"
    echo "$new_casks"
  fi
  if [ -z "$new_formulae" ] && [ -z "$new_casks" ]; then
    echo "(none)"
  fi
else
  echo "(brew not available)"
fi

# --- Cargo ---
echo ""
echo "=== Cargo Drift ==="
if command -v cargo &> /dev/null; then
  installed_cargo=$(cargo install --list 2>/dev/null | grep -E '^\w' | sed 's/ .*//')
  cargo_git_repos=$(parse_toml_list "cargo" "git")
  cargo_git_names=""
  if [ -n "$cargo_git_repos" ]; then
    cargo_git_names=$(echo "$cargo_git_repos" | sed 's|.*/||')
  fi
  new_cargo=$(echo "$installed_cargo" | filter_known "cargo" "install")
  if [ -n "$cargo_git_names" ]; then
    new_cargo=$(echo "$new_cargo" | while IFS= read -r line; do
      skip=0
      while IFS= read -r gname; do
        [ -n "$gname" ] && [ "$line" = "$gname" ] && skip=1 && break
      done <<< "$cargo_git_names"
      [ "$skip" -eq 0 ] && [ -n "$line" ] && echo "$line"
    done)
  fi
  if [ -n "$new_cargo" ]; then
    echo "Crates installed but not in packages.toml:"
    echo "$new_cargo"
  else
    echo "(none)"
  fi
else
  echo "(cargo not available)"
fi

# --- uv ---
echo ""
echo "=== uv Drift ==="
if command -v uv &> /dev/null; then
  installed_uv=$(uv tool list 2>/dev/null | grep -v '^-' | sed 's/ .*//')
  new_uv=$(echo "$installed_uv" | filter_known "uv" "install")
  if [ -n "$new_uv" ]; then
    echo "Tools installed but not in packages.toml:"
    echo "$new_uv"
  else
    echo "(none)"
  fi
else
  echo "(uv not available)"
fi

# --- npm ---
echo ""
echo "=== npm Drift ==="
if command -v npm &> /dev/null; then
  installed_npm=$(npm list -g --depth=0 2>/dev/null | tail -n +2 | sed 's/[├└─┬│ ]//g' | sed 's/@.*//g' | grep -v '^$')
  new_npm=$(echo "$installed_npm" | filter_known "npm" "install")
  if [ -n "$new_npm" ]; then
    echo "Packages installed but not in packages.toml:"
    echo "$new_npm"
  else
    echo "(none)"
  fi
else
  echo "(npm not available)"
fi

# --- opencode plugins ---
echo ""
echo "=== Opencode Plugin Drift ==="
opencode_plugins=$(parse_toml_list "opencode" "plugins")
if [ -n "$opencode_plugins" ]; then
  plugin_drift=0
  while IFS= read -r dir; do
    dir="${dir/#\~/$HOME}"
    name=$(basename "$dir")
    if [ ! -d "$dir" ]; then
      echo "MISSING (directory does not exist): $name  [$dir]"
      plugin_drift=1
    elif [ ! -d "$dir/.git" ]; then
      echo "NOT A GIT REPO: $name  [$dir]"
      plugin_drift=1
    fi
  done <<< "$opencode_plugins"
  [ "$plugin_drift" -eq 0 ] && echo "(none)"
else
  echo "(no plugins configured)"
fi
