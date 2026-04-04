#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# validate_ffi.sh — checks ffi/zig/ structure is complete.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

check_file() {
    local path="$REPO_ROOT/$1"
    if [ -f "$path" ]; then
        pass "file exists: $1"
    else
        fail "file missing: $1"
    fi
}

check_dir() {
    local path="$REPO_ROOT/$1"
    if [ -d "$path" ]; then
        pass "directory exists: $1"
    else
        fail "directory missing: $1"
    fi
}

echo "=== befunge93-vault-cracker: FFI structure check ==="

check_dir  "ffi/zig"
check_dir  "ffi/zig/src"
check_file "ffi/zig/build.zig"

# Verify src/main.zig exists
check_file "ffi/zig/src/main.zig"

# Verify integration test is present
check_dir  "ffi/zig/test"
check_file "ffi/zig/test/integration_test.zig"

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
