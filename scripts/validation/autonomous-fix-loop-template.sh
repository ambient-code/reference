#!/bin/bash
set -euo pipefail

VALIDATION_SCRIPT="${1:-./scripts/validation/check.sh}"
MAX_ITERATIONS="${2:-3}"

if [ ! -x "$VALIDATION_SCRIPT" ]; then
    echo "Error: Validation script not found or not executable: $VALIDATION_SCRIPT"
    exit 1
fi

for i in $(seq 1 "$MAX_ITERATIONS"); do
    echo "=== Validation Attempt $i/$MAX_ITERATIONS ==="

    if "$VALIDATION_SCRIPT"; then
        echo "Validation passed on attempt $i"
        exit 0
    fi

    echo "Validation failed on attempt $i"

    if [ "$i" -eq "$MAX_ITERATIONS" ]; then
        echo "Max iterations reached. Manual intervention required."
        exit 1
    fi

    echo "Attempting fix..."
done
