#!/bin/bash
# E2E Test: Pattern 8 - Security Patterns
# Tests that security module exists and tests pass

set -e

echo "=== E2E Test: Pattern 8 - Security Patterns ==="

# Test 1: Verify security module exists
echo "Test 1: Verify security.py exists..."
if [[ -f "src/core/security.py" ]]; then
    echo "✅ security.py exists"
else
    echo "❌ security.py missing"
    exit 1
fi

# Test 2: Verify sanitize_string function exists
echo "Test 2: Verify sanitize_string function..."
if grep -q "def sanitize_string" src/core/security.py; then
    echo "✅ sanitize_string function exists"
else
    echo "❌ sanitize_string function missing"
    exit 1
fi

# Test 3: Verify validate_slug function exists
echo "Test 3: Verify validate_slug function..."
if grep -q "def validate_slug" src/core/security.py; then
    echo "✅ validate_slug function exists"
else
    echo "❌ validate_slug function missing"
    exit 1
fi

# Test 4: Verify sanitize_path function exists
echo "Test 4: Verify sanitize_path function..."
if grep -q "def sanitize_path" src/core/security.py; then
    echo "✅ sanitize_path function exists"
else
    echo "❌ sanitize_path function missing"
    exit 1
fi

# Test 5: Verify security tests exist
echo "Test 5: Verify security tests exist..."
if [[ -f "tests/unit/test_security.py" ]]; then
    echo "✅ test_security.py exists"
else
    echo "❌ test_security.py missing"
    exit 1
fi

# Test 6: Run security unit tests
echo "Test 6: Run security unit tests..."
if python -m pytest tests/unit/test_security.py -v --tb=short 2>&1; then
    echo "✅ Security tests passed"
else
    echo "❌ Security tests failed"
    exit 1
fi

echo ""
echo "=== Pattern 8 (Security): ALL TESTS PASSED ✅ ==="
