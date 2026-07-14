# General

## Do
- Save tokens by being terse with responses
- use `rg` instead of `grep` when possible
- use `fd` instead of `find` when possible
- use `exa` instead of `ls` when possible

## Don't
- Run extra steps in a `.tasks/**` task without user confirmation
- Run `git add` — the user stages files themselves; only run `git commit` when asked

# Skills

## Do
- Use this spec to format skills: https://agentskills.io/specification

# Code Practices

- **DRY (strictly enforced)**: Never duplicate logic, helpers, types, or
  constants. Before writing a function, search for an existing implementation.
  If two modules need the same behavior, extract a shared utility and import it
  everywhere. If two places ever disagree about the same fact, collapse them to
  a single source of truth rather than patching one copy. Treat DRY violations
  as bugs.
- **Libraries first (strictly enforced)**: Before writing any non-trivial
  infrastructure (routing, validation, parsing, scheduling, retries, state
  management, algorithms), search for an established, well-maintained library
  that solves the problem. Building a homespun version when a standard library
  exists is treated as a bug. If unsure whether a library exists, search or
  ask — don't default to writing it from scratch.
- **Best practices by default**: Follow established practices (separation of
  concerns, proper error handling, typed APIs, input validation) at all times.
  Don't reinvent or ignore them.
- **Small modules**: Keep files small and focused. A file growing past ~350
  lines is a smell, not a hard limit — factor related functions into a new
  module when it makes sense, or justify the size with a comment.
- **Single responsibility**: Each module does one thing. Don't mix concerns
  like HTTP routing with state management, or business logic with persistence.
- **Shared constants/conventions**: If a convention exists (IDs, field names,
  matching logic), define it once in a shared location and import it everywhere.
- **No hardcoded magic strings**: Don't hardcode IDs, labels, or lookup values.
  Accept them as parameters from the caller.
- **Use a logger, not raw console**: Route application logging through the
  project's logger/logging library, not raw `console.log`/`print`/stderr
  scattered through the code.

## Code Documentation

Add doc comments ONLY where they help a reader (human or LLM) navigate faster.
The goal is fewer exploratory reads, not comprehensive documentation.

**Where to add docs (high ROI):**
- Module/file headers — one line: what this module owns and what it exports.
- Non-obvious invariants and units — encodings, coordinate systems, cumulative
  vs. absolute values, anything a reader can't infer from the code.
- Cross-layer contracts — what one layer guarantees vs. what another may assume.
- "Why," not "what" — rationale the code alone can't convey.

**Where NOT to add docs (negative ROI):**
- Never restate signatures or types the language/schema already enforces.
- No trivial getter/setter comments.
- No comments that just rephrase the function name.
- One-line summaries max; never multi-paragraph.

**A doc that contradicts the code is a bug** — worse than no doc, because a
reader may trust prose over code.

# Maintaining These Instructions

Local `AGENTS.md` files must stay specific to their project — architecture,
data model, stack choices, naming conventions, commands, project-specific
gotchas. General coding practices live here in the global config, never
duplicated per project.

When you notice a general, project-agnostic coding practice being added to (or
proposed for) a local `AGENTS.md` — something that would apply to any codebase,
not just the current one — stop and recommend promoting it to the global config
instead. Confirm with the user before moving it. Keep local files for
project-specific rules only.

# Project Steering Discovery

When working in a project, look for additional steering from these recognized
sources. Only read files not already supplied by your client's native discovery:

- Root and nested `AGENTS.md` files
- `.kiro/steering/**/*.md`
- `.claude/rules/**/*.md`
- `.github/instructions/**/*.instructions.md`

**Rules:**
- If a file has frontmatter with `paths`, `applyTo`, or `inclusion` metadata,
  apply it only when working on files that match those patterns.
- Project-local guidance takes precedence over this global file when they
  conflict.
- Do NOT ingest as steering: skills (`**/SKILL.md`), agent profiles, commands,
  settings/config files, hooks, generated state, lock files, or arbitrary
  Markdown that is not in a recognized steering location.
- Do NOT duplicate content your client already loads natively (e.g., OpenCode
  reads `AGENTS.md` automatically; Claude reads `CLAUDE.md` and `.claude/rules/`
  automatically; Kiro reads `.kiro/steering/` and `AGENTS.md` automatically).
