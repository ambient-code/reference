#!/bin/bash
# E2E Test: Pattern 4 - GitHub Actions Automation Patterns
# Tests that all 4 sub-pattern workflows exist

set -e

echo "=== E2E Test: Pattern 4 - GHA Automation Patterns ==="

WORKFLOWS_DIR=".github/workflows"
FAILED=0

# Test 1: Issue-to-PR workflow
echo "Test 1: Verify issue-to-pr.yml exists..."
if [[ -f "$WORKFLOWS_DIR/issue-to-pr.yml" ]]; then
    echo "✅ issue-to-pr.yml exists"
else
    echo "❌ issue-to-pr.yml missing"
    FAILED=1
fi

# Test 2: PR Auto-Review workflow
echo "Test 2: Verify pr-review.yml exists..."
if [[ -f "$WORKFLOWS_DIR/pr-review.yml" ]]; then
    echo "✅ pr-review.yml exists"
else
    echo "❌ pr-review.yml missing"
    FAILED=1
fi

# Test 3: Dependabot Auto-Merge workflow
echo "Test 3: Verify dependabot-auto-merge.yml exists..."
if [[ -f "$WORKFLOWS_DIR/dependabot-auto-merge.yml" ]]; then
    echo "✅ dependabot-auto-merge.yml exists"
else
    echo "❌ dependabot-auto-merge.yml missing"
    FAILED=1
fi

# Test 4: Stale Issue Management workflow
echo "Test 4: Verify stale.yml exists..."
if [[ -f "$WORKFLOWS_DIR/stale.yml" ]]; then
    echo "✅ stale.yml exists"
else
    echo "❌ stale.yml missing"
    FAILED=1
fi

# Summary
if [[ $FAILED -eq 1 ]]; then
    echo ""
    echo "=== Pattern 4 (GHA): SOME TESTS FAILED ❌ ==="
    exit 1
fi

echo ""
echo "=== Pattern 4 (GHA): ALL TESTS PASSED ✅ ==="
