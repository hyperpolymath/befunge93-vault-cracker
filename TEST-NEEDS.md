# TEST-NEEDS.md — CRG Grade B Test Suite

<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->

This document records the six independently runnable test targets required for
CRG Grade B compliance.

## Grade B Requirements

CRG Grade B requires **6 independently runnable test targets**, each producing
a clear pass/fail result via a Justfile recipe.

## Test Targets

| Target | Recipe | Implementation | Description |
|--------|--------|---------------|-------------|
| T1 | `just test-zig` | `zig test ffi/zig/test/integration_test.zig` | FFI integration test |
| T2 | `just test-structure` | `bash tests/validate_structure.sh` | Required files/directories present |
| T3 | `just test-nickel` | `nickel typecheck contractiles/k9/template-yard.k9.ncl` | K9 contractile type-checks |
| T4 | `just test-lint` | `bash tests/validate_sources.sh` | All .res files have SPDX headers |
| T5 | `just test-examples` | `bash tests/validate_examples.sh` | examples/ directory has content |
| T6 | `just test-ffi` | `bash tests/validate_ffi.sh` | ffi/zig/ structure complete |

## Running All Tests

```
just test
```

## Notes

- T1 and T3 skip gracefully if `zig` / `nickel` are not installed.
- All bash scripts use the PASS/FAIL counter pattern and exit non-zero on failure.
- Scripts are executable (`chmod +x`).
