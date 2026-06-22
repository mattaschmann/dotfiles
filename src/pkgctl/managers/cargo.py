"""Cargo/Rust package manager."""

from __future__ import annotations

import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Cargo(Manager):
    name = "cargo"

    def is_available(self) -> bool:
        return shutil.which("cargo") is not None

    def update(self) -> None:
        self.output.info("==> Updating Rust toolchain...")
        run(["rustup", "update"], dry_run=self.dry_run, check=True)

        if not shutil.which("cargo-binstall"):
            self.output.info("    Installing cargo-binstall...")
            run(["cargo", "install", "cargo-binstall"], dry_run=self.dry_run, check=True)

        packages = self.config.get_list("cargo", "install")
        if packages:
            self.output.info("==> Installing/updating cargo packages...")
            run(["cargo", "binstall", "-y", *packages], dry_run=self.dry_run, check=True)

        git_packages = self.config.get_list("cargo", "git")
        if git_packages:
            self.output.info("==> Installing/updating cargo git packages...")
            for repo in git_packages:
                run(["cargo", "install", "--git", repo], dry_run=self.dry_run)

        self.output.info("==> Checking for cargo updates...")
        run(["cargo", "install-update", "-a"], dry_run=self.dry_run)

        self.output.info("==> Cleaning cargo cache...")
        run(["cargo", "cache", "--autoclean"], dry_run=self.dry_run)
        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        result = run(["cargo", "install", "--list"])
        if not result.ok:
            self.output.add_result(Result(manager=self.name, success=False, errors=["cargo install --list failed"]))
            return

        installed = set()
        for line in result.stdout.splitlines():
            if line and not line.startswith(" "):
                installed.add(line.split()[0].rstrip(":"))

        declared = set(self.config.get_list("cargo", "install"))
        ignored = set(self.config.get_ignore_list("cargo"))

        git_repos = self.config.get_list("cargo", "git")
        git_names = {repo.rstrip("/").split("/")[-1] for repo in git_repos}

        untracked = sorted(installed - declared - ignored - git_names)
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
