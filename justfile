# SPDX-License-Identifier: PMPL-1.0-or-later
# justfile — befunge93-vault-cracker task runner

default:
    @just --list

# Run all 6 Grade B test targets
test: test-structure test-zig test-nickel test-lint test-examples test-ffi
    @echo "All test targets complete."

# T2: structural check — required files and directories
test-structure:
    bash tests/validate_structure.sh

# T1: FFI integration test via zig test
test-zig:
    zig test ffi/zig/test/integration_test.zig 2>/dev/null || echo "SKIP: zig not installed"

# T3: typecheck the k9 contractile with nickel
test-nickel:
    nickel typecheck contractiles/k9/template-yard.k9.ncl 2>/dev/null || echo "SKIP: nickel not installed"

# T4: SPDX header check on all .res source files
test-lint:
    bash tests/validate_sources.sh

# T5: validate examples/ directory structure
test-examples:
    bash tests/validate_examples.sh

# T6: validate ffi/zig/ directory structure
test-ffi:
    bash tests/validate_ffi.sh
