---
name: analyze-task
description: Analyzes `.tasks/` files, interviews the user one question at a time to reach shared understanding, appends a checkbox implementation plan, and executes steps one at a time with confirmation. Use when the user asks to plan, break down, or work through a task file.
allowed-tools: Bash(exa:*) Bash(rg:*) Bash(fd:*) Read Edit Write Grep Glob Task TodoWrite
---

## Purpose

Use this skill whenever the user wants help understanding items inside the `.tasks/` directory and converting that understanding into an actionable implementation plan. The flow yields a shared mental model before any coding begins and keeps the user in control of execution order.

## Workflow

1. **Discover tasks** – Run `exa -l --sort=modified .tasks/`. Eligible files are any `*.md` directly under `.tasks/`; ignore subdirectories unless the user names one. If `exa` is unavailable, fall back to `ls -lt .tasks/`. If `.tasks/` is absent, report and stop. If present but empty, report and ask whether to scaffold a new task file.
2. **Select focus** –
   - If exactly one task file exists, read it directly.
   - If multiple files exist, summarize their names (ISO-8601 date + filename, newest first) and ask which to open. If the user explicitly defers, default to the most recently modified.
3. **Absorb context** – Read the chosen task file in full. Capture goals, constraints, assets, and any embedded checklists. If a `## Investigation` section exists (written by a prior `research-task` pass), treat it as pre-validated recon: use its relevant-files list, existing-patterns notes, and possible-directions as starting context rather than re-discovering them.
4. **Share overview** – Present a concise, high-level summary of goals, constraints, and open questions. If an Investigation section exists, incorporate its findings and flag its open questions as priority topics for the interview.
5. **Grill for clarity** – Interview the user to reach shared understanding:
   - Ask exactly one clarifying question at a time.
   - Offer a recommended answer with each question so the user can accept or override.
   - Walk down the decision tree, resolving dependencies between decisions as you go.
   - If a question is answerable by exploring the codebase, investigate first (using Grep, Glob, or Task/explore subagents) instead of asking.
   - Seed the interview from Investigation open questions when available; skip questions the Investigation already answers.
   - Exit the loop on any explicit affirmative signal (e.g., "proceed", "go", "ship it", "lgtm", "continue").
   - If the interview exceeds 5 exchanges, summarize all open decisions and ask the user to approve them as a batch.
6. **Author the plan** –
   - Draft a checkbox list (`- [ ] action`) showing the minimal, ordered steps required to complete the task.
   - Each item names a concrete artifact, file, or observable outcome.
   - Keep the list short enough to stay actionable; split large efforts.
   - Mirror the checkbox plan into `TodoWrite` for session visibility only; the task file is always the source of truth and `TodoWrite` need not be kept in sync after the session ends.
7. **Persist the plan** – Append under a `## Implementation Plan` heading at the bottom of the task file. Never overwrite prior content. If the heading already exists and contains any unchecked `- [ ]` items, create a new dated sibling heading (e.g., `## Implementation Plan (2026-04-29)`). Otherwise, append new items beneath the existing heading.
8. **Execute deliberately** – For each step:
   - Run exactly one checkbox item at a time.
   - On success: wait for an explicit acknowledgement (e.g., "done", "next", "ok") before changing `- [ ]` to `- [x]` in the task file and proceeding to the next item.
   - On failure: leave the item as `- [ ]`, append an indented note beneath it describing the error, report to the user, and pause.
   - Never batch `.tasks/**` steps.

## Notes & Tips

- Keep communication lightweight: summarize results, highlight blockers, and request input only when necessary to proceed safely.
- If the task file already contains a plan or checklist, reference it before drafting a new one; extend rather than duplicate when possible.
- **Empty task file**: report it and ask whether to scaffold content before proceeding.
- **Completed plan present**: ask whether to extend the existing plan or start a new dated sibling heading.
- **Non-markdown task file**: ask the user how to interpret it before reading.
- **User names multiple tasks**: process the first one fully; queue the rest and confirm order before starting each.
- **Prior `research-task` pass**: If `## Investigation` exists, leverage it fully — don't re-explore files it already mapped. Focus the interview on resolving its open questions and choosing between its possible directions.
- Prefer `exa`, `rg`, and `fd` over `ls`, `grep`, and `find` per global conventions.
