---
description: Find available tasks and analyze the selected one.
agent: plan
temperature: 0.6
---
Steps:
- List files in the `.tasks/` directory.
- If there is only one file, read that one.  Otherwise, ask the user which file
  they want to focus on.
- Grok the selected file, it will contain information about a specific task.
- Generate a high level overview, ask any questions from the user to clarify
  things that are unclear.
- Once the user is happy with the overview, generate an implementation plan.
- Append the implementation plan to the task file.
