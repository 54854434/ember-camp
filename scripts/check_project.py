#!/usr/bin/env python3
"""Run engine-level checks with isolated Linux user data and strict log checks."""
from __future__ import annotations

import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
TESTS = (
    ("tests/test_construction.gd", r"BUILD CHECKS: \d+ passed, 0 failed"),
    ("tests/test_save.gd", r"SAVE CHECKS: \d+ passed, 0 failed"),
    ("tests/test_rules.gd", r"RULE CHECKS: \d+ passed, 0 failed"),
    ("tests/test_world_generation.gd", r"WORLD CHECKS: \d+ passed, 0 failed"),
    ("tests/test_touch.gd", r"TOUCH CHECKS: \d+ passed, 0 failed"),
    ("tests/smoke.gd", r"SCENE SMOKE: chunks, extraction, raid simulation passed"),
)


def run(engine: str, args: list[str], environment: dict[str, str], marker: str = "") -> bool:
    try:
        result = subprocess.run(
            [engine, "--headless", "--path", str(ROOT), *args],
            cwd=ROOT, env=environment, capture_output=True, text=True, timeout=120,
        )
    except subprocess.TimeoutExpired:
        print(f"FAIL: engine timed out: {' '.join(args)}", file=sys.stderr)
        return False
    output = result.stdout + result.stderr
    bad_log = re.search(r"SCRIPT ERROR|Parse Error|^ERROR:", output, re.MULTILINE)
    success = result.returncode == 0 and not bad_log and (not marker or re.search(marker, output))
    if not success:
        print(output)
        print(f"FAIL: {' '.join(args)} (exit {result.returncode})", file=sys.stderr)
        return False
    for line in result.stdout.splitlines():
        if "CHECKS:" in line or "SCENE SMOKE:" in line:
            print(line)
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default="godot", help="Godot 4.4.1 executable or command")
    args = parser.parse_args()
    # Godot honors XDG_DATA_HOME on Linux. Do not pretend that this isolates a
    # macOS/Windows profile; contributors on those hosts can use Linux CI.
    if not sys.platform.startswith("linux"):
        parser.error("This isolated runner currently supports Linux; use the GitHub Linux checks on other hosts.")
    engine = shutil.which(args.godot)
    if not engine:
        parser.error(f"Godot executable not found: {args.godot}")
    version = subprocess.check_output([engine, "--version"], text=True).strip()
    if not version.startswith("4.4.1."):
        parser.error(f"Expected pinned Godot 4.4.1, got {version}; review world fixtures before upgrading.")
    if not (ROOT / "assets/NotoSansCJKsc-Regular.otf").is_file():
        parser.error("Chinese font missing; run: python3 scripts/fetch_font.py")
    scratch = ROOT / ".godot" / "checks"
    scratch.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="run-", dir=scratch) as directory:
        environment = os.environ.copy()
        environment["XDG_DATA_HOME"] = str(Path(directory) / "import")
        if not run(engine, ["--editor", "--import", "--quit"], environment):
            return 1
        for test, marker in TESTS:
            environment["XDG_DATA_HOME"] = str(Path(directory) / Path(test).stem)
            if not run(engine, ["--script", test], environment, marker):
                return 1
    print("PROJECT CHECKS: all passed; gameplay profiles were isolated")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

