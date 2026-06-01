#!/usr/bin/env bash
set -uo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_FILE="$BASEDIR/packages.toml"
BREWFILE="$BASEDIR/Brewfile"

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

: > "$BREWFILE"

taps=$(parse_toml_list "brew" "taps")
if [ -n "$taps" ]; then
  while IFS= read -r tap; do
    echo "tap \"$tap\"" >> "$BREWFILE"
  done <<< "$taps"
fi

formulae=$(parse_toml_list "brew" "formulae")
if [ -n "$formulae" ]; then
  while IFS= read -r pkg; do
    echo "brew \"$pkg\"" >> "$BREWFILE"
  done <<< "$formulae"
fi

casks=$(parse_toml_list "brew" "casks")
if [ -n "$casks" ]; then
  while IFS= read -r pkg; do
    echo "cask \"$pkg\"" >> "$BREWFILE"
  done <<< "$casks"
fi

echo "Brewfile generated at $BREWFILE"
