"""Subprocess runner with capture, error handling, and dry-run support."""

from __future__ import annotations

import subprocess
from dataclasses import dataclass


@dataclass
class RunResult:
    returncode: int
    stdout: str
    stderr: str

    @property
    def ok(self) -> bool:
        return self.returncode == 0


def run(
    cmd: list[str],
    *,
    dry_run: bool = False,
    check: bool = False,
    cwd: str | None = None,
    capture: bool = True,
) -> RunResult:
    if dry_run:
        import sys

        print(f"  [dry-run] {' '.join(cmd)}", file=sys.stderr)
        return RunResult(returncode=0, stdout="", stderr="")

    result = subprocess.run(
        cmd,
        capture_output=capture,
        text=True,
        cwd=cwd,
    )

    if check and result.returncode != 0:
        msg = f"Command failed: {' '.join(cmd)}\n{result.stderr.strip()}"
        raise RuntimeError(msg)

    return RunResult(
        returncode=result.returncode,
        stdout=result.stdout if capture else "",
        stderr=result.stderr if capture else "",
    )
