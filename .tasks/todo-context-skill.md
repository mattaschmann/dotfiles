# Turn the @Matt TODO marker workflow into a skill + command

Repurpose the existing `todo-context` command (currently targets `@Agent` tags)
to work with my personal `@Matt TODO` marker convention. Optimize the workflow
and back it with a proper opencode skill, mirroring the commit-message
skill+command pattern.

Goals:
- Update `opencode/commands/todo-context.md` to target `@Matt TODO` markers
  instead of `@Agent` tags (rg-backed scan, respect .gitignore).
- Extract the logic into a reusable `opencode/skills/todo-context/SKILL.md`:
  find markers, summarize surrounding context, confirm intent, optionally
  resolve/remove the marker lines.
- Make the command a thin `skill({ name: "todo-context" })` wrapper (consistent
  with commit-message / analyze-task).
- Keep the `todo-context` command name.
