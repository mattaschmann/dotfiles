"""Apt package manager (Linux only)."""

from __future__ import annotations

import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Apt(Manager):
    name = "apt"

    def is_available(self) -> bool:
        return shutil.which("apt") is not None

    def update(self) -> None:
        self.output.info("==> Updating apt packages...")
        sudo_check = run(["sudo", "-n", "true"])
        if not sudo_check.ok:
            self.output.error("    Skipping apt (sudo not available without password prompt)")
            self.output.add_result(Result(
                manager=self.name,
                success=False,
                errors=["sudo not available without password prompt"],
            ))
            return

        run(["sudo", "apt", "update"], dry_run=self.dry_run, check=True)
        run(["sudo", "apt", "upgrade", "-y"], dry_run=self.dry_run, check=True)
        run(["sudo", "apt", "autoremove", "-y"], dry_run=self.dry_run, check=True)

        packages = self.config.get_list("apt", "install")
        if packages:
            self.output.info("    Ensuring apt packages from packages.toml...")
            run(["sudo", "apt", "install", "-y", *packages], dry_run=self.dry_run, check=True)

        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        installed_result = run(
            ["dpkg-query", "-W", "-f", "${binary:Package}\n"],
        )
        if not installed_result.ok:
            self.output.add_result(Result(manager=self.name, success=False, errors=["dpkg-query failed"]))
            return

        installed = set(installed_result.stdout.strip().splitlines())
        declared = set(self.config.get_list("apt", "install"))
        ignored = set(self.config.get_ignore_list("apt"))

        missing = sorted(declared - installed)
        if missing:
            self.output.info(f"    Missing (declared but not installed): {', '.join(missing)}")

        result = Result(manager=self.name, data={"missing": missing})
        self.output.add_result(result)
