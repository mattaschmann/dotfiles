---
name: commit-message
description: Inspects staged git changes and generates a Conventional Commits message following best practices. Use when the user asks for a commit message, conventional commit, or to describe their staged changes.
allowed-tools: Bash(git diff --cached:*) Bash(git diff --cached)
---

## Purpose

Read the currently staged git diff and propose a single Conventional Commits message the user can accept, edit, or reject.

## Workflow

1. Run `git diff --cached` to read staged changes.
2. If nothing is staged, report that there are no staged changes and stop. Do NOT run `git add`.
3. Analyze the diff and determine the appropriate commit type, optional scope, and subject.
4. Apply Conventional Commits rules (https://www.conventionalcommits.org):
   - Format: `<type>[optional scope]: <description>`
   - Types: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `style`, `perf`, `ci`, `build`, `revert`.
   - Subject line: imperative mood, lowercase start, no trailing period, max ~72 chars.
   - Body (optional): explain *what* and *why*, not *how*. Wrap at 72 chars.
   - Footer: `BREAKING CHANGE: <description>` when applicable.
5. Present the suggested commit message to the user. Do NOT run `git commit` unless explicitly asked.

## Notes & Tips

- If the diff spans multiple concerns, suggest splitting into separate commits rather than one giant message.
- Never run `git add` or `git commit` unprompted (per global conventions).
- Prefer a single type; if the change genuinely spans types, pick the dominant one and note the secondary in the body.
