"""NPM global package manager."""

from __future__ import annotations

import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Npm(Manager):
    name = "npm"

    def is_available(self) -> bool:
        return shutil.which("npm") is not None

    def update(self) -> None:
        self.output.info("==> Updating global npm packages...")
        run(["npm", "update", "-g"], dry_run=self.dry_run)

        packages = self.config.get_list("npm", "install")
        if packages:
            run(["npm", "install", "-g", *packages], dry_run=self.dry_run, check=True)

        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        result = run(["npm", "list", "-g", "--depth=0", "--json"])
        if not result.ok:
            self.output.add_result(Result(manager=self.name, success=False, errors=["npm list failed"]))
            return

        import json

        try:
            data = json.loads(result.stdout)
            installed = set(data.get("dependencies", {}).keys())
        except (json.JSONDecodeError, KeyError):
            self.output.add_result(Result(manager=self.name, success=False, errors=["failed to parse npm list output"]))
            return

        declared = set(self.config.get_list("npm", "install"))
        ignored = set(self.config.get_ignore_list("npm"))

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
