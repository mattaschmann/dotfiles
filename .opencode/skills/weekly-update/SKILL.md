---
name: weekly-update
description: Runs the weekly system update routine — package managers, zsh plugins, tmux plugins — with interactive cleanup and error debugging. Use when the user asks to run their weekly update, system update, or mentions updating packages.
allowed-tools: Bash(brew:*,apt:*,sudo:*,antidote:*,npm:*,uv:*,cargo:*,rustup:*) Read Edit Write Question
---

## Purpose

Automate the weekly dotfiles update routine. Run package updates, plugin updates, detect drift, and help the user decide what to keep or remove. Catch and debug errors at each step.

## Workflow

1. **Detect platform & handle sudo** – Determine if running on macOS (brew) or Linux (apt). If on Linux, check if `sudo -n true` succeeds. If it does NOT:
   - STOP immediately. Tell the user to run this in their terminal: `sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install -y build-essential cmake libssl-dev pkg-config` (check packages.toml for the current list)
   - Use the Question tool to wait for the user to confirm they've done it (or want to skip apt).
   - Only proceed to the next step after they confirm.

2. **Check prerequisites** – Verify the following are available. If any are missing, stop and tell the user what to install:
   - `brew` (macOS) or `apt` (Linux)
   - `antidote` (zsh plugin manager)
   - TPM at `~/.tmux/plugins/tpm/bin/update_plugins` (tmux plugin manager)
   - `npm` (Node package manager)
   - `cargo` and `rustup` (Rust toolchain) — optional, skip if missing
   - `uv` (Python tool manager) — optional, skip if missing

3. **Run dotbot install** – Execute `./install` from the dotfiles repo root. This triggers symlinks and runs `scripts/update.sh` which reads `packages.toml` and handles all package managers:
   - Generates the Brewfile from `packages.toml`, then runs brew bundle/update/upgrade
   - Bootstraps `cargo-binstall` if missing, installs/updates all cargo crates (binary download with compile fallback)
   - Installs/updates uv tools
   - Installs/updates global npm packages
   - Installs VS Code extensions (if `code` is available)

   IMPORTANT: Use a long timeout (900000ms+) for this step — brew upgrades can take a while.

   If this step fails, capture the error output, diagnose the issue, and present the user with:
   - What went wrong (parse the error)
   - Suggested fix
   - Option to retry or skip

4. **Update zsh plugins** – Run `antidote update`. On failure, report the error and suggest fixes (e.g. network issues, missing repos).

5. **Update tmux plugins** – Run `~/.tmux/plugins/tpm/bin/update_plugins all`. On failure, report the error.

6. **Detect drift** – Run `scripts/cleanup.sh` from the dotfiles repo root. This compares what's installed against `packages.toml` and shows packages that are:
   - Installed but not tracked in `packages.toml` (for each manager: brew, cargo, uv, npm)

   For each drifted package, ask the user:
   - Add it to `packages.toml` (track it)
   - Add it to the ignore list in `packages.toml`
   - Remove it

7. **Execute decisions** – Based on user input:
   - Add packages to the appropriate section in `packages.toml` via Edit tool
   - `brew uninstall <pkg>`
   - `npm uninstall -g <pkg>`
   - `uv tool uninstall <tool>`
   - `cargo uninstall <crate>`

8. **Summary** – Report what was updated, what drift was found, what was added/removed/ignored, and any errors that were skipped.

## Error Handling

At every step, if a command fails:
- Capture stderr and stdout
- Parse the error for known patterns (network timeout, permission denied, missing dependency, version conflict)
- Present a clear diagnosis to the user
- Offer options: retry, skip this step, or abort
- On Linux, if a command fails with permission errors, suggest re-running with sudo

## Notes & Tips

- On Linux, `apt` commands require sudo. Prompt the user before running privileged commands.
- The `./install` script must be run from the dotfiles repo root.
- `packages.toml` is the single source of truth for all packages across all managers.
- The `Brewfile` is auto-generated from `packages.toml` by `scripts/generate-brewfile.sh` — do not edit it directly.
- Cargo crates are installed via `cargo binstall` (downloads pre-built binaries when available, compiles as fallback).
- Neovim plugin updates are intentionally excluded — the user handles those manually.
- See `scripts/update.sh` for the full update logic.
