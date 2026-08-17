---
name: reconcile-work
description: Inspects all active initiative files, resolves child task states from their repositories, detects drift or contradictions, updates the coordination dashboard, and recommends next actions. Use when the user wants a status check, asks "what should I do next," or starts a coordination session.
---

## Purpose

Derive the true state of multi-repository initiatives by inspecting child task
files, git status, and recent commits — then update coordination state and
recommend next actions. This skill never modifies application repositories; it
only updates files in the coordination repo.

## Workflow

1. **Load dashboard** — Read `DASHBOARD.md` and note `Last reconciled` date.
2. **Discover initiatives** — Run `exa -l --sort=modified .tasks/`. Eligible:
   any `*.md` not prefixed with `DONE-`.
3. **For each active initiative file**, in priority order:
   a. Read the initiative file. Extract workstreams table, blockers, and
      dependency order.
   b. For each workstream row:
      - Resolve the child repository path (from `AGENTS.md` repository table).
      - Read the referenced child `.tasks/` file.
      - Run `git -C <repo> status --short` and `git -C <repo> log --oneline -5`
        to check for uncommitted/unpushed work.
      - Classify the workstream:
        - `planned` — task file exists, no implementation plan or all unchecked
        - `implementing` — some checkboxes checked, uncommitted changes present
        - `blocked` — `## Blockers` section present with unresolved items
        - `ready to wrap` — all checkboxes checked
        - `done` — file prefixed with `DONE-`
        - `stale` — decisions or facts contradict the initiative file
      - Detect contradictions between initiative decisions and child decisions
        (e.g., region mismatch, naming mismatch).
   c. Update the workstream row's State and Next action columns.
   d. Update the initiative's blockers table if new blockers were found or
      existing ones resolved.
   e. Append a dated entry to `## Reconciliation Log`.
4. **Update dashboard** —
   - Refresh the Active table (phase, blocked-by, next action per initiative).
   - Move completed initiatives to Recently Completed.
   - Update `Last reconciled` timestamp.
   - Refresh the Waiting table (check if any external waits have evidence of
     resolution).
5. **Report** — Print a compact summary to chat:
   - Initiatives reconciled (count)
   - Contradictions found (list)
   - Blockers added/resolved
   - Recommended next action (exactly one, from the highest-priority unblocked
     initiative)

## Boundaries

- **Never modify application repositories.** Only update files in the
  coordination repo (`DASHBOARD.md`, `.tasks/*.md`).
- **Never copy implementation plans.** Reference child tasks by path.
- **Evidence-based only.** If a child task file cannot be read (repo missing,
  path wrong), mark as "unknown" rather than inferring state.
- **No `Task`/`TodoWrite`/`Question`** — keep portable across clients.

## Notes & Tips

- If a child repo is not cloned locally, mark that workstream as "unavailable"
  and note the missing path.
- If `AGENTS.md` does not list a repository path, ask the user.
- Prefer `exa`, `rg`, `fd` over `ls`, `grep`, `find`.
- Keep reconciliation log entries to one line: date + what changed.
- If the user says "what should I do next," run this skill implicitly and
  present only the single recommended action with enough context to act on it.
