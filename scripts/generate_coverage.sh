#!/usr/bin/env bash
set -euo pipefail

WORKDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKDIR"

echo "Running Flutter tests with coverage..."
flutter test --coverage

LCOV_FILE="coverage/lcov.info"
if [[ ! -f "$LCOV_FILE" ]]; then
  echo "Error: coverage file not found at $LCOV_FILE"
  echo "Make sure tests ran and created coverage data."
  exit 1
fi

if ! command -v genhtml >/dev/null 2>&1; then
  echo "genhtml not found. To generate HTML coverage install lcov." 
  echo "On Debian/Ubuntu: sudo apt install lcov"
  exit 1
fi

OUTDIR="coverage/html"
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

echo "Generating HTML coverage into $OUTDIR..."
genhtml "$LCOV_FILE" -o "$OUTDIR"

echo "HTML report generated: file://$WORKDIR/$OUTDIR/index.html"

echo "Done."
