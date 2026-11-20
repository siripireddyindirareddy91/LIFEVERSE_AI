"""Audit exact public hosted Dart package versions using OSV's batch API."""

import argparse
import json
from pathlib import Path
import re
import sys
import urllib.request


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="reports/mobile-advisories.json")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    lock = (root / "mobile/pubspec.lock").read_text(encoding="utf-8")
    packages = []
    for match in re.finditer(
        r"^  ([A-Za-z0-9_]+):\n(.*?)(?=^  [A-Za-z0-9_]+:|^sdks:|\Z)", lock, re.M | re.S
    ):
        name, body = match.groups()
        if re.search(r"^    source: hosted$", body, re.M):
            version = re.search(r'^    version: "([^"]+)"$', body, re.M)
            if version is None:
                raise ValueError(f"Missing locked version for {name}")
            packages.append(
                {"package": {"name": name, "ecosystem": "Pub"}, "version": version[1]}
            )
    if not packages:
        raise ValueError("No hosted packages parsed; refusing an empty audit")
    request = urllib.request.Request(
        "https://api.osv.dev/v1/querybatch",
        data=json.dumps({"queries": packages}).encode(),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        results = json.load(response)["results"]
    if len(results) != len(packages):
        raise ValueError("Incomplete advisory response")
    findings = [
        {
            "name": package["package"]["name"],
            "version": package["version"],
            "advisories": result["vulns"],
        }
        for package, result in zip(packages, results, strict=True)
        if result.get("vulns")
    ]
    report = {
        "service": "https://osv.dev",
        "packages_checked": len(packages),
        "findings": findings,
    }
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(
        f"Audited {len(packages)} hosted Dart package versions; {len(findings)} affected packages."
    )
    for finding in findings:
        print(
            finding["name"],
            finding["version"],
            [v["id"] for v in finding["advisories"]],
        )
    return 1 if findings else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as error:
        print(
            f"Mobile advisory audit could not complete: {type(error).__name__}",
            file=sys.stderr,
        )
        sys.exit(2)
