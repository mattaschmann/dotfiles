---
name: wrap-task
description: Validates task implementation plan completion and renames task file with DONE- prefix. Use when the user indicates task completion and wants to wrap up the task file.
allowed-tools: Bash(exa:*,mv:*) Read TodoWrite
---

## Purpose

Use this skill after completing work on a task to validate the implementation is done, mark the task file as complete, and verify the skill itself is well-formed.

## Workflow

1. **Identify the task** –
   - Check if `TodoWrite` contains a task file path from a prior `analyze-task` session
   - If not found in context, run `exa -lt .tasks/` (or `ls -lt .tasks/`) to list task files
   - Present the list and ask the user which task to wrap
2. **Read the task file** – Open the selected `.tasks/` file and locate the implementation plan section
3. **Validate completion** –
   - Find all checkbox items in the implementation plan
   - Verify every item is marked done (`- [x]`)
   - If any unchecked items remain (`- [ ]`), report them to the user and stop
4. **Rename the file** –
   - If all items are complete, rename the file by prepending `DONE-`
   - Example: `.tasks/2026-05-13-fix-bug.md` → `.tasks/DONE-2026-05-13-fix-bug.md`
   - Use `mv` command to perform the rename

## Notes & Tips

- **No implementation plan found**: Ask the user if they want to proceed anyway or cancel
- **All tasks already done**: If the task file is already prefixed with `DONE-`, report that it's already wrapped
- This skill assumes it runs in the same session as analyze-task; if no context exists, falls back to asking the user
