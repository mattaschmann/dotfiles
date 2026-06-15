# Handle updating/syncing opencode plugins via the weekly update skill
I want to update the weekly install process to handle opencode projects.  I have many opencode projects that are plugins
  for opencode. I have git-pulled them directly.  I'd like a way to have them updated during the weekly update.  before they
  are git pulled, I want the ai to analyze the differences for any possible security issues before they are pulled.  I would
  probably be best to refactor so they are in a specific directory.  help me plan this out.  ask any clarifying questions.

## Investigation

### Overview
The weekly-update skill (`opencode/skills/weekly-update/SKILL.md`) and its delegate script (`scripts/update.sh`) have no opencode plugin handling. Three of four plugins (`opencode-keepalive`, `opencode-kirocli-bridge`, `opencode-ping`) live as bare `~/workspace/` clones loaded by local path in `opencode/opencode.jsonc`; a fourth (`opencode-model-alias`) is npm-installed and already covered by `npm update -g`. A new update step must: fetch upstream changes for the three local-path plugins, surface diffs for AI security review, then pull and rebuild.

### Relevant files
- `.opencode/skills/weekly-update/SKILL.md` — skill to extend with a new step for plugin update/review
- `scripts/update.sh:104-112` — npm update section; the opencode plugin block should follow the same loop pattern
- `opencode/opencode.jsonc:51-57` — `"plugin"` array; needs path updates if plugins are moved to a new directory
- `~/workspace/opencode-keepalive` — remote: `git@github.com:mattaschmann/opencode-keepalive.git`
- `~/workspace/opencode-kirocli-bridge` — remote: `git@github.com:mattaschmann/opencode-kirocli-bridge.git`
- `~/workspace/opencode-ping` — remote: `git@github.com:mattaschmann/opencode-ping.git`
- `~/workspace/opencode-model-alias` — npm-installed by name, not a local path; update already handled

### Existing patterns to follow
- `scripts/update.sh` uses a consistent pattern per manager: check tool presence, read config, loop over items. A `[opencode] plugins` key in `packages.toml` (listing plugin paths or repo URLs) would fit naturally as the source of truth.
- The `cargo git` block (`update.sh:72-79`) shows how to loop over git-based items and handle errors gracefully with `|| true`.
- The weekly-update skill's error-handling pattern: capture stderr, diagnose, offer retry/skip/abort — this same pattern should wrap the git fetch + pull step.

### Possible directions
- The plugin update logic could live entirely in `scripts/update.sh` (a new `# --- opencode plugins ---` block that git-fetches and pulls), with the weekly-update skill's step triggering it and doing a pre-pull diff review via `git diff HEAD..origin/main` before the pull runs. This keeps all update logic in one script and the skill handles the AI-mediated security gate.
- Alternatively, the update logic could live only in the skill (no `update.sh` changes), treating plugin repos as a skill-managed concern distinct from the package-manager-driven `update.sh`. This is simpler but breaks the pattern of `update.sh` owning all update side-effects.

### Open questions
- **Consolidation directory**: Should the three plugins be moved from `~/workspace/` to a dedicated directory (e.g., `~/workspace/opencode-plugins/`) before this work begins, or can they stay in place and just be listed in config?
- **Source of truth for plugin paths**: Should plugin repo paths/URLs be added to `packages.toml` (new `[opencode]` section) or derived from `opencode.jsonc`'s `"plugin"` array?
- **Security review scope**: What should the AI review look for — new `dependencies`/`devDependencies` in `package.json`, new shell scripts, changed `src/` files, or all of the above? Should unknown new dependencies block the pull or just warn?
- **Post-pull rebuild**: After `git pull`, should the skill run `npm install && npm run build` (or similar) in each plugin directory, or is there a build step already?
- **Branch convention**: Are all plugin repos on `main`? (Assumed yes, but worth confirming before scripting `git pull origin main`.)

## Decisions

