#!/bin/bash
# E2E Test: Pattern 10 - Stale Issue Management
# Tests that stale workflow is properly configured

set -e

echo "=== E2E Test: Pattern 10 - Stale Issue Management ==="

WORKFLOW=".github/workflows/stale.yml"

# Test 1: Verify workflow exists
echo "Test 1: Verify stale.yml exists..."
if [[ -f "$WORKFLOW" ]]; then
    echo "✅ stale.yml exists"
else
    echo "❌ stale.yml missing"
    exit 1
fi

# Test 2: Verify uses actions/stale
echo "Test 2: Verify uses actions/stale..."
if grep -q "actions/stale" "$WORKFLOW"; then
    echo "✅ Uses actions/stale"
else
    echo "❌ Does not use actions/stale"
    exit 1
fi

# Test 3: Verify schedule trigger configured
echo "Test 3: Verify schedule trigger..."
if grep -q "schedule" "$WORKFLOW"; then
    echo "✅ Schedule trigger configured"
else
    echo "❌ Schedule trigger not configured"
    exit 1
fi

# Test 4: Verify days-before-stale configured
echo "Test 4: Verify stale timing configured..."
if grep -q "days-before-stale" "$WORKFLOW"; then
    echo "✅ Stale timing configured"
else
    echo "❌ Stale timing not configured"
    exit 1
fi

# Test 5: Verify exempt labels configured
echo "Test 5: Verify exempt labels..."
if grep -q "exempt" "$WORKFLOW"; then
    echo "✅ Exempt labels configured"
else
    echo "❌ Exempt labels not configured"
    exit 1
fi

# Test 6: Verify stale message configured
echo "Test 6: Verify stale message..."
if grep -q "stale-issue-message\|stale-pr-message" "$WORKFLOW"; then
    echo "✅ Stale message configured"
else
    echo "❌ Stale message not configured"
    exit 1
fi

echo ""
echo "=== Pattern 10 (Stale): ALL TESTS PASSED ✅ ==="
