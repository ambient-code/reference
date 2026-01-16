#!/bin/bash
# E2E Test: Pattern 5 - Issue-to-PR Automation
# Tests that issue-to-pr workflow is properly configured

set -e

echo "=== E2E Test: Pattern 5 - Issue-to-PR Automation ==="

WORKFLOW=".github/workflows/issue-to-pr.yml"

# Test 1: Verify workflow exists
echo "Test 1: Verify issue-to-pr.yml exists..."
if [[ -f "$WORKFLOW" ]]; then
    echo "✅ issue-to-pr.yml exists"
else
    echo "❌ issue-to-pr.yml missing"
    exit 1
fi

# Test 2: Verify workflow triggers on issue labeled
echo "Test 2: Verify triggers on issue labeled..."
if grep -q "issues:" "$WORKFLOW" && grep -q "labeled" "$WORKFLOW"; then
    echo "✅ Triggers on issue labeled"
else
    echo "❌ Does not trigger on issue labeled"
    exit 1
fi

# Test 3: Verify workflow checks for ready-for-pr label
echo "Test 3: Verify checks for ready-for-pr label..."
if grep -q "ready-for-pr" "$WORKFLOW"; then
    echo "✅ Checks for ready-for-pr label"
else
    echo "❌ Does not check for ready-for-pr label"
    exit 1
fi

# Test 4: Verify workflow has issue clarity analysis
echo "Test 4: Verify issue clarity analysis..."
if grep -qi "clarity\|acceptance criteria\|requirements" "$WORKFLOW"; then
    echo "✅ Issue clarity analysis present"
else
    echo "❌ Issue clarity analysis missing"
    exit 1
fi

# Test 5: Verify workflow can create PRs
echo "Test 5: Verify PR creation capability..."
if grep -q "gh pr create" "$WORKFLOW"; then
    echo "✅ PR creation configured"
else
    echo "❌ PR creation not configured"
    exit 1
fi

# Test 6: Verify workflow can post clarification comments
echo "Test 6: Verify clarification comment capability..."
if grep -q "gh issue comment" "$WORKFLOW"; then
    echo "✅ Clarification comments configured"
else
    echo "❌ Clarification comments not configured"
    exit 1
fi

echo ""
echo "=== Pattern 5 (Issue-to-PR): ALL TESTS PASSED ✅ ==="
