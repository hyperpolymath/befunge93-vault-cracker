#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# validate_examples.sh — checks examples/ directory exists and has content.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== befunge93-vault-cracker: examples directory check ==="

EXAMPLES_DIR="$REPO_ROOT/examples"

if [ ! -d "$EXAMPLES_DIR" ]; then
    fail "examples/ directory does not exist"
else
    pass "examples/ directory exists"

    example_count=$(find "$EXAMPLES_DIR" -maxdepth 2 -type f | wc -l)
    if [ "$example_count" -gt 0 ]; then
        pass "examples/ contains $example_count file(s)"
    else
        fail "examples/ directory is empty"
    fi
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
