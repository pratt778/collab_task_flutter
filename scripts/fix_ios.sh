#!/usr/bin/env bash
# Fix iOS pod issues by nuking and reinstalling Pods.
#
# Run when you hit "pod install failed", "module not found", linker errors,
# or after switching branches with iOS dep changes.
#
# Usage: ./scripts/fix_ios.sh

set -euo pipefail

# Resolve to the project root regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR/ios"

echo "→ Deintegrating Pods…"
pod deintegrate

echo "→ Removing Podfile.lock and Pods/…"
rm -rf Pods Podfile.lock

echo "→ Reinstalling Pods…"
pod install --repo-update

echo "✓ iOS pods fixed."
