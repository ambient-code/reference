#!/bin/bash
# E2E Test: Pattern 7 - PR Auto-Review
# Tests that PR auto-review workflow is properly configured

set -e

echo "=== E2E Test: Pattern 7 - PR Auto-Review ==="

WORKFLOW=".github/workflows/pr-review.yml"

# Test 1: Verify workflow exists
echo "Test 1: Verify pr-review.yml exists..."
if [[ -f "$WORKFLOW" ]]; then
    echo "✅ pr-review.yml exists"
else
    echo "❌ pr-review.yml missing"
    exit 1
fi

# Test 2: Verify workflow triggers on pull_request
echo "Test 2: Verify triggers on pull_request..."
if grep -q "pull_request" "$WORKFLOW"; then
    echo "✅ Triggers on pull_request"
else
    echo "❌ Does not trigger on pull_request"
    exit 1
fi

# Test 3: Verify workflow skips draft PRs
echo "Test 3: Verify skips draft PRs..."
if grep -qi "draft" "$WORKFLOW"; then
    echo "✅ Draft PR handling configured"
else
    echo "❌ Draft PR handling not configured"
    exit 1
fi

# Test 4: Verify workflow checks for skip-review label
echo "Test 4: Verify skip-review label support..."
if grep -q "skip-review" "$WORKFLOW"; then
    echo "✅ skip-review label supported"
else
    echo "❌ skip-review label not supported"
    exit 1
fi

# Test 5: Verify security checks configured
echo "Test 5: Verify security checks..."
if grep -qi "secret\|password\|key\|security" "$WORKFLOW"; then
    echo "✅ Security checks configured"
else
    echo "❌ Security checks not configured"
    exit 1
fi

# Test 6: Verify workflow can post comments
echo "Test 6: Verify comment posting capability..."
if grep -q "gh pr comment\|issue comment\|comment" "$WORKFLOW"; then
    echo "✅ Comment posting configured"
else
    echo "❌ Comment posting not configured"
    exit 1
fi

echo ""
echo "=== Pattern 7 (PR Auto-Review): ALL TESTS PASSED ✅ ==="
