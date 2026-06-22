"""Homebrew package manager."""

from __future__ import annotations

import platform
import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Brew(Manager):
    name = "brew"

    def is_available(self) -> bool:
        return shutil.which("brew") is not None

    def _os_key(self) -> str:
        return "osx" if platform.system() == "Darwin" else "linux"

    def _all_formulae(self) -> list[str]:
        base = self.config.get_list("brew", "formulae")
        os_specific = self.config.get_list(f"brew.{self._os_key()}", "formulae")
        return sorted(set(base + os_specific))

    def _all_casks(self) -> list[str]:
        base = self.config.get_list("brew", "casks")
        os_specific = self.config.get_list(f"brew.{self._os_key()}", "casks")
        return sorted(set(base + os_specific))

    def _all_taps(self) -> list[str]:
        base = self.config.get_list("brew", "taps")
        os_specific = self.config.get_list(f"brew.{self._os_key()}", "taps")
        return sorted(set(base + os_specific))

    def generate_brewfile(self) -> str:
        lines: list[str] = []
        for tap in self._all_taps():
            lines.append(f'tap "{tap}"')
        for pkg in self._all_formulae():
            lines.append(f'brew "{pkg}"')
        for cask in self._all_casks():
            lines.append(f'cask "{cask}"')
        return "\n".join(lines) + "\n"

    def update(self) -> None:
        self.output.info("==> Generating Brewfile...")
        brewfile_path = self.config.repo_root / "Brewfile"
        if not self.dry_run:
            brewfile_path.write_text(self.generate_brewfile())

        for tap in self._all_taps():
            run(["brew", "trust", "--tap", tap], dry_run=self.dry_run)

        self.output.info("==> Installing/updating brew packages...")
        check_result = run(
            ["brew", "bundle", "check", f"--file={brewfile_path}"],
            dry_run=self.dry_run,
        )
        if not check_result.ok:
            run(["brew", "bundle", "install", f"--file={brewfile_path}"], dry_run=self.dry_run, check=True)

        run(["brew", "update"], dry_run=self.dry_run, check=True)
        run(["brew", "upgrade"], dry_run=self.dry_run, check=True)
        run(["brew", "cleanup"], dry_run=self.dry_run)
        run(["brew", "autoremove"], dry_run=self.dry_run)
        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        leaves_result = run(["brew", "leaves"])
        casks_result = run(["brew", "list", "--cask", "-1"])

        installed_formulae = set(leaves_result.stdout.strip().splitlines()) if leaves_result.ok else set()
        installed_casks = set(casks_result.stdout.strip().splitlines()) if casks_result.ok else set()

        declared_formulae = set(self._all_formulae())
        declared_casks = set(self._all_casks())
        ignored = set(self.config.get_ignore_list("brew"))

        untracked_formulae = sorted(installed_formulae - declared_formulae - ignored)
        untracked_casks = sorted(installed_casks - declared_casks - ignored)
        missing_formulae = sorted(declared_formulae - installed_formulae)
        missing_casks = sorted(declared_casks - installed_casks)

        if untracked_formulae:
            self.output.info(f"    Formulae installed but not tracked: {', '.join(untracked_formulae)}")
        if untracked_casks:
            self.output.info(f"    Casks installed but not tracked: {', '.join(untracked_casks)}")
        if missing_formulae:
            self.output.info(f"    Formulae declared but not installed: {', '.join(missing_formulae)}")
        if missing_casks:
            self.output.info(f"    Casks declared but not installed: {', '.join(missing_casks)}")
        if not any([untracked_formulae, untracked_casks, missing_formulae, missing_casks]):
            self.output.info("    (no drift)")

        self.output.add_result(Result(
            manager=self.name,
            data={
                "untracked": {"formulae": untracked_formulae, "casks": untracked_casks},
                "missing": {"formulae": missing_formulae, "casks": missing_casks},
            },
        ))
