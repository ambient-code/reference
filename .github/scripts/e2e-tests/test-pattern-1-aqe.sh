#!/bin/bash
# E2E Test: Pattern 1 - Autonomous Quality Enforcement (AQE)
# Tests that check.sh and auto-fix.sh work correctly

set -e

echo "=== E2E Test: Pattern 1 - AQE ==="

# Test 1: Verify check.sh exists and is executable
echo "Test 1: Verify check.sh exists..."
if [[ -x ".github/scripts/check.sh" ]]; then
    echo "✅ check.sh exists and is executable"
else
    echo "❌ check.sh missing or not executable"
    exit 1
fi

# Test 2: Verify auto-fix.sh exists and is executable
echo "Test 2: Verify auto-fix.sh exists..."
if [[ -x ".github/scripts/auto-fix.sh" ]]; then
    echo "✅ auto-fix.sh exists and is executable"
else
    echo "❌ auto-fix.sh missing or not executable"
    exit 1
fi

# Test 3: Verify validate.yml workflow exists
echo "Test 3: Verify validate.yml workflow exists..."
if [[ -f ".github/workflows/validate.yml" ]]; then
    echo "✅ validate.yml workflow exists"
else
    echo "❌ validate.yml workflow missing"
    exit 1
fi

# Test 4: Run check.sh and verify it executes
echo "Test 4: Run check.sh..."
if .github/scripts/check.sh; then
    echo "✅ check.sh executed successfully"
else
    echo "❌ check.sh failed"
    exit 1
fi

# Test 5: Verify CLAUDE.md has AQE process rule
echo "Test 5: Verify AQE process rule in CLAUDE.md..."
if grep -q "Autonomous Quality Enforcement" CLAUDE.md; then
    echo "✅ AQE process rule found in CLAUDE.md"
else
    echo "❌ AQE process rule missing from CLAUDE.md"
    exit 1
fi

echo ""
echo "=== Pattern 1 (AQE): ALL TESTS PASSED ✅ ==="
