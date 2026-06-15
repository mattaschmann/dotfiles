# Cross-client task handoff: add an `implement-task` skill and wire the research → analyze → implement → wrap pipeline

## Goal

I want to work on a single project seamlessly across **Claude Code and OpenCode**, using the `.tasks/*.md` file as the shared handoff store (no MCP server, no `/export` copy-paste). Each phase runs in a specific client/model, and the task file carries all state between them so a fresh agent in the other client can pick up where the last one left off.

Target pipeline:

| Skill | Model | Client | Job |
|---|---|---|---|
| `research-task` | cheap | Claude | Autonomous recon → `## Investigation` (already exists, no change wanted) |
| `analyze-task` | expensive | Claude | Interview + plan + decisions; **should NOT implement** |
| `implement-task` | OpenCode model | **OpenCode** | Resume from the file → execute the plan → journal progress (NEW) |
| `wrap-task` | expensive | Claude | Verify the implementation against the plan + decisions |

The Claude → OpenCode handoff happens at the implement step. The wrap step comes back to Claude so the same model that analyzed verifies the work.

## What I want built

1. **New `implement-task` skill** (runs in OpenCode):
   - Front half = resume/load: discover the in-flight task file (don't rely on prior-session memory), read it in full, and reconstruct working context from `## Investigation`, `## Decisions`, and the `## Implementation Plan`. Emit a compact checkpoint (goal · decisions · done · next · blockers · key files).
   - Back half = execute: walk the checkbox plan one item at a time, flip `- [ ]` → `- [x]`, and append a one-line progress note per step (success and failure).
   - No interview (the analyst model isn't present). Blocker policy: proceed + log on low-stakes calls; on anything ambiguous/high-stakes, stop and append a `## Blockers` note so it bounces back to Claude/`analyze-task` instead of guessing.

2. **Modify `analyze-task`**:
   - Remove the "execute deliberately" step — execution now belongs to `implement-task`. Analyze stops at a complete, persisted plan.
   - Add a `## Decisions` section that captures the interview outcomes + rationale (the *why* behind each plan item). This is what survives the cross-client hop, since the chat transcript does not.

3. **Modify `wrap-task`**:
   - Treat cross-session/cross-client as the norm: always rediscover the task file from `.tasks/` and read state from the file, not session memory.
   - Verify the diff against the documented `## Decisions` and journaled progress notes; flag deviations.

## Constraints / notes

- All skills follow the agentskills.io spec (per my global config). Verify `implement-task` actually loads under OpenCode's conventions — OpenCode's plugin/tool model differs from Claude's `SKILL.md` (no `Task`/`TodoWrite`), so it may need an OpenCode-native variant or location.
- Skills live in `~/.claude/skills/` for Claude; confirm where the OpenCode-consumable version belongs (likely under `~/.config/opencode/`).
- The `.task` file is the handoff contract. After `analyze-task` it must be self-sufficient for a fresh OpenCode agent: `goal → ## Investigation → ## Decisions → ## Implementation Plan`.

## Background

This came out of evaluating whether to use/build an MCP server (`shared-context-mcp`) for cross-agent context sharing. Conclusions: an MCP server can't reproduce the native "same session" feel (it can only hand an agent content to read, not inject prior turns); sharing raw session state is blocked by format incompatibility (Claude JSONL vs OpenCode SQLite); the robust approach is a rich-checkpoint, sequential handoff through a neutral human-readable file — which the existing `.tasks/` skill workflow already is. This task completes that workflow for the cross-client case.

Please dig into the existing `research-task`, `analyze-task`, and `wrap-task` skills before planning, and ask any clarifying questions.

## Decisions

- **Skills are shared, not per-client.** `~/.claude/skills` and `~/.config/opencode/skills` both symlink to `opencode/skills/` (`install.conf.yaml`). So `implement-task` is a single `SKILL.md` consumed by both clients — no separate OpenCode variant. *Why:* avoids duplicating the skill (DRY) and the symlink already makes it visible in both clients.
- **OpenCode invocation = `build`-agent command.** Add `opencode/commands/implement-task.md` running `skill({ name: "implement-task" })` bound to the `build` agent. *Why:* mirrors the existing `commands/analyze-task.md` pattern; `build` (temp 0.15) has real code-edit permission, unlike `plan`. No `opencode.jsonc` change needed — edits are allowed by default; only `bash` is gated globally.
- **OpenCode-only toolset for `implement-task`.** Allowed-tools limited to `Bash(exa/rg/fd) Read Edit Write Grep Glob` — no `Task`/`TodoWrite`/`Question` (OpenCode lacks them). *Why:* the skill runs unattended in OpenCode.
- **Canonical handoff contract / section order:** `## Investigation` → `## Decisions` → `## Implementation Plan` → `## Checkpoint` → `## Blockers`. `## Decisions` is authored by `analyze-task` and is the *why* that survives the client hop (chat transcript does not).
- **Journal format = inline notes under checkboxes.** One indented dated note per item (`  - 2026-06-15: done — …`), reusing analyze-task's existing failure-note convention. *Why:* keeps state co-located with each item so `wrap-task` reads it in place.
- **Checkpoint = persisted + printed.** `implement-task` refreshes a single `## Checkpoint` section in place (goal · decisions · done · next · blockers · key files) and also prints it to chat. *Why:* durable latest-state snapshot for the next agent; inline notes carry history.
- **Blocker policy:** low-stakes/ambiguous → proceed using `## Decisions` as guidance and log the choice; high-stakes/irreversible/contradicts-decisions → stop, leave item unchecked, append `## Blockers` to bounce back to Claude/`analyze-task`. No guessing.
- **`analyze-task` stops at a persisted plan** (remove its step 8 "Execute deliberately"); execution belongs to `implement-task`.
- **`wrap-task` treats cross-client as the norm:** always rediscover the task file from `.tasks/` (no session/`TodoWrite` reliance) and verify the diff against `## Decisions` + journal notes, flagging deviations.

## Implementation Plan

- [x] Create `opencode/skills/implement-task/SKILL.md` — frontmatter (`name`, `description`, `allowed-tools: Bash(exa:*) Bash(rg:*) Bash(fd:*) Read Edit Write Grep Glob`) + agentskills.io body. Front half: rediscover in-flight `.tasks/` file (ignore `DONE-`), read fully, reconstruct from `## Investigation`/`## Decisions`/`## Implementation Plan`/inline notes, write+print `## Checkpoint`. Back half: execute checkboxes one at a time, flip `- [ ]`→`- [x]`, append inline dated note. Blocker policy → `## Blockers`. Boundaries: no interview, no `Task`/`TodoWrite`, read-only on Investigation/Decisions.
  - 2026-06-15: done — created 69-line SKILL.md with full workflow, blocker policy, and boundaries
- [x] Create `opencode/commands/implement-task.md` — mirror `commands/analyze-task.md`, `agent: build`, body `skill({ name: "implement-task" })`.
  - 2026-06-15: done — created with agent: build, temperature: 0.15
- [x] Edit `opencode/skills/analyze-task/SKILL.md` — drop "executes steps…" from frontmatter description; remove step 8; insert a `## Decisions` authoring step (outcomes + rationale) persisted above `## Implementation Plan`; renumber; update Notes & Tips to end at a persisted plan + hand off to `implement-task`.
  - 2026-06-15: done — step 8 removed, new step 6 (Persist decisions) added, step 9 (Hand off) added, notes updated with section-order contract
- [x] Edit `opencode/skills/wrap-task/SKILL.md` — step 1 always rediscover from `.tasks/` (drop `TodoWrite`/session reliance); read `## Decisions` + inline notes when loading state; step 4a verify diff against `## Decisions` + journal and flag deviations + surface `## Blockers`; fix the "same session as analyze-task" note.
  - 2026-06-15: done — step 1 uses exa discovery, step 2 reads all sections, step 4a cross-refs Decisions + journals + blockers, final note updated
- [x] Contract check (task-specific; fold into the `wrap-task` pass): confirm the four `SKILL.md` files agree on section order (`## Investigation → ## Decisions → ## Implementation Plan → ## Checkpoint → ## Blockers`) and the identical inline-note format, and that `~/.config/opencode/skills/implement-task/SKILL.md` resolves via the existing symlink. Generic review (diff vs decisions/journal, tests, lint, completeness, docs, practices) is handled by `wrap-task` itself.
  - 2026-06-15: done — symlinks resolve at both ~/.config/opencode/skills/ and ~/.claude/skills/, section order consistent across all skills
