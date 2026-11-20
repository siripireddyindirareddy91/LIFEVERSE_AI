"""High-confidence accidental-secret check; prints paths, never matched values."""

from pathlib import Path
import re
import subprocess
import sys


def main():
    root = Path(__file__).resolve().parents[1]
    listed = (
        subprocess.run(
            ["git", "ls-files", "-z", "--cached", "--others", "--exclude-standard"],
            cwd=root,
            capture_output=True,
            check=True,
        )
        .stdout.decode()
        .split("\0")
    )
    patterns = [
        re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
        re.compile(r"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{50,})\b"),
        re.compile(r"\bsb_secret_[A-Za-z0-9_-]{20,}\b"),
        re.compile(r"\bsk-(?:proj-)?[A-Za-z0-9_-]{40,}\b"),
    ]
    failures = []
    for name in sorted(set(filter(None, listed))):
        path = root / name
        if not path.is_file():
            continue
        if path.name == ".env" or (
            name.startswith("mobile/config/")
            and name.endswith(".json")
            and not name.endswith(".example.json")
        ):
            failures.append(name)
            continue
        if path.stat().st_size > 5 * 1024 * 1024:
            continue
        try:
            content = path.read_text(encoding="utf-8")
        except UnicodeError:
            continue
        if any(pattern.search(content) for pattern in patterns):
            failures.append(name)
    if failures:
        print(
            "Possible secret or private configuration detected in: "
            + ", ".join(failures)
        )
        return 1
    print(
        f"Checked {len(set(filter(None, listed)))} repository files; no high-confidence secret patterns found."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
