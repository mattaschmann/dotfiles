"""Abstract base for package managers."""

from __future__ import annotations

from abc import ABC, abstractmethod

from pkgctl.config import Config
from pkgctl.output import Output


class Manager(ABC):
    name: str

    def __init__(self, config: Config, output: Output, *, dry_run: bool = False) -> None:
        self.config = config
        self.output = output
        self.dry_run = dry_run

    @abstractmethod
    def is_available(self) -> bool: ...

    @abstractmethod
    def update(self) -> None: ...

    @abstractmethod
    def drift(self) -> None: ...

    def diff(self) -> None:
        pass
