#!/bin/bash
# E2E Test: Pattern 6 - Multi-Agent Code Review
# Tests that multi-agent code review documentation exists

set -e

echo "=== E2E Test: Pattern 6 - Multi-Agent Code Review ==="

DOC="docs/patterns/multi-agent-code-review.md"

# Test 1: Verify documentation exists
echo "Test 1: Verify multi-agent-code-review.md exists..."
if [[ -f "$DOC" ]]; then
    echo "✅ multi-agent-code-review.md exists"
else
    echo "❌ multi-agent-code-review.md missing"
    exit 1
fi

# Test 2: Verify Architecture Advisor documented
echo "Test 2: Verify Architecture Advisor documented..."
if grep -qi "architecture" "$DOC"; then
    echo "✅ Architecture Advisor documented"
else
    echo "❌ Architecture Advisor not documented"
    exit 1
fi

# Test 3: Verify Simplification Advisor documented
echo "Test 3: Verify Simplification Advisor documented..."
if grep -qi "simplification" "$DOC"; then
    echo "✅ Simplification Advisor documented"
else
    echo "❌ Simplification Advisor not documented"
    exit 1
fi

# Test 4: Verify Security Advisor documented
echo "Test 4: Verify Security Advisor documented..."
if grep -qi "security" "$DOC"; then
    echo "✅ Security Advisor documented"
else
    echo "❌ Security Advisor not documented"
    exit 1
fi

# Test 5: Verify confidence thresholds documented
echo "Test 5: Verify confidence thresholds documented..."
if grep -qE "(80%|90%|confidence)" "$DOC"; then
    echo "✅ Confidence thresholds documented"
else
    echo "❌ Confidence thresholds not documented"
    exit 1
fi

# Test 6: Verify finding categories documented (CRITICAL, WARNING, INFO)
echo "Test 6: Verify finding categories documented..."
if grep -q "CRITICAL" "$DOC" && grep -q "WARNING" "$DOC"; then
    echo "✅ Finding categories documented"
else
    echo "❌ Finding categories not documented"
    exit 1
fi

echo ""
echo "=== Pattern 6 (Multi-Agent): ALL TESTS PASSED ✅ ==="
