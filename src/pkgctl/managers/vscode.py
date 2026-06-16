"""VS Code extension manager."""

from __future__ import annotations

import shutil

from pkgctl.managers.base import Manager
from pkgctl.output import Result
from pkgctl.runner import run


class Vscode(Manager):
    name = "vscode"

    def is_available(self) -> bool:
        return shutil.which("code") is not None

    def update(self) -> None:
        extensions = self.config.get_list("vscode", "extensions")
        if not extensions:
            self.output.add_result(Result(manager=self.name))
            return

        self.output.info("==> Installing VS Code extensions...")
        for ext in extensions:
            run(["code", "--install-extension", ext, "--force"], dry_run=self.dry_run)

        self.output.add_result(Result(manager=self.name))

    def drift(self) -> None:
        self.output.info("    (vscode extensions are idempotent, no drift check)")
        self.output.add_result(Result(manager=self.name))
