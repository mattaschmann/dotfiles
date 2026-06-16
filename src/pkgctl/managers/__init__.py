"""Manager registry — discovers and exposes all managers."""

from __future__ import annotations

from typing import TYPE_CHECKING

from pkgctl.managers.apt import Apt
from pkgctl.managers.brew import Brew
from pkgctl.managers.cargo import Cargo
from pkgctl.managers.npm import Npm
from pkgctl.managers.opencode import Opencode
from pkgctl.managers.uv_mgr import Uv
from pkgctl.managers.vscode import Vscode

if TYPE_CHECKING:
    from pkgctl.config import Config
    from pkgctl.managers.base import Manager
    from pkgctl.output import Output

ALL_MANAGERS: list[type[Manager]] = [Apt, Brew, Cargo, Uv, Npm, Opencode, Vscode]

MANAGER_MAP: dict[str, type[Manager]] = {m.name: m for m in ALL_MANAGERS}


def get_managers(
    names: tuple[str, ...],
    config: Config,
    output: Output,
    *,
    dry_run: bool = False,
) -> list[Manager]:
    if not names:
        classes = ALL_MANAGERS
    else:
        classes = [MANAGER_MAP[n] for n in names if n in MANAGER_MAP]

    return [cls(config, output, dry_run=dry_run) for cls in classes]
