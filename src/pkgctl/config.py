"""Loads and exposes packages.toml as typed accessors."""

from __future__ import annotations

import tomllib
from pathlib import Path
from typing import Any

_DEFAULT_PATH = Path(__file__).resolve().parents[2] / "packages.toml"


class Config:
    def __init__(self, path: Path | None = None) -> None:
        self.path = path or _DEFAULT_PATH
        with open(self.path, "rb") as f:
            self._data: dict[str, Any] = tomllib.load(f)

    def get_list(self, section: str, key: str) -> list[str]:
        parts = section.split(".")
        node = self._data
        for part in parts:
            node = node.get(part, {})
            if not isinstance(node, dict) and part != parts[-1]:
                return []
        if isinstance(node, dict):
            val = node.get(key, [])
            return val if isinstance(val, list) else []
        return []

    def get_section(self, section: str) -> dict[str, Any]:
        parts = section.split(".")
        node = self._data
        for part in parts:
            node = node.get(part, {})
            if not isinstance(node, dict):
                return {}
        return node if isinstance(node, dict) else {}

    @property
    def repo_root(self) -> Path:
        return self.path.parent
