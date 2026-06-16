# Dotfiles

Personal dotfiles managed by [DotBot](https://github.com/anishathalye/dotbot) and `pkgctl`. Cross-platform: macOS and WSL2/Linux.

## Quick Start

```bash
# New machine — installs uv, then runs all package managers
./bootstrap.sh update

# Set up symlinks + run updates
./install
```

## Package Management

All packages are declared in [`packages.toml`](packages.toml) — the single source of truth across apt, brew, cargo, uv, npm, vscode, and opencode plugins.

`pkgctl` is the CLI that operates on this manifest:

```bash
pkgctl update [MANAGER...]     # upgrade + ensure declared packages installed
pkgctl drift [MANAGER...]      # report untracked/missing packages
pkgctl diff [MANAGER...]       # show pending upstream changes (opencode, dotbot)
pkgctl list [MANAGER]          # print what's in packages.toml
pkgctl brewfile                # generate Brewfile from packages.toml
```

Run it via `uv run pkgctl <command>` or `./bootstrap.sh <command>`.

Flags: `--json` (structured output for agents), `--dry-run`, `--packages-file PATH`.

Managers: `apt`, `brew`, `cargo`, `uv`, `npm`, `opencode`, `vscode`, `dotbot`.

## Weekly Update

Run the weekly system update routine (packages, zsh plugins via `antidote`, tmux plugins via TPM) through the `weekly-update` opencode skill. It wraps `pkgctl` with interactive drift cleanup, opencode plugin security review, and error debugging.

## Bootstrap (new machine)

1. Clone this repo
2. `./bootstrap.sh update` — installs uv if missing, then runs all package managers
3. `./install` — sets up symlinks and triggers the update

## Layout

| Path | Purpose |
|------|---------|
| `src/pkgctl/` | Package management CLI (Python 3.13 + click) |
| `packages.toml` | Declarative package manifest |
| `pyproject.toml` | uv project definition |
| `bootstrap.sh` | Ensures uv, proxies to pkgctl |
| `install.conf.yaml` | DotBot config (symlinks + shell hooks) |
| `dotbot/` | DotBot submodule |
| `nvim/`, `zsh/`, `tmux/`, `alacritty/`, `starship/`, `tig/`, `rg/` | App configs |
| `opencode/` | opencode global config (symlinked to `~/.config/opencode/`) |
| `scripts/` | Legacy helpers (deprecated) |
