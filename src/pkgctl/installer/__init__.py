"""Platform detection and OS-specific helpers."""

from __future__ import annotations

import platform
import subprocess
from pathlib import Path


def detect_os() -> str:
    if platform.system() == "Darwin":
        return "osx"
    try:
        uname_r = platform.release()
        if "WSL2" in uname_r:
            return "wsl"
    except Exception:
        pass
    return "linux"


def resolve_win_appdata() -> Path | None:
    try:
        result = subprocess.run(
            ["wslpath", subprocess.run(
                ["cmd.exe", "/C", "echo %APPDATA%"],
                capture_output=True, text=True
            ).stdout.strip()],
            capture_output=True, text=True,
        )
        if result.returncode == 0:
            return Path(result.stdout.strip())
    except (FileNotFoundError, OSError):
        pass
    return None


def expand_platform_vars(path: str) -> str | None:
    if "${WIN_APPDATA}" in path:
        appdata = resolve_win_appdata()
        if appdata is None:
            return None
        return path.replace("${WIN_APPDATA}", str(appdata))
    return path
