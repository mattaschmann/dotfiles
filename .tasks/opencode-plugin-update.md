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
