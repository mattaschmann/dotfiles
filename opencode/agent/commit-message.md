---
description: It will look at the currently staged changes in git, and generate a commit message based on best practices.
mode: subagent
temperature: 0.5
---
Steps:
- run `git diff --cached`
- Look at the rules specified here: https://www.conventionalcommits.org
- Based on those rules, suggest a commit message to the user.
