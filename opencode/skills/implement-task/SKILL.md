---
name: implement-task
description: Resumes an analyzed `.tasks/` file, reconstructs context from persisted sections, and executes the implementation plan one checkbox at a time with inline progress notes. Use when the user wants to implement a planned task.
allowed-tools: Bash(exa:*) Bash(rg:*) Bash(fd:*) Read Edit Write Grep Glob
---

## Purpose

Execute an implementation plan that was authored by `analyze-task`. This skill picks up from the task file alone — no prior session context required. It walks the checkbox plan, makes code changes, and journals progress inline so `wrap-task` can verify later.

## Workflow

1. **Discover the task** –
   - Run `exa -l --sort=modified .tasks/`. Eligible files: any `*.md` not prefixed with `DONE-`.
   - If exactly one eligible file exists, use it.
   - If multiple exist, use the most recently modified unless the user named one.
   - If none exist, report and stop.
2. **Absorb context** – Read the task file in full. Extract:
   - Goal (top-level prose)
   - `## Investigation` (recon findings, relevant files, patterns)
   - `## Decisions` (rationale and constraints from the analyst interview)
   - `## Implementation Plan` (the checkbox items)
   - Any existing `## Checkpoint` or inline progress notes from a prior run.
3. **Write checkpoint** – Upsert a `## Checkpoint` section (replace if exists, create if not) containing:
   ```
   ## Checkpoint

   **Goal:** <one-line goal>
   **Key decisions:** <bullet list of decision summaries>
   **Done:** <list of completed items or "none">
   **Next:** <next unchecked item>
   **Blockers:** <any current blockers or "none">
   **Key files:** <files most relevant to current work>
   ```
   Also print this checkpoint to chat output.
4. **Execute the plan** – For each unchecked `- [ ]` item, in order:
   - a. Understand what the item requires (read relevant code, check decisions).
   - b. Implement the change.
   - c. Flip `- [ ]` → `- [x]` in the task file.
   - d. Append an indented dated note beneath the item:
     `  - YYYY-MM-DD: done — <one-line summary of what was done>`
   - e. On failure: leave as `- [ ]`, append:
     `  - YYYY-MM-DD: failed — <what went wrong>`
     Then apply blocker policy (step 5).
   - f. Update `## Checkpoint` after each item.
5. **Blocker policy** –
   - **Low-stakes / ambiguous but covered by Decisions:** proceed, log the choice in the inline note.
   - **High-stakes / irreversible / contradicts Decisions:** stop immediately. Leave the item unchecked. Append a `## Blockers` section:
     ```
     ## Blockers

     - <date>: <item description> — <why this needs human/analyst input>
     ```
     Report the blocker to chat and stop execution.

## Boundaries

- **No interview** — the analyst model is not present. Do not ask clarifying questions; use `## Decisions` as the authority.
- **Read-only on Investigation and Decisions** — never modify those sections.
- **No `Task`/`TodoWrite`/`Question`** — those tools are unavailable in OpenCode.
- **Append-only journaling** — never delete or rewrite prior inline notes.

## Notes & Tips

- If `## Implementation Plan` is missing or empty, report and stop — there is nothing to execute.
- If all items are already checked, report completion and suggest running `wrap-task`.
- Prefer `exa`, `rg`, and `fd` over `ls`, `grep`, and `find` per global conventions.
- When resuming a partially-completed plan (some items already `[x]`), skip to the first unchecked item. Read prior inline notes to understand current state.
- Keep inline notes terse — one line max per item.
