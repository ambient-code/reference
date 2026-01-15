#!/bin/bash
# E2E Test: Pattern 2 - Codebase Agent (CBA)
# Tests that CBA configuration files exist and are complete

set -e

echo "=== E2E Test: Pattern 2 - CBA ==="

# Test 1: Verify codebase-agent.md exists
echo "Test 1: Verify codebase-agent.md exists..."
if [[ -f ".claude/agents/codebase-agent.md" ]]; then
    echo "✅ codebase-agent.md exists"
else
    echo "❌ codebase-agent.md missing"
    exit 1
fi

# Test 2: Verify autonomy levels are documented
echo "Test 2: Verify autonomy levels documented..."
if grep -qi "autonomy" .claude/agents/codebase-agent.md; then
    echo "✅ Autonomy levels documented"
else
    echo "❌ Autonomy levels not documented"
    exit 1
fi

# Test 3: Verify context directory exists
echo "Test 3: Verify context directory exists..."
if [[ -d ".claude/context" ]]; then
    echo "✅ Context directory exists"
else
    echo "❌ Context directory missing"
    exit 1
fi

# Test 4: Verify architecture.md exists
echo "Test 4: Verify architecture.md exists..."
if [[ -f ".claude/context/architecture.md" ]]; then
    echo "✅ architecture.md exists"
else
    echo "❌ architecture.md missing"
    exit 1
fi

# Test 5: Verify security-standards.md exists
echo "Test 5: Verify security-standards.md exists..."
if [[ -f ".claude/context/security-standards.md" ]]; then
    echo "✅ security-standards.md exists"
else
    echo "❌ security-standards.md missing"
    exit 1
fi

# Test 6: Verify testing-patterns.md exists
echo "Test 6: Verify testing-patterns.md exists..."
if [[ -f ".claude/context/testing-patterns.md" ]]; then
    echo "✅ testing-patterns.md exists"
else
    echo "❌ testing-patterns.md missing"
    exit 1
fi

# Test 7: Verify self-review protocol exists
echo "Test 7: Verify self-review protocol..."
if grep -qi "self-review" .claude/agents/codebase-agent.md; then
    echo "✅ Self-review protocol documented"
else
    echo "❌ Self-review protocol not documented"
    exit 1
fi

echo ""
echo "=== Pattern 2 (CBA): ALL TESTS PASSED ✅ ==="
