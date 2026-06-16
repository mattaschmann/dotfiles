"""File copy operations for platform-specific deployments."""

from __future__ import annotations

import shutil
from pathlib import Path
from typing import Any

from pkgctl.installer import detect_os, expand_platform_vars


def run_copies(
    copies: list[dict[str, Any]],
    repo_root: Path,
    *,
    dry_run: bool = False,
) -> list[str]:
    current_os = detect_os()
    errors: list[str] = []

    for entry in copies:
        os_list = entry.get("os", [])
        if os_list and current_os not in os_list:
            continue

        source_template = entry.get("source", "")
        target_template = entry.get("target", "")

        source_path = source_template.replace("{os}", current_os)
        full_source = repo_root / source_path

        target_str = expand_platform_vars(target_template.replace("{os}", current_os))
        if target_str is None:
            errors.append(f"Cannot resolve platform vars in target: {target_template}")
            continue

        target_path = Path(target_str).expanduser()

        if not full_source.exists():
            errors.append(f"Source does not exist: {full_source}")
            continue

        if dry_run:
            import sys
            print(f"  [dry-run] copy {full_source} -> {target_path}", file=sys.stderr)
            continue

        target_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(str(full_source), str(target_path))

    return errors
