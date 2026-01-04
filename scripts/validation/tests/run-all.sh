#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running all validation script tests"
echo "=================================="

for test in "$SCRIPT_DIR"/test-*.sh; do
    echo ""
    echo "Running: $(basename "$test")"
    echo "----------------------------------"
    bash "$test"
done

echo ""
echo "=================================="
echo "All test suites passed"
