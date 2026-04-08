---
description: Run the analyze-task skill
agent: plan
temperature: 0.6
---

If $1 exists, find the relevant task file in the `.tasks/` directory, you may need to use
fuzzy searching.

Use that file for the following skill, otherwise simply run:
skill({ name: "analyze-task" })
