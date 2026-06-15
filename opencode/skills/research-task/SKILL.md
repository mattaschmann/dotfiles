---
name: research-task
description: Performs autonomous, high-level investigation on a `.tasks/` file — explores the codebase, maps relevant files, surfaces possible directions, and writes findings under `## Investigation`. Designed as a cheap-model precursor to `analyze-task`. Use when the user wants a recon pass before detailed planning.
allowed-tools: Bash(exa:*) Bash(rg:*) Bash(fd:*) Read Grep Glob Task Write Edit TodoWrite
---

## Purpose

Lightweight, breadth-first recon pass on a task file. Runs autonomously on a cheaper model to front-load exploration and research, then hands off to `analyze-task` (on a stronger model) for the interview, plan, and execution.

## Output contract

Your **only** output is a `## Investigation` section appended to the task file using the template below. You do **not** plan, recommend a single approach, order implementation steps, or write checkboxes (`- [ ]`). If you find yourself writing an ordered list of actions to take, stop — that is a plan, not research. Planning and execution belong exclusively to `analyze-task`.

## Workflow

1. **Discover tasks** – Run `exa -l --sort=modified .tasks/`. Eligible files are any `*.md` directly under `.tasks/`; ignore subdirectories unless the user names one. If `exa` is unavailable, fall back to `ls -lt .tasks/`. If `.tasks/` is absent, report and stop. If present but empty, report and stop.
2. **Select focus** –
   - If exactly one task file exists, use it.
   - If multiple files exist, use the most recently modified (no interview — this skill runs unattended).
   - If the user explicitly named a task, use that one.
3. **Absorb context** – Read the chosen task file in full. Capture goals, constraints, assets, and any prior content.
4. **Explore breadth-first** –
   - Use Grep, Glob, and Task/explore subagents to map the relevant area of the codebase.
   - Identify: where the work lives, key files, existing patterns, integration points, related tests.
   - Stay shallow — identify *what* and *where*, not line-level *how*.
   - Use `file:line` references so the next agent can jump straight to relevant code.
5. **Research** –
   - Note external libraries, APIs, or frameworks involved.
   - Surface 1–2 **possible directions** as short, neutral observations (1–2 sentences each, no steps, no ordering, no recommendation). Choosing between them is `analyze-task`'s job.
   - List open questions that need a human decision or deeper investigation.
6. **Write findings** – Append the following template to the task file, filled in with your findings. Do not add any content outside this template.

   ```markdown
   ## Investigation

   ### Overview
   <!-- 2–3 sentence summary of what was found. -->

   ### Relevant files
   <!-- Bulleted list of `path:line` refs with one-line descriptions. -->

   ### Existing patterns to follow
   <!-- Conventions, utilities, or structures the implementation should reuse. -->

   ### Possible directions
   <!-- 1–2 descriptive observations of what could be relevant. No steps, no ordering, no recommendation. -->

   ### Open questions
   <!-- Things that need human input or deeper exploration during analyze-task. -->
   ```

   Append-only: never overwrite prior content. If `## Investigation` already exists, create a dated sibling heading (e.g., `## Investigation (2026-06-11)`) and use that as the top-level heading inside the block.

7. **Stop and hand off** – Report that recon is complete and suggest running `analyze-task` with a stronger model.

## Boundaries

- **No implementation** — do not write or modify application code.
- **No checkboxes, no implementation plan** — never emit `- [ ]` / `- [x]` lines or an `## Implementation Plan` heading. Those belong exclusively to `analyze-task`.
- **No interview** — run fully autonomously; save clarifying questions for the open-questions list.
- **Breadth over depth** — map the surface area, don't trace every call chain.
- **Cheap-model friendly** — keep reasoning lightweight; delegate fanned-out searching to explore subagents via the Task tool.

## Notes & Tips

- If the task file is empty, report it and stop — there's nothing to investigate.
- If the task already has an `## Implementation Plan`, this skill can still run (e.g., re-scouting after scope changes). Write findings under a new dated `## Investigation` heading.
- Prefer `exa`, `rg`, and `fd` over `ls`, `grep`, and `find` per global conventions.
