# Create an agent skill that runs the weekly update for me
Currently, every monday, I do an update on my computer:
- I run the `./install` command
- I run `antidote update`
- I do a `ctrl-b U` to update my tmux plugins
- I update my neovim packages that a managed by lazyvim

Is it possible to create a skill that I can run that will handle this instead?
On gotcha is that it may need sudo access when I'm running this in linux.  It
should also handle a situation where a dependancy is missing.

Basically I want it to:
- Try and run an equivalent process to the above, where it will try and update
  my systems packages
- It will show me a list of things that could be removed, i.e. with the brewfile
  bundle cleanup
- It will either allow me to continue ignoring them, adding them to the
  brewfile, or removing them
- This will be the same for other things that are in that `scripts/update.sh`
  script, i.e. npm packages, uv tools, etc...
- If it's possible to update neovim, that would be nice but not high priority

## Implementation Plan

- [x] Create `opencode/skills/weekly-update/SKILL.md` with frontmatter and skill body
  - Prerequisites check: brew/apt, antidote, TPM (error if missing)
  - Run `./install` (dotbot + scripts/update.sh)
  - Run `antidote update`
  - Run TPM update (`~/.tmux/plugins/tpm/bin/update_plugins all`)
  - Show cleanup candidates: brew bundle cleanup, npm globals, uv tools, cargo crates
  - Ask user what to remove/keep/add-to-Brewfile
  - Execute removals based on user input
  - Handle sudo on Linux for apt
  - Catch and help debug errors at each step
- [x] Register the skill in `opencode/AGENTS.md` (or equivalent config) so opencode discovers it
  - Auto-discovered via symlink; no manual registration needed
- [x] Test the skill by invoking it and verifying prerequisite checks work
  - Verified: brew found, TPM found, antidote requires interactive zsh (expected)

