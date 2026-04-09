---
description: Run the analyze-task skill
agent: plan
temperature: 0.6
---
Run:
!`ls .tasks`


If $1 exists in this list, run the following skill with it, otherwise just run
the skill:

skill({ name: "analyze-task" })
