"""Opencode plugin manager (git-based local repos)."""

from __future__ import annotations

import shutil
from pathlib import Path

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Opencode(Manager):
    name = "opencode"

    def is_available(self) -> bool:
        return shutil.which("git") is not None

    def _plugin_dirs(self) -> list[Path]:
        raw = self.config.get_list("opencode", "plugins")
        return [Path(p.replace("~", str(Path.home()))) for p in raw]

    def update(self) -> None:
        self.output.info("==> Updating opencode plugins...")
        errors: list[str] = []

        for plugin_dir in self._plugin_dirs():
            name = plugin_dir.name
            if not plugin_dir.is_dir():
                errors.append(f"{name}: directory does not exist ({plugin_dir})")
                self.output.error(f"    ERROR: {name} — directory does not exist")
                continue
            if not (plugin_dir / ".git").is_dir():
                errors.append(f"{name}: not a git repo")
                self.output.error(f"    ERROR: {name} — not a git repo")
                continue

            result = run(
                ["git", "pull", "--ff-only", "origin", "main"],
                cwd=str(plugin_dir),
                dry_run=self.dry_run,
            )
            if result.ok:
                self.output.info(f"    {name}: updated")
            else:
                errors.append(f"{name}: {result.stderr.strip()}")
                self.output.error(f"    ERROR: {name} — {result.stderr.strip()}")

        self.output.add_result(Result(
            manager=self.name,
            success=not errors,
            errors=errors,
        ))

    def drift(self) -> None:
        errors: list[str] = []
        missing: list[str] = []

        for plugin_dir in self._plugin_dirs():
            name = plugin_dir.name
            if not plugin_dir.is_dir():
                missing.append(str(plugin_dir))
                self.output.info(f"    MISSING: {name} ({plugin_dir})")
            elif not (plugin_dir / ".git").is_dir():
                errors.append(f"{name}: not a git repo")
                self.output.info(f"    NOT A GIT REPO: {name}")

        if not missing and not errors:
            self.output.info("    (no drift)")

        self.output.add_result(Result(
            manager=self.name,
            data={"missing": missing},
            errors=errors,
        ))

    def diff(self) -> None:
        self.output.info("==> Checking opencode plugin diffs...")
        plugins_data: dict[str, dict] = {}

        for plugin_dir in self._plugin_dirs():
            name = plugin_dir.name
            if not plugin_dir.is_dir() or not (plugin_dir / ".git").is_dir():
                plugins_data[name] = {"status": "error", "message": "missing or not a git repo"}
                continue

            run(["git", "fetch", "origin", "main"], cwd=str(plugin_dir))

            log_result = run(
                ["git", "log", "HEAD..origin/main", "--oneline"],
                cwd=str(plugin_dir),
            )
            stat_result = run(
                ["git", "diff", "--stat", "HEAD..origin/main"],
                cwd=str(plugin_dir),
            )
            diff_result = run(
                ["git", "diff", "HEAD..origin/main", "--", "package.json", "package-lock.json"],
                cwd=str(plugin_dir),
            )

            commits = [l for l in log_result.stdout.strip().splitlines() if l]
            files_changed = [
                l.split("|")[0].strip()
                for l in stat_result.stdout.strip().splitlines()
                if "|" in l
            ]

            if not commits:
                plugins_data[name] = {"status": "up-to-date"}
                self.output.info(f"    {name}: up-to-date")
            else:
                has_dep_changes = bool(diff_result.stdout.strip())
                plugins_data[name] = {
                    "status": "behind",
                    "commits_behind": len(commits),
                    "commits": commits,
                    "files_changed": files_changed,
                    "has_dependency_changes": has_dep_changes,
                }
                self.output.info(f"    {name}: {len(commits)} commits behind")
                for c in commits:
                    self.output.info(f"      {c}")
                if has_dep_changes:
                    self.output.info(f"      ⚠ package.json/lock changes detected")

        has_pending = any(p.get("status") == "behind" for p in plugins_data.values())
        self.output.add_result(Result(
            manager=self.name,
            data={"plugins": plugins_data},
            success=True,
        ))
