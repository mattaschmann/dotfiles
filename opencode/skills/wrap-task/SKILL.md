---
name: wrap-task
description: Validates task implementation plan completion, performs advisory code review (diff, tests, lint, completeness), and renames task file with DONE- prefix. Use when the user indicates task completion and wants to wrap up the task file.
---

## Purpose

Use this skill after completing work on a task to perform a code review, validate the implementation matches the plan, and mark the task file as complete.

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
4. **Code review** (advisory — findings do not block completion) –
   - **a. Diff review** –
     - Run `git log --oneline main..HEAD` (or the appropriate base branch) to identify commits on this branch
     - Run `git diff main...HEAD --stat` to see changed files
     - For each plan item, verify there are corresponding code changes in the diff
     - Flag any plan items that lack matching changes (may indicate incomplete or reverted work)
   - **b. Test verification** –
     - Discover the test command by checking (in order): `AGENTS.md`, `pyproject.toml` (poe tasks, scripts), `package.json` (scripts), `Makefile`, `Cargo.toml`
     - If found, run the test command and report pass/fail
     - If not found, suggest common options (e.g., `pytest`, `npm test`, `make test`) but do not block
   - **c. Lint / type check** –
     - Discover lint and type check commands using the same sources as above
     - If found, run them and report results
     - If not found, suggest options but do not block
   - **d. Completeness scan** –
     - Get the list of changed files from `git diff main...HEAD --name-only`
     - Scan those files for:
       - `TODO`, `FIXME`, `HACK`, `XXX` comments
       - Debug statements (`print(`, `console.log(`, `debugger`, `breakpoint()`)
       - Large blocks of commented-out code (3+ consecutive commented lines)
       - Unused imports (if a linter already caught these, skip)
     - Report any findings with file paths and line numbers
    - **e. Documentation check** –
      - Identify which READMEs and documentation files are relevant to the changed code (check for READMEs in the same directory or parent directories of changed files)
      - **Always check the root `README.md`** for stale references to removed/renamed tools, APIs, commands, or architecture that the task changed
      - Check if `AGENTS.md` needs updating (new commands, changed architecture, new key files, changed workflows)
      - Flag any public API changes, new middleware, new configuration, or new commands that lack documentation
      - Report documentation gaps as actionable findings
    - **f. Coding-practices review** –
      - Read the Code Practices and Code Documentation guidance from the global `~/.config/opencode/AGENTS.md` and any repo-root `AGENTS.md`
      - Review the diff against those practices and report actionable findings — e.g. duplicated logic/constants (DRY), homespun infrastructure where an established library exists, raw `console`/`print` logging instead of the project logger, oversized or mixed-concern modules, hardcoded magic strings, and doc-comment placement (missing high-value docs or low-value noise)
      - Advisory only: fold findings into the step 5 report and step 6 resolution flow. Do not block
5. **Present findings report** –
   - Summarize the code review as a short report with sections for each sub-step
   - Clearly label each finding as informational (no action needed) or actionable
   - If no issues found, state that the review passed clean
6. **Resolve findings** –
   - If actionable findings exist, ask the user how to proceed:
     - **Fix inline** — address the issues now in this session
     - **Create follow-up task** — write a new `.tasks/` file describing the remaining work
     - **Proceed anyway** — acknowledge findings and continue to rename
   - If the user chooses to fix inline, perform the fixes, re-run the relevant checks, then continue
   - If the user chooses a follow-up task, create a new `.tasks/<name>.md` with the findings, then continue
7. **Rename the file** –
   - Rename the file by prepending `DONE-`
   - Example: `.tasks/wda-460.md` → `.tasks/DONE-wda-460.md`
   - Use `mv` command to perform the rename

## Discovering Commands

When looking for test, lint, or type check commands, check these sources in order and use the first match:

1. `AGENTS.md` in the repo root — look for explicit command references
2. `pyproject.toml` — check `[tool.poe.tasks]`, `[tool.pytest]`, `[project.scripts]`
3. `package.json` — check `scripts` object
4. `Makefile` / `justfile` — look for `test`, `lint`, `check` targets
5. `Cargo.toml` — use `cargo test`, `cargo clippy`

If none are found, suggest but do not run. Never block the wrap process on missing tooling.

## Notes & Tips

- **No implementation plan found**: Ask the user if they want to proceed anyway or cancel
- **All tasks already done**: If the task file is already prefixed with `DONE-`, report that it's already wrapped
- **Base branch detection**: Try `main` first, fall back to `master`, then ask the user
- **No git history**: If there are no commits on the branch (or it's a single-branch workflow), diff against the last N commits or skip the diff review
- **Large diffs**: If the diff is very large (50+ files), summarize by directory rather than reviewing every file
- This skill assumes it runs in the same session as analyze-task; if no context exists, falls back to asking the user
