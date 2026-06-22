# Replace tmux with Zellij

Investigate and implement a migration from tmux to Zellij as the terminal multiplexer. Goals:

- Same general workflow: splits, windows/tabs, vim-style navigation
- Colored borders on all sides (including outer frame) indicating focused pane
- Floating windows for yazi file explorer (and potentially other tools)
- Theme similar to current custom dark scheme (dark bg, cyan/green/yellow accents)
- Session save/restore (equivalent to tmux-resurrect)
- Evaluate whether current TPM plugins (tmux-urlview, tmux-resurrect) have Zellij equivalents or are unnecessary

## Investigation

### Current tmux setup (to replicate)

**Plugins:**
- `tmux-plugins/tmux-resurrect` — session save/restore
- `tmux-plugins/tmux-urlview` — extract/open URLs from pane output

**Key bindings to replicate:**
- `prefix + '` / `prefix + -` — horizontal/vertical split (keeping cwd)
- `prefix + h/j/k/l` — vim-style pane nav
- `prefix + c` — new window (keeping cwd)
- `prefix + o` — break pane to own window
- `prefix + a` — join pane from another window
- `prefix + backtick` — last window toggle
- `prefix + =` — synchronize panes
- `prefix + <` — rename window to basename of cwd
- `Shift-Left/Right` — swap window position
- Mouse enabled, vi copy mode

**Theme (custom.tmuxtheme):**
- Dark bg (`colour235`), cyan status text, yellow active border, green/yellow status segments
- No external theme plugin

**Other settings:**
- `escape-time 10`, `focus-events on`, `allow-passthrough` (yazi images)
- True color via `terminal-overrides`
- Default shell `/bin/zsh`

### Zellij equivalents

| tmux feature | Zellij equivalent |
|---|---|
| TPM + plugins | Built-in plugin system (WASM plugins), no separate plugin manager |
| tmux-resurrect | Built-in session resurrection, **on by default** (`session_serialization true`); `zellij ls` / session-manager |
| tmux-urlview | Not built-in; rely on terminal-native URL detection (dropped) |
| Pane borders | Theme `frame_selected`/`frame_unselected`/`frame_highlight` + `pane_frames true` — full colored frame on all sides |
| Floating panes | Native: built-in Tmux mode + `zellij run --floating --width --height -- <cmd>` |
| Synchronize panes | Dropped (not needed) |
| Swap window position | Tab reordering (Move mode) |
| allow-passthrough | True-color/image passthrough handled by terminal; no special tmux-style flag |
| `Ctrl+b` prefix | Built-in **Tmux mode** already bound to `Ctrl+b` — customize its sub-bindings |

### Relevant files to modify

- `tmux/.tmux.conf` — archive (keep in repo, remove symlink/packages)
- `tmux/custom.tmuxtheme` — archive
- New: `zellij/` directory with `config.kdl` and layout files
- `packages.toml` — swap tmux for zellij in brew/apt, update symlinks, remove TPM doctor check
- `nvim/lua/config/maps.lua:5` — change `tmux split-window "yazi %"` → `zellij run --floating -- yazi <file>`
- `nvim/lua/plugins/nvim-tree.lua:20` — change `tmux split-window yazi <path>` → `zellij run --floating -- yazi <path>`
- `zsh/.zshrc:61-62` — replace `tm`/`ta` aliases with zellij equivalents (`zellij -s`, `zellij attach`)
- `.opencode/skills/weekly-update/SKILL.md` — remove TPM update step
- `AGENTS.md` — update layout section (replace `tmux/` with `zellij/`)
- `README.md` — update layout table
- `terminfo/tmux*.terminfo` — can be left (still useful if any tool emits tmux termtype) or archived

### Open questions

- Should tmux config be kept around (commented/archived) for fallback, or removed entirely?
- Is `synchronize-panes` a must-have or nice-to-have?
- Any preference for Zellij keybinding mode (locked/normal/etc)?

## Decisions

