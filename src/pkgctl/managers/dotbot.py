"""Dotbot submodule manager."""

from __future__ import annotations

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Dotbot(Manager):
    name = "dotbot"

    def is_available(self) -> bool:
        return (self.config.repo_root / "dotbot" / ".git").exists()

    def _submodule_dir(self) -> str:
        return str(self.config.repo_root / "dotbot")

    def update(self) -> None:
        self.output.info("==> Updating dotbot submodule...")
        result = run(
            ["git", "submodule", "update", "--remote", "dotbot"],
            cwd=str(self.config.repo_root),
            dry_run=self.dry_run,
        )
        if result.ok:
            self.output.info("    dotbot: updated to latest upstream")
        else:
            self.output.error(f"    ERROR: {result.stderr.strip()}")

        self.output.add_result(Result(
            manager=self.name,
            success=result.ok,
            errors=[result.stderr.strip()] if not result.ok else [],
        ))

    def drift(self) -> None:
        run(["git", "fetch", "origin"], cwd=self._submodule_dir())

        local = run(["git", "rev-parse", "HEAD"], cwd=self._submodule_dir())
        remote = run(["git", "rev-parse", "origin/master"], cwd=self._submodule_dir())

        if local.stdout.strip() != remote.stdout.strip():
            self.output.info("    dotbot: submodule is behind upstream")
            self.output.add_result(Result(
                manager=self.name,
                data={"missing": ["dotbot submodule is behind upstream"]},
            ))
        else:
            self.output.info("    dotbot: up-to-date")
            self.output.add_result(Result(manager=self.name))

    def diff(self) -> None:
        self.output.info("==> Checking dotbot upstream changes...")
        run(["git", "fetch", "origin"], cwd=self._submodule_dir())

        log_result = run(
            ["git", "log", "HEAD..origin/master", "--oneline"],
            cwd=self._submodule_dir(),
        )
        commits = [l for l in log_result.stdout.strip().splitlines() if l]

        if not commits:
            self.output.info("    dotbot: up-to-date")
            self.output.add_result(Result(
                manager=self.name,
                data={"status": "up-to-date"},
            ))
        else:
            self.output.info(f"    dotbot: {len(commits)} commits behind")
            for c in commits:
                self.output.info(f"      {c}")
            self.output.add_result(Result(
                manager=self.name,
                data={
                    "status": "behind",
                    "commits_behind": len(commits),
                    "commits": commits,
                },
            ))
