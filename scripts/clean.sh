#!/usr/bin/env bash
# Full Dart-side reset. Doesn't touch iOS Pods (use fix_ios.sh for that).
#
# Run when freezed gen drifted, dep changes are flaky, or "this should work
# but doesn't" after a branch switch.
#
# Usage: ./scripts/clean.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

echo "→ flutter clean…"
flutter clean

echo "→ Removing .dart_tool and pubspec.lock…"
rm -rf .dart_tool pubspec.lock

echo "→ flutter pub get…"
flutter pub get

echo "✓ Clean complete."
