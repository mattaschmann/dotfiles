#!/usr/bin/env bash
set -uo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGES_FILE="$BASEDIR/packages.toml"
BREWFILE="$BASEDIR/Brewfile"

if [[ "$(uname)" == "Darwin" ]]; then
  OS_NAME="osx"
else
  OS_NAME="linux"
fi

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

: > "$BREWFILE"

taps=$(parse_toml_list "brew" "taps")
os_taps=$(parse_toml_list "brew.${OS_NAME}" "taps")
all_taps=$(printf '%s\n%s' "$taps" "$os_taps" | sort -u | grep -v '^$')
if [ -n "$all_taps" ]; then
  while IFS= read -r tap; do
    echo "tap \"$tap\"" >> "$BREWFILE"
  done <<< "$all_taps"
fi

formulae=$(parse_toml_list "brew" "formulae")
os_formulae=$(parse_toml_list "brew.${OS_NAME}" "formulae")
all_formulae=$(printf '%s\n%s' "$formulae" "$os_formulae" | sort -u | grep -v '^$')
if [ -n "$all_formulae" ]; then
  while IFS= read -r pkg; do
    echo "brew \"$pkg\"" >> "$BREWFILE"
  done <<< "$all_formulae"
fi

casks=$(parse_toml_list "brew" "casks")
os_casks=$(parse_toml_list "brew.${OS_NAME}" "casks")
all_casks=$(printf '%s\n%s' "$casks" "$os_casks" | sort -u | grep -v '^$')
if [ -n "$all_casks" ]; then
  while IFS= read -r pkg; do
    echo "cask \"$pkg\"" >> "$BREWFILE"
  done <<< "$all_casks"
fi

echo "Brewfile generated at $BREWFILE"
