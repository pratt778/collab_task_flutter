#!/usr/bin/env bash
# Pre-push sanity check: lint + tests.
#
# Run before pushing a branch or opening a PR. Mirrors what CI would run if
# you had one. Exits non-zero if either step fails.
#
# Usage: ./scripts/check.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

echo "→ flutter analyze…"
flutter analyze

echo "→ flutter test…"
flutter test

echo "✓ All checks passed."
