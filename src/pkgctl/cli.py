"""CLI entry point for pkgctl."""

from __future__ import annotations

import sys
from pathlib import Path

import click

from pkgctl.config import Config
from pkgctl.managers import MANAGER_MAP, get_managers
from pkgctl.output import Output


@click.group()
@click.option("--json", "use_json", is_flag=True, help="Output structured JSON for agent consumption.")
@click.option("--dry-run", is_flag=True, help="Preview commands without executing.")
@click.option("--packages-file", type=click.Path(exists=True), help="Override packages.toml path.")
@click.pass_context
def main(ctx: click.Context, use_json: bool, dry_run: bool, packages_file: str | None) -> None:
    """Declarative cross-platform package manager for dotfiles."""
    ctx.ensure_object(dict)
    pkg_path = Path(packages_file) if packages_file else None
    ctx.obj["config"] = Config(pkg_path)
    ctx.obj["output"] = Output(use_json=use_json)
    ctx.obj["dry_run"] = dry_run


def _validate_managers(managers: tuple[str, ...]) -> tuple[str, ...]:
    for m in managers:
        if m not in MANAGER_MAP:
            available = ", ".join(sorted(MANAGER_MAP.keys()))
            raise click.BadParameter(f"Unknown manager '{m}'. Available: {available}")
    return managers


@main.command()
@click.argument("managers", nargs=-1)
@click.pass_context
def update(ctx: click.Context, managers: tuple[str, ...]) -> None:
    """Update packages for all or specific managers."""
    managers = _validate_managers(managers)
    config = ctx.obj["config"]
    output = ctx.obj["output"]
    dry_run = ctx.obj["dry_run"]

    for mgr in get_managers(managers, config, output, dry_run=dry_run):
        if not mgr.is_available():
            output.info(f"==> Skipping {mgr.name} (not available)")
            continue
        try:
            mgr.update()
        except RuntimeError as e:
            output.error(f"ERROR [{mgr.name}]: {e}")

    sys.exit(output.flush())


@main.command()
@click.argument("managers", nargs=-1)
@click.pass_context
def drift(ctx: click.Context, managers: tuple[str, ...]) -> None:
    """Report drift between declared packages and installed state."""
    managers = _validate_managers(managers)
    config = ctx.obj["config"]
    output = ctx.obj["output"]
    dry_run = ctx.obj["dry_run"]

    for mgr in get_managers(managers, config, output, dry_run=dry_run):
        if not mgr.is_available():
            output.info(f"==> Skipping {mgr.name} (not available)")
            continue
        output.info(f"=== {mgr.name.title()} Drift ===")
        try:
            mgr.drift()
        except RuntimeError as e:
            output.error(f"ERROR [{mgr.name}]: {e}")

    sys.exit(output.flush())


@main.command("diff")
@click.argument("managers", nargs=-1)
@click.pass_context
def diff_cmd(ctx: click.Context, managers: tuple[str, ...]) -> None:
    """Show pending upstream changes (opencode plugins, dotbot)."""
    managers = _validate_managers(managers)
    config = ctx.obj["config"]
    output = ctx.obj["output"]
    dry_run = ctx.obj["dry_run"]

    from pkgctl.managers.base import Manager as BaseManager

    for mgr in get_managers(managers, config, output, dry_run=dry_run):
        if not mgr.is_available():
            continue
        if type(mgr).diff is BaseManager.diff:
            continue
        try:
            mgr.diff()
        except RuntimeError as e:
            output.error(f"ERROR [{mgr.name}]: {e}")

    sys.exit(output.flush())


@main.command("list")
@click.argument("manager", required=False)
@click.pass_context
def list_cmd(ctx: click.Context, manager: str | None) -> None:
    """Show packages declared in packages.toml."""
    config: Config = ctx.obj["config"]
    output: Output = ctx.obj["output"]

    sections = [manager] if manager else sorted(MANAGER_MAP.keys())
    for section in sections:
        if section not in MANAGER_MAP:
            output.error(f"Unknown manager: {section}")
            continue
        output.info(f"=== {section} ===")
        section_data = config.get_section(section)
        for key, val in section_data.items():
            if isinstance(val, list):
                output.info(f"  {key}: {', '.join(val)}")
            elif isinstance(val, dict):
                for subkey, subval in val.items():
                    if isinstance(subval, list):
                        output.info(f"  {key}.{subkey}: {', '.join(subval)}")

    sys.exit(output.flush())


@main.command()
@click.pass_context
def brewfile(ctx: click.Context) -> None:
    """Generate Brewfile from packages.toml."""
    from pkgctl.managers.brew import Brew

    config: Config = ctx.obj["config"]
    output: Output = ctx.obj["output"]
    dry_run: bool = ctx.obj["dry_run"]

    mgr = Brew(config, output, dry_run=dry_run)
    content = mgr.generate_brewfile()
    brewfile_path = config.repo_root / "Brewfile"

    if dry_run:
        output.info(content)
    else:
        brewfile_path.write_text(content)
        output.info(f"Brewfile generated at {brewfile_path}")

    sys.exit(0)
