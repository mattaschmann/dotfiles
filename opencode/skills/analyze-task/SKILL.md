---
name: analyze-task
description: Identify available `.tasks/` files, summarize the chosen task with clarifying questions, then produce and append a checkbox implementation plan before executing one confirmed step at a time.
---

## Purpose

Use this skill whenever the user wants help understanding items inside the `.tasks/` directory and converting that understanding into an actionable implementation plan. The flow yields a shared mental model before any coding begins and keeps the user in control of execution order.

## Workflow

1. **Discover tasks** – List `.tasks/` with `exa .tasks` (or equivalent). If nothing exists, report that back.
2. **Select focus** –
   - If exactly one task file exists, read it directly.
   - If multiple files exist, summarize their names and ask the user which file to open. Default selections only when the user explicitly defers.
3. **Absorb context** – Read the chosen task file in full. Capture goals, constraints, assets, and any embedded checklists.
4. **Share overview** – Present a concise, high-level summary of the task, and surface clarifying questions covering open requirements or assumptions. Pause for the user’s answers before planning.
5. **Author the plan** –
   - Draft a checkbox list (`- [ ] action`) showing the minimal, ordered steps required to complete the task.
   - Ensure each item is concrete and testable.
   - Keep the list short enough to stay actionable; split large efforts.
6. **Persist the plan** – Append the checkbox plan to the bottom of the task file (include a heading such as `## Implementation Plan`). Avoid overwriting prior content.
7. **Execute deliberately** – When carrying out the plan, run exactly one checkbox item at a time. After finishing a step, return for confirmation before moving on. Never run additional steps in `.tasks/**` work without the user’s explicit go-ahead.

## Notes & Tips

- Keep communication lightweight: summarize results, highlight blockers, and request input only when necessary to proceed safely.
- When the user approves moving forward, mark completed checkboxes in the task file as you progress.
- If the task file already contains a plan or checklist, reference it before drafting a new one; extend rather than duplicate when possible.
