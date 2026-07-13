# Remove the deprecated `scripts/` directory

Now that `pkgctl` fully replaces the legacy shell scripts, remove the `scripts/`
directory and update the docs that reference it.

## Context / rationale

- `scripts/` is already marked legacy in `AGENTS.md:40` and `README.md:66`.
- No live code references these scripts — only `.tasks/DONE-*` history files
  mention them.
- Replacement map:
  - `scripts/update.sh` -> `pkgctl update` / `pkgctl install`
  - `scripts/cleanup.sh` -> `pkgctl drift`
  - `scripts/generate-brewfile.sh` -> `pkgctl brewfile`
- `scripts/switch_node.sh` is obsolete: global npm packages are retained
  declaratively via `[npm] install` in `packages.toml` + `pkgctl update`. The
  script's snapshot-then-reinstall trick (`npm list -g > /tmp/... ; xargs npm
  install -g`) is redundant. New node-switch flow: `fnm install <ver> &&
  fnm default <ver>`, then `pkgctl update` to restore globals into the new
  version.
- `scripts/piget.sh` / `scripts/piput.sh` are standalone SCP helpers with a
  hardcoded Pi IP (`192.168.1.66`), unreferenced anywhere.

## Checklist

- [ ] Delete all 6 scripts and remove the now-empty `scripts/` directory:
      `update.sh`, `cleanup.sh`, `generate-brewfile.sh`, `switch_node.sh`,
      `piget.sh`, `piput.sh`.
- [ ] Remove the `scripts/` row from `README.md:66` and the `scripts/` bullet
      from the Layout section of `AGENTS.md:40`.
- [ ] Verify no dangling references: `rg -n "scripts/" --glob '!.tasks/**'`.
- [ ] Verify `pkgctl install` still runs clean.

## Notes

- If you later switch Node versions, use `fnm default <ver>` + `pkgctl update`
  to restore global npm packages (declared in `packages.toml [npm] install`).