- **Archive tmux config** — keep `tmux/` directory in repo but remove symlinks and package entries from active use. *Why:* easy rollback if Zellij doesn't work out.
- **Drop synchronize-panes** — not needed, skip entirely. *Why:* user never uses it.
- **Use Zellij's built-in Tmux mode (`Ctrl+b` prefix paradigm).** *Why:* closest to literal tmux muscle memory — press `Ctrl+b` then an action key. Extend/customize the default tmux-mode bindings rather than building a locked-mode preset. Keep default `keybinds` (do NOT `clear-defaults`) and override only the tmux-mode block to mirror old prefix bindings (`'` and `-` splits, `c` new tab, `o` break, `h/j/k/l` nav, backtick last-tab).
- **No tmux-urlview replacement needed.** *Why:* modern terminals (Alacritty) handle URL detection natively; reduces complexity. Can add a plugin later if missed.
- **Session resurrection is built-in and on by default** (`session_serialization true`) — no plugin or extra config needed; replaces tmux-resurrect entirely. *Why:* Zellij serializes layout + running commands to cache every second and exposes them via `zellij ls` / session-manager. Optionally enable `pane_viewport_serialization` if scrollback restore is wanted (decide during testing).
- **Floating pane for yazi from the shell** — bind a tmux-mode key (e.g. `Ctrl+b y`) to toggle/launch a floating pane running yazi. *Why:* primary floating-window use case per user request.
- **nvim→yazi integration uses `zellij run --floating`.** *Why:* user chose the minimal direct-swap over the yazi.nvim plugin. Replace `tmux split-window` calls in `maps.lua` and `nvim-tree.lua` with `zellij run --floating -- yazi <path>`. (Tradeoff accepted: selected file won't auto-open back in the running nvim, and the binding only works inside Zellij.)
- **Colored borders via theme `frame_*` components.** *Why:* set `pane_frames true` and define `frame_selected` (active, yellow to match old config), `frame_unselected` (`#444444`), and `frame_highlight` (mode-active) in a custom theme. This draws colored borders on all sides including the outer frame, satisfying the focus-indicator goal.
- **Custom theme palette mirrors `custom.tmuxtheme`:** dark bg ~`#262626` (old `colour235`), cyan/green/yellow status accents, magenta mode highlight, yellow active border, `#444444` inactive border. *Why:* "theme similar" requirement.
- **Keep tmux installed as a package (fallback) but remove its symlink/TPM clone.** *Why:* aligns with "archive" decision — easy rollback without re-adding the package.

## Implementation Plan

- [ ] Add `zellij` to `packages.toml` (brew `[brew.osx] formulae`, apt `[apt] install`) and install locally to experiment
- [ ] Create `zellij/config.kdl`: keep default keybinds (no `clear-defaults`), set `default_mode "normal"`, `pane_frames true`, `mouse_mode true`, `copy_on_select`, `default_shell "/bin/zsh"`, `session_serialization true`
- [ ] Customize the built-in **Tmux mode** (`Ctrl+b` prefix) bindings to mirror old tmux: `'`/`-` splits (keep cwd is default), `c` new tab, `o` break pane to tab, `h/j/k/l` pane focus, backtick last tab
- [ ] Bind `Ctrl+b y` in Tmux mode to launch yazi in a floating pane (`zellij run --floating -- yazi`)
- [ ] Define custom theme in `zellij/config.kdl` (or `zellij/themes/`): dark bg `#262626`, cyan/green/yellow accents, magenta mode highlight; `frame_selected` yellow, `frame_unselected` `#444444`, `frame_highlight` for active mode. Set `theme "<name>"`
- [ ] Update `nvim/lua/config/maps.lua:5` — replace `tmux split-window "yazi %"` with `zellij run --floating -- yazi <current file>`
- [ ] Update `nvim/lua/plugins/nvim-tree.lua:20` — replace `tmux split-window` call with `zellij run --floating -- yazi <node path>`
- [ ] Update `zsh/.zshrc:61-62` — replace `tm`/`ta` aliases with zellij equivalents (`zellij -s <name>` / `zellij attach`)
- [ ] Update `packages.toml` `[install.links]`: add zellij config symlink (`~/.config/zellij` → `zellij/`), remove `~/.tmux.conf` link
- [ ] Update `packages.toml` doctor `dirs`: remove TPM (`~/.tmux/plugins/tpm`) clone entry; keep `tmux` package as fallback
- [ ] Update `.opencode/skills/weekly-update/SKILL.md` — remove the TPM plugin-update step (lines referencing `~/.tmux/plugins/tpm/bin/update_plugins`)
- [ ] Update `AGENTS.md` layout section and `README.md` layout table — replace `tmux/` reference with `zellij/`
- [ ] Run `pkgctl link` (or `pkgctl install`) to apply new symlink; verify zellij config loads (`zellij setup --check`)
- [ ] Test on macOS: true color, italics, yazi image preview in floating pane, vim-style nav, splits keep cwd, session detach/attach + resurrection after quit
- [ ] Decide during testing whether to enable `pane_viewport_serialization` (scrollback restore)
- [ ] (If applicable) Test on WSL2/Linux

## Blockers

*(none — all questions resolved)*
