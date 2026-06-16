"""Shell steps and doctor prerequisite checks."""

from __future__ import annotations

import shutil
from pathlib import Path
from typing import Any

from pkgctl.runner import run as run_cmd


def run_shell_steps(
    steps: list[dict[str, Any]],
    repo_root: Path,
    *,
    dry_run: bool = False,
) -> list[str]:
    errors: list[str] = []
    for step in steps:
        desc = step.get("description", step.get("command", ""))
        command = step.get("command", "")
        if not command:
            continue

        if dry_run:
            import sys
            print(f"  [dry-run] shell: {desc}", file=sys.stderr)
            continue

        result = run_cmd(
            ["/bin/bash", "-c", command],
            cwd=str(repo_root),
            check=False,
        )
        if not result.ok:
            errors.append(f"{desc}: {result.stderr.strip() or 'exit ' + str(result.returncode)}")

    return errors


def run_doctor(
    doctor_config: dict[str, Any],
    *,
    use_json: bool = False,
) -> tuple[list[dict], list[dict]]:
    found: list[dict] = []
    missing: list[dict] = []

    commands = doctor_config.get("commands", {})
    for cmd, url in commands.items():
        if shutil.which(cmd):
            found.append({"type": "command", "name": cmd})
        else:
            missing.append({"type": "command", "name": cmd, "url": url})

    dirs = doctor_config.get("dirs", {})
    for dir_path, url in dirs.items():
        expanded = Path(dir_path).expanduser()
        if expanded.is_dir():
            found.append({"type": "directory", "name": dir_path})
        else:
            missing.append({"type": "directory", "name": dir_path, "url": url})

    return found, missing
