"""Structured output rendering for human and agent consumption."""

from __future__ import annotations

import json
import sys
from dataclasses import dataclass, field
from typing import Any


@dataclass
class Result:
    manager: str
    success: bool = True
    message: str = ""
    data: dict[str, Any] = field(default_factory=dict)
    errors: list[str] = field(default_factory=list)


class Output:
    def __init__(self, *, use_json: bool = False) -> None:
        self.use_json = use_json
        self._results: list[Result] = []

    def info(self, msg: str) -> None:
        if not self.use_json:
            print(msg)

    def error(self, msg: str) -> None:
        if not self.use_json:
            print(msg, file=sys.stderr)

    def add_result(self, result: Result) -> None:
        self._results.append(result)

    def flush(self) -> int:
        if self.use_json:
            payload = {}
            for r in self._results:
                entry: dict[str, Any] = {"success": r.success}
                if r.message:
                    entry["message"] = r.message
                if r.data:
                    entry.update(r.data)
                if r.errors:
                    entry["errors"] = r.errors
                payload[r.manager] = entry
            print(json.dumps(payload, indent=2))

        has_errors = any(not r.success for r in self._results)
        has_drift = any(r.data.get("untracked") or r.data.get("missing") for r in self._results)
        if has_errors:
            return 1
        if has_drift:
            return 2
        return 0
