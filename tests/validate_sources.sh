#!/usr/bin/env bash
# SPDX-License-Identifier: PMPL-1.0-or-later
# validate_sources.sh — checks all .res files have SPDX headers
# ReScript source files are not handled by deno lint, so we validate headers instead.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PASS=0
FAIL=0

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

echo "=== befunge93-vault-cracker: source SPDX header check ==="

# Collect all .res files in src/ and examples/
res_files=()
while IFS= read -r -d '' f; do
    res_files+=("$f")
done < <(find "$REPO_ROOT/src" "$REPO_ROOT/examples" -name "*.res" -print0 2>/dev/null)

if [ "${#res_files[@]}" -eq 0 ]; then
    echo "SKIP: no .res files found — nothing to check"
    exit 0
fi

for file in "${res_files[@]}"; do
    rel="${file#$REPO_ROOT/}"
    if grep -q "SPDX-License-Identifier" "$file"; then
        pass "$rel has SPDX header"
    else
        fail "$rel missing SPDX header"
    fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
exit 0
