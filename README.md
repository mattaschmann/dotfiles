# Dotfiles

Personal dotfiles managed by `pkgctl`. Cross-platform: macOS and WSL2/Linux.

## Quick Start

```bash
# New machine — full setup (prerequisites, symlinks, packages)
./bootstrap.sh install

# Just update packages
./bootstrap.sh update
```

## Package Management

All configuration lives in [`packages.toml`](packages.toml) — the single source of truth for packages, symlinks, shell steps, and prerequisites.

`pkgctl` is the CLI that operates on this manifest:

```bash
pkgctl install                 # full setup: doctor + links + shell + copies + update
pkgctl update [MANAGER...]     # upgrade + ensure declared packages installed
pkgctl drift [MANAGER...]      # report untracked/missing packages
pkgctl diff [MANAGER...]       # show pending upstream changes (opencode plugins)
pkgctl link                    # apply symlinks only
pkgctl clean                   # remove dead symlinks
pkgctl doctor                  # check prerequisites
pkgctl list [MANAGER]          # print what's in packages.toml
pkgctl brewfile                # generate Brewfile from packages.toml
```

Run it via `uv run pkgctl <command>` or `./bootstrap.sh <command>`.

Flags: `--json` (structured output for agents), `--dry-run`, `--packages-file PATH`.

Managers: `apt`, `brew`, `cargo`, `uv`, `npm`, `opencode`, `vscode`.

## OS-variant file convention

Files with `{os}` in their path are resolved by platform. pkgctl detects the current OS (`osx`/`wsl`/`linux`), checks if a matching variant file exists on disk, and links it. No per-platform config repetition needed:

```toml
"~/.urlview" = { path = "urlview/{os}.urlview" }
```

## Weekly Update

Run the weekly system update routine through the `weekly-update` opencode skill. It wraps `pkgctl` with interactive drift cleanup, opencode plugin security review, and error debugging.

## Bootstrap (new machine)

1. Clone this repo
2. `./bootstrap.sh install` — installs uv if missing, then runs full setup

## Layout

| Path | Purpose |
|------|---------|
| `src/pkgctl/` | CLI tool (Python 3.13 + click + dotbot) |
| `packages.toml` | Declarative manifest (packages, links, shell, doctor) |
| `pyproject.toml` | uv project definition |
| `bootstrap.sh` | Ensures uv, proxies to pkgctl |
| `nvim/`, `zsh/`, `tmux/`, `alacritty/`, `starship/`, `tig/`, `rg/` | App configs |
| `opencode/` | opencode global config (symlinked to `~/.config/opencode/`) |
| `scripts/` | Legacy helpers (deprecated) |
