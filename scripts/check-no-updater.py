#!/usr/bin/env python3
"""Guard the local build against restoring the upstream updater. No Xcode needed."""

from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
paths = [
    *root.joinpath("Clipboard").rglob("*.swift"),
    *root.joinpath("Clipboard").rglob("*.plist"),
    *root.joinpath("Clipboard").rglob("*.xcstrings"),
    root / "Clipboard.xcodeproj/project.xcproj",
    root / "Clipboard.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved",
]
updater = re.compile(
    r"\bSparkle\b|\bSPU[A-Z]\w*|\bSU(?:FeedURL|PublicEDKey|AllowsAutomaticUpdates|"
    r"EnableAutomaticChecks|ScheduledCheckInterval)|[Uu]pdater|UpdateManager|"
    r"[Cc]heck(?:For)?Updates?|updateAvailable|appcast\.xml"
)
violations = [
    f"{path.relative_to(root)}:{number}: {line.strip()}"
    for path in paths
    for number, line in enumerate(path.read_text().splitlines(), 1)
    if updater.search(line)
]
assert not violations, "Upstream updater references found:\n" + "\n".join(violations)
print(f"PASS: no upstream updater references in {len(paths)} source/config files")
