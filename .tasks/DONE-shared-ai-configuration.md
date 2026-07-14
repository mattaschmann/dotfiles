# Share AI instructions and skills across clients

## Goal

Move global, client-neutral AI instructions and Agent Skills out of the
OpenCode-specific directory into a shared `ai/` directory. Link those assets
into OpenCode, Claude Code, and Kiro while keeping client-specific agents,
commands, permissions, and configuration separate.

The resulting layout should distinguish global personal guidance from this
repository's project-specific `AGENTS.md`:

```text
ai/
├── AGENTS.md
└── skills/

AGENTS.md
CLAUDE.md

opencode/
├── agents/
├── commands/
└── opencode.jsonc
```

## Decisions

- **Use `ai/` as the neutral shared directory.** *Why:* it is concise and does not conflict with the client-specific meaning of an `agents/` directory.
- **Keep the root `AGENTS.md` project-specific.** *Why:* it documents this dotfiles repository, while `ai/AGENTS.md` contains personal guidance that applies across projects.
- **Link one global instructions file into every client.** `ai/AGENTS.md` will back OpenCode's `~/.config/opencode/AGENTS.md`, Claude's `~/.claude/CLAUDE.md`, and Kiro's `~/.kiro/steering/AGENTS.md`. *Why:* all three clients can consume the same Markdown guidance through their native discovery paths.
- **Add a root `CLAUDE.md` adapter that imports `AGENTS.md`.** *Why:* OpenCode and Kiro read the repository `AGENTS.md` directly, but Claude Code requires `CLAUDE.md`.
- **Share Agent Skills from `ai/skills/`.** *Why:* OpenCode, Claude Code, and Kiro support the Agent Skills `SKILL.md` format.
- **Keep client-specific agent profiles separate.** *Why:* OpenCode and Claude use different Markdown frontmatter, while Kiro agents are JSON; model, tool, and permission semantics are not portable.
- **Keep existing `allowed-tools` frontmatter in shared skills.** *Why:* it remains useful to clients that support the experimental Agent Skills field; other clients may ignore it.
- **Discover known project instruction directories only.** The global instructions should check root and nested `AGENTS.md`, `.kiro/steering/**/*.md`, `.claude/rules/**/*.md`, and `.github/instructions/**/*.instructions.md` when the active client has not already supplied them. *Why:* these are recognized steering sources; scanning arbitrary client directories could load skills, settings, hooks, generated state, or conflicting configuration as instructions.
- **Respect scoped steering metadata.** Apply files only when frontmatter such as `paths`, `applyTo`, or `inclusion` matches the current work. *Why:* unconditional loading would change the intended scope of project rules.
- **Project-local guidance takes precedence over global guidance.** *Why:* repository conventions must be able to specialize personal defaults.
- **Leave task history untouched.** *Why:* existing `.tasks/` references describe historical paths and should not be rewritten as part of this migration.

## Implementation Plan

- [x] Create `ai/`, move `opencode/AGENTS.md` to `ai/AGENTS.md`, and move `opencode/skills/` to `ai/skills/`.
  - 2026-07-14: done — created ai/ directory; moved AGENTS.md and skills/ from opencode/
- [x] Make shared skill bodies client-neutral: replace OpenCode Plan/Build terminology with capability-based guidance, remove client-specific tool-availability claims, and replace the hardcoded global OpenCode instructions path with generic applicable-instructions wording while retaining `allowed-tools`.
  - 2026-07-14: done — updated analyze-task, research-task, implement-task, wrap-task with generic read-only/write-permission language and removed OpenCode-specific references
- [x] Add generic project steering discovery guidance to `ai/AGENTS.md` for recognized instruction sources, scoped frontmatter, project precedence, deduplication, and exclusions for skills, agents, commands, settings, hooks, generated files, and arbitrary Markdown.
  - 2026-07-14: done — appended "Project Steering Discovery" section with recognized sources, scoping rules, precedence, and exclusions
- [x] Add root `CLAUDE.md` importing the repository's `AGENTS.md`.
  - 2026-07-14: done — created CLAUDE.md with @AGENTS.md import
- [x] Update `[install.links]` in `packages.toml` so OpenCode, Claude Code, and Kiro receive `ai/AGENTS.md` and `ai/skills/`; use `force = true` where an existing real client directory must be replaced.
  - 2026-07-14: done — updated all links to point at ai/; added ~/.kiro/steering/AGENTS.md and ~/.kiro/skills with force=true
- [x] Update root `AGENTS.md` and `README.md` to document `ai/` as shared cross-client assets and `opencode/` as OpenCode-specific configuration.
  - 2026-07-14: done — updated Layout sections in both files
- [x] Validate skills with `skillcheck ai/skills --target-agent all --skip-ref-check`.
  - 2026-07-14: done — 5 passed, 0 failed (previously 3 failed)
- [x] Validate links with `uv run pkgctl link --dry-run`, apply them with `uv run pkgctl link`, and verify all six global instruction/skill links resolve to `ai/`.
  - 2026-07-14: done — pkgctl link succeeded; all 6 symlinks (opencode, claude, kiro × instructions + skills) resolve to ai/
- [x] Run `git diff --check` and review the final diff without modifying historical or unrelated task files.
  - 2026-07-14: done — no whitespace errors; diff is limited to expected files

## Checkpoint

**Goal:** Move global AI instructions and skills from `opencode/` to a neutral `ai/` directory, linked into OpenCode, Claude Code, and Kiro.
**Key decisions:**
- `ai/` is the neutral umbrella
- Root `AGENTS.md` stays project-specific
- One global instructions file linked to all three clients
- Root `CLAUDE.md` adapter imports `AGENTS.md`
- Skills shared from `ai/skills/`; `allowed-tools` retained
- Discover known project steering dirs only
- Leave task history untouched
**Done:** all 9 items
**Next:** none — plan complete
**Blockers:** none
**Key files:** `ai/AGENTS.md`, `ai/skills/`, `packages.toml`, `CLAUDE.md`, `AGENTS.md`, `README.md`

## Notes

- Keep `.opencode/skills/weekly-update/` project-specific; it belongs to this dotfiles repository rather than the global skill set.
- Keep `opencode/agents/`, `opencode/commands/`, and `opencode/opencode.jsonc` under `opencode/`.
- Restart OpenCode and Kiro after changing global configuration. Restart Claude Code if it does not detect the moved top-level directories in the current session.
