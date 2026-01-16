#!/bin/bash
# E2E Test: Pattern 11 - Testing Patterns
# Tests that test pyramid structure exists and tests pass

set -e

echo "=== E2E Test: Pattern 11 - Testing Patterns ==="

# Test 1: Verify tests directory exists
echo "Test 1: Verify tests directory exists..."
if [[ -d "tests" ]]; then
    echo "✅ tests directory exists"
else
    echo "❌ tests directory missing"
    exit 1
fi

# Test 2: Verify unit tests directory exists
echo "Test 2: Verify unit tests directory..."
if [[ -d "tests/unit" ]]; then
    echo "✅ tests/unit exists"
else
    echo "❌ tests/unit missing"
    exit 1
fi

# Test 3: Verify integration tests directory exists
echo "Test 3: Verify integration tests directory..."
if [[ -d "tests/integration" ]]; then
    echo "✅ tests/integration exists"
else
    echo "❌ tests/integration missing"
    exit 1
fi

# Test 4: Verify e2e tests directory exists
echo "Test 4: Verify e2e tests directory..."
if [[ -d "tests/e2e" ]]; then
    echo "✅ tests/e2e exists"
else
    echo "❌ tests/e2e missing"
    exit 1
fi

# Test 5: Verify pytest.ini exists
echo "Test 5: Verify pytest.ini exists..."
if [[ -f "pytest.ini" ]]; then
    echo "✅ pytest.ini exists"
else
    echo "❌ pytest.ini missing"
    exit 1
fi

# Test 6: Verify conftest.py exists
echo "Test 6: Verify conftest.py exists..."
if [[ -f "tests/conftest.py" ]]; then
    echo "✅ conftest.py exists"
else
    echo "❌ conftest.py missing"
    exit 1
fi

# Test 7: Run all tests
echo "Test 7: Run full test suite..."
if python -m pytest tests/ -v --tb=short 2>&1; then
    echo "✅ All tests passed"
else
    echo "❌ Some tests failed"
    exit 1
fi

echo ""
echo "=== Pattern 11 (Testing): ALL TESTS PASSED ✅ ==="
