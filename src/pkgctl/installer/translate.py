"""Translate [install*] sections from packages.toml into dotbot directives."""

from __future__ import annotations

import glob as globmod
from pathlib import Path
from typing import Any

from pkgctl.installer import detect_os


def _resolve_os_pattern(path_template: str, current_os: str, repo_root: Path) -> str | None:
    if "{os}" not in path_template:
        return path_template

    pattern = path_template.replace("{os}", "*")
    full_pattern = str(repo_root / pattern)
    matches = globmod.glob(full_pattern)

    os_specific = path_template.replace("{os}", current_os)
    full_os_path = repo_root / os_specific
    if full_os_path.exists():
        return os_specific

    return None


def build_directives(install_config: dict[str, Any], repo_root: Path) -> list[dict]:
    current_os = detect_os()
    directives: list[dict] = []

    defaults = install_config.get("defaults", {})
    if defaults:
        directives.append({"defaults": defaults})

    clean_dirs = install_config.get("clean", [])
    if clean_dirs:
        directives.append({"clean": clean_dirs})

    create_dirs = install_config.get("create", [])
    if create_dirs:
        directives.append({"create": create_dirs})

    links_common = install_config.get("links", {})
    links_os = install_config.get(f"links.{current_os}", {}) if isinstance(install_config.get("links"), dict) else {}

    if isinstance(links_common, dict):
        os_sub = links_common.get(current_os, {})
        pure_links = {k: v for k, v in links_common.items() if k != current_os and k not in ("osx", "wsl", "linux")}
    else:
        os_sub = {}
        pure_links = {}

    resolved_links: dict[str, Any] = {}

    for dest, source in pure_links.items():
        resolved = _resolve_link_source(source, current_os, repo_root)
        if resolved is not None:
            resolved_links[dest] = resolved

    for dest, source in os_sub.items():
        resolved = _resolve_link_source(source, current_os, repo_root)
        if resolved is not None:
            resolved_links[dest] = resolved

    if resolved_links:
        directives.append({"link": resolved_links})

    return directives


def _resolve_link_source(source: Any, current_os: str, repo_root: Path) -> Any | None:
    if isinstance(source, str):
        if "{os}" in source:
            resolved = _resolve_os_pattern(source, current_os, repo_root)
            return resolved
        return source
    elif isinstance(source, dict):
        path = source.get("path", "")
        if "{os}" in path:
            resolved = _resolve_os_pattern(path, current_os, repo_root)
            if resolved is None:
                return None
            return {**source, "path": resolved}
        return source
    return source
