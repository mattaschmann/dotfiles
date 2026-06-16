"""UV tool manager."""

from __future__ import annotations

import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Uv(Manager):
    name = "uv"

    def is_available(self) -> bool:
        return shutil.which("uv") is not None

    def update(self) -> None:
        self.output.info("==> Updating uv...")
        run(["uv", "self", "update"], dry_run=self.dry_run)

        packages = self.config.get_list("uv", "install")
        if packages:
            self.output.info("==> Installing/updating uv tools...")
            for pkg in packages:
                run(["uv", "tool", "install", pkg], dry_run=self.dry_run)
            run(["uv", "tool", "upgrade", "--all"], dry_run=self.dry_run, check=True)

        run(["uv", "cache", "prune"], dry_run=self.dry_run)
        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        result = run(["uv", "tool", "list"])
        if not result.ok:
            self.output.add_result(Result(manager=self.name, success=False, errors=["uv tool list failed"]))
            return

        installed = set()
        for line in result.stdout.splitlines():
            if line and not line.startswith("-"):
                installed.add(line.split()[0])

        declared_raw = self.config.get_list("uv", "install")
        declared = {pkg.split("[")[0] for pkg in declared_raw}
        ignored = set(self.config.get_list("uv", "ignore"))

        untracked = sorted(installed - declared - ignored)
        missing = sorted(declared - installed)

        if untracked:
            self.output.info(f"    Installed but not tracked: {', '.join(untracked)}")
        if missing:
            self.output.info(f"    Declared but not installed: {', '.join(missing)}")
        if not untracked and not missing:
            self.output.info("    (no drift)")

        self.output.add_result(Result(
            manager=self.name,
            data={"untracked": untracked, "missing": missing},
        ))
