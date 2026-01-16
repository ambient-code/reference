#!/bin/bash
# E2E Test: Pattern 3 - Dependabot Auto-Merge
# Tests that Dependabot configuration and auto-merge workflow exist

set -e

echo "=== E2E Test: Pattern 3 - Dependabot Auto-Merge ==="

# Test 1: Verify dependabot.yml exists
echo "Test 1: Verify dependabot.yml exists..."
if [[ -f ".github/dependabot.yml" ]]; then
    echo "✅ dependabot.yml exists"
else
    echo "❌ dependabot.yml missing"
    exit 1
fi

# Test 2: Verify dependabot-auto-merge.yml workflow exists
echo "Test 2: Verify dependabot-auto-merge.yml exists..."
if [[ -f ".github/workflows/dependabot-auto-merge.yml" ]]; then
    echo "✅ dependabot-auto-merge.yml exists"
else
    echo "❌ dependabot-auto-merge.yml missing"
    exit 1
fi

# Test 3: Verify dependabot.yml has package-ecosystem
echo "Test 3: Verify package-ecosystem configured..."
if grep -q "package-ecosystem" .github/dependabot.yml; then
    echo "✅ package-ecosystem configured"
else
    echo "❌ package-ecosystem not configured"
    exit 1
fi

# Test 4: Verify auto-merge workflow checks for dependabot
echo "Test 4: Verify auto-merge checks for dependabot..."
if grep -qi "dependabot" .github/workflows/dependabot-auto-merge.yml; then
    echo "✅ Auto-merge workflow checks for dependabot"
else
    echo "❌ Auto-merge workflow doesn't check for dependabot"
    exit 1
fi

# Test 5: Verify auto-merge uses dependabot metadata
echo "Test 5: Verify dependabot metadata action used..."
if grep -q "dependabot/fetch-metadata" .github/workflows/dependabot-auto-merge.yml; then
    echo "✅ dependabot/fetch-metadata action used"
else
    echo "❌ dependabot/fetch-metadata action not found"
    exit 1
fi

echo ""
echo "=== Pattern 3 (Dependabot): ALL TESTS PASSED ✅ ==="