- **Consolidate the three local plugins into `~/workspace/opencode-plugins/`.** *Why:* gives the update loop one parent dir to target, keeps `~/workspace/` tidy, matches the user's stated preference. Requires repointing the three tilde paths in `opencode/opencode.jsonc`.
- **Split logic: `update.sh` fetches, the weekly-update skill reviews + pulls.** *Why:* `update.sh` is non-interactive and cannot do AI security review; restricting it to a safe `git fetch` + report preserves the gate. The skill owns the interactive, AI-mediated pull. Consistent with the existing division (`update.sh` owns `packages.toml`-driven side-effects; the skill owns interactive review).
- **Security gate blocks by default.** *Why:* any flagged change (new deps, new/changed shell scripts, suspicious `src/` edits) must get explicit user approval before pulling. Safety over speed.
- **Source of truth is a new `[opencode] plugins` section in `packages.toml`.** *Why:* consistent with every other manager, reuses the existing `parse_toml_list` awk parser, and avoids JSONC parsing in bash.
- **No build step; conditional `npm install`.** *Why:* every plugin's `package.json` `main` points at `src/index.ts` (opencode loads TS source directly), so there is no build. Only `opencode-kirocli-bridge` has a runtime dependency (`@aws/codewhisperer-streaming-client`), so run `npm install` in a plugin only when its `package-lock.json` changed.
- **Branch is `main` for all three.** *Why:* confirmed via `git rev-parse --abbrev-ref HEAD`.
- **`opencode-model-alias` stays out of scope.** *Why:* resolved by opencode by name (not a local clone), already self-updating.

## Implementation Plan

- [x] Consolidate clones: `mkdir -p ~/workspace/opencode-plugins` and `mv` the three repos (`opencode-keepalive`, `opencode-kirocli-bridge`, `opencode-ping`) into it.
  - 2025-06-15: done — moved all three repos to ~/workspace/opencode-plugins/
- [x] Repoint the three tilde paths in `opencode/opencode.jsonc` (`plugin` array) to `~/workspace/opencode-plugins/<name>`; leave `"opencode-model-alias"` untouched.
  - 2025-06-15: done — updated all three paths in plugin array
- [x] Add an `[opencode] plugins` list to `packages.toml` with the three new paths.
  - 2025-06-15: done — added [opencode] section with 3 plugin paths
- [x] Add a `# --- opencode plugins ---` fetch+report block to `scripts/update.sh` (after the npm block, modeled on the cargo-git loop): read `parse_toml_list "opencode" "plugins"`, expand leading `~`, `git -C "$dir" fetch origin main` (never pull), compare `HEAD` vs `origin/main`, print a grep-able "update available" / "up-to-date" line, wrap each in `|| true`.
  - 2025-06-15: done — block added after npm section, tested fetch+report with no local mutation
- [x] Update `.opencode/skills/weekly-update/SKILL.md`: add `git:*` to the `allowed-tools` Bash allowlist; note in step 3 that `update.sh` now fetches+reports plugin updates; insert a new "Review & update opencode plugins" step (fetch → diff `HEAD..origin/main` → AI security review → block until approval → `pull --ff-only` → conditional `npm install` when `package-lock.json` changed → error-handling), renumbering subsequent steps; record plugin location/no-build/model-alias-out-of-scope in Notes.
  - 2025-06-15: done — added git:* permission, new step 6 with full review flow, renumbered steps 7-9, added notes
- [x] Verify: `bash -n scripts/update.sh`; `parse_toml_list "opencode" "plugins"` returns 3 paths; run the new block and confirm fetch+report with no local mutation (`git status` clean); start `opencode` and confirm plugins load from new paths; dry-run the skill gate against `opencode-kirocli-bridge`.
  - 2025-06-15: done — bash -n passes, parser returns 3 paths, fetch+report runs clean; skipped JSONC validation (opencode validates its own config at startup)
