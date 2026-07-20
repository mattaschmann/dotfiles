---
name: weekly-update
description: Runs the weekly system update routine — package managers, zsh plugins, tmux plugins — with interactive cleanup and error debugging. Use when the user asks to run their weekly update, system update, or mentions updating packages.
allowed-tools: Bash(brew:*,apt:*,sudo:*,antidote:*,npm:*,uv:*,cargo:*,rustup:*,git:*) Read Edit Write Question
---

## Purpose

Automate the weekly dotfiles update routine. Run package updates, plugin updates, detect drift, and help the user decide what to keep or remove. Catch and debug errors at each step.

## Workflow

1. **Detect platform & handle sudo** – Determine if running on macOS (brew) or Linux (apt). If on Linux, check if `sudo -n true` succeeds. If it does NOT:
   - STOP immediately. Read the `[apt] install` list from `packages.toml` and tell the user to run: `sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt install -y <packages from packages.toml>`
   - Use the Question tool to wait for the user to confirm they've done it (or want to skip apt).
   - Only proceed to the next step after they confirm.

2. **Check prerequisites** – Verify the following are available. If any are missing, stop and tell the user what to install:
   - `brew` (macOS) or `apt` (Linux)
   - `antidote` (zsh plugin manager) — NOTE: antidote is a shell function, not a binary. Check with `brew --prefix antidote` (or look for `/home/linuxbrew/.linuxbrew/opt/antidote` on Linux). Do NOT use `which antidote`.
   - TPM at `~/.tmux/plugins/tpm/bin/update_plugins` (tmux plugin manager)
   - `uv` (Python tool manager)
   - `cargo` and `rustup` (Rust toolchain) — optional, skip if missing

3. **Run pkgctl install** – Execute `uv run pkgctl install` from the dotfiles repo root. This runs the full setup:
    - Checks prerequisites (`pkgctl doctor`)
    - Applies symlinks via dotbot (reads `[install.links]` from packages.toml)
    - Runs shell steps (terminfo compilation)
    - Generates the Brewfile from `packages.toml`, then runs brew bundle/update/upgrade
    - Bootstraps `cargo-binstall` if missing, installs/updates all cargo crates
    - Installs/updates uv tools
    - Installs/updates global npm packages
    - Installs VS Code extensions (if `code` is available)
    - Note: opencode plugins are intentionally NOT updated here — `pkgctl install` skips the `opencode` manager in code; plugins are only ever reviewed and updated in step 6.

   IMPORTANT: Use a long timeout (900000ms+) for this step — brew upgrades can take a while.

   If this step fails, capture the error output, diagnose the issue, and present the user with:
   - What went wrong (parse the error)
   - Suggested fix
   - Option to retry or skip

4. **Update zsh plugins** – Run antidote update. Since `antidote` is a shell function (not a binary), invoke it via: `source $(brew --prefix antidote)/share/antidote/antidote.zsh && antidote update`. On failure, report the error and suggest fixes (e.g. network issues, missing repos).

5. **Update tmux plugins** – Run `~/.tmux/plugins/tpm/bin/update_plugins all`. On failure, report the error.

6. **Review & update opencode plugins** – Use `pkgctl` for structured plugin review:

   a. Run `uv run pkgctl --json diff opencode` to get structured diff data.
   b. For each plugin with `"status": "behind"`:
      - Read the commits list and files changed.
      - If `"has_dependency_changes": true`, flag this for extra scrutiny.
      - Run `git -C <plugin_dir> diff HEAD..origin/main` to get the full diff text.
      - **AI security review**: Analyze the diff for:
        - New or changed dependencies in `package.json` / `package-lock.json`
        - New or modified shell scripts
        - Suspicious patterns (obfuscation, network calls to unknown hosts, credential access)
      - Present findings to the user. If any concerns are flagged, **block the pull** until the user explicitly approves.
   c. If approved (or no concerns), run `uv run pkgctl update opencode`.
   d. For any plugin where `has_dependency_changes` was true, run `npm install` in that plugin directory.
   e. On failure: report the error, offer retry/skip/abort.

7. **Detect drift** – Run `uv run pkgctl --json drift` from the dotfiles repo root. Parse the JSON output:

   **Package drift** (per manager: brew, cargo, uv, npm):
   For each drifted package, ask the user:
   - Add it to `packages.toml` (track it)
   - Add it to `packages.ignore.toml` (local, gitignored)
   - Remove it

   **Opencode plugin drift** (tracked in `packages.toml` but directory missing or not a git repo):
   For each drifted plugin, ask the user:
   - Clone it (user must supply the repo URL, then run `git clone <url> <dir>`)
   - Remove it from `packages.toml`
   - Skip / handle manually

8. **Execute decisions** – Based on user input:
   - Add packages to the appropriate section in `packages.toml` via Edit tool
   - `brew uninstall <pkg>`
   - `npm uninstall -g <pkg>`
   - `uv tool uninstall <tool>`
   - `cargo uninstall <crate>`
   - For opencode plugins: `git clone <url> <dir>` or remove the entry from `packages.toml` via Edit tool

9. **Summary** – Report what was updated, what drift was found, what was added/removed/ignored, and any errors that were skipped.

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
- The `Brewfile` is auto-generated by `pkgctl brewfile` — do not edit it directly.
- Cargo crates are installed via `cargo binstall` (downloads pre-built binaries when available, compiles as fallback).
- Neovim plugin updates are intentionally excluded — the user handles those manually.
- Opencode plugins live in `~/workspace/opencode-plugins/`. They have no build step (opencode loads TS source directly). Only run `npm install` if `package-lock.json` changed.
- `pkgctl` is invoked via `uv run pkgctl <command>` from the dotfiles root (or `./bootstrap.sh <command>`).
- Use `--json` flag for structured output that is easy to parse programmatically.
- Exit codes: 0 = success, 1 = error, 2 = drift/diff found.
