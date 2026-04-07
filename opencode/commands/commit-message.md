---
description: It will look at the currently staged changes in git, and generate a commit message based on best practices.
agent: git-agent
temperature: 0.5
---
- Look at the rules specified here: https://www.conventionalcommits.org
Here are the staged commits:
- Based on those rules, suggest a commit message to the user, using just the
  following:
!`git diff --cached`
