#!/bin/bash
# E2E Test: Pattern 9 - Self-Review Reflection
# Tests that self-review protocol is documented in CBA

set -e

echo "=== E2E Test: Pattern 9 - Self-Review Reflection ==="

CBA_CONFIG=".claude/agents/codebase-agent.md"

# Test 1: Verify CBA config exists
echo "Test 1: Verify codebase-agent.md exists..."
if [[ -f "$CBA_CONFIG" ]]; then
    echo "✅ codebase-agent.md exists"
else
    echo "❌ codebase-agent.md missing"
    exit 1
fi

# Test 2: Verify self-review section exists
echo "Test 2: Verify self-review section..."
if grep -qi "self-review" "$CBA_CONFIG"; then
    echo "✅ Self-review section exists"
else
    echo "❌ Self-review section missing"
    exit 1
fi

# Test 3: Verify edge cases checklist item
echo "Test 3: Verify edge cases in checklist..."
if grep -qi "edge case" "$CBA_CONFIG"; then
    echo "✅ Edge cases in checklist"
else
    echo "❌ Edge cases not in checklist"
    exit 1
fi

# Test 4: Verify security checklist item
echo "Test 4: Verify security in checklist..."
if grep -qi "security" "$CBA_CONFIG"; then
    echo "✅ Security in checklist"
else
    echo "❌ Security not in checklist"
    exit 1
fi

# Test 5: Verify error handling checklist item
echo "Test 5: Verify error handling in checklist..."
if grep -qi "error handling" "$CBA_CONFIG"; then
    echo "✅ Error handling in checklist"
else
    echo "❌ Error handling not in checklist"
    exit 1
fi

# Test 6: Verify iteration limit documented
echo "Test 6: Verify iteration limit..."
if grep -qE "(iteration|maximum|max)" "$CBA_CONFIG"; then
    echo "✅ Iteration limit documented"
else
    echo "❌ Iteration limit not documented"
    exit 1
fi

echo ""
echo "=== Pattern 9 (Self-Review): ALL TESTS PASSED ✅ ==="
