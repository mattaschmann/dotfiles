"""Run dotbot with generated directives."""

from __future__ import annotations

import json
import tempfile
from pathlib import Path

from pkgctl.runner import run as run_cmd


def run_dotbot(
    directives: list[dict],
    repo_root: Path,
    *,
    dry_run: bool = False,
    only: str | None = None,
) -> bool:
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".json", prefix="pkgctl-dotbot-", delete=False
    ) as f:
        json.dump(directives, f, indent=2)
        config_path = f.name

    try:
        cmd = ["dotbot", "-d", str(repo_root), "-c", config_path]
        if only:
            cmd.extend(["--only", only])
        result = run_cmd(cmd, dry_run=dry_run, check=False)
        return result.ok
    finally:
        Path(config_path).unlink(missing_ok=True)
