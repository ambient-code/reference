#!/bin/bash
# Run all E2E pattern tests and report results

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAILED=0
PASSED=0
RESULTS=""

echo "=========================================="
echo "  Pattern Validation E2E Test Suite"
echo "=========================================="
echo ""

run_test() {
    local test_name=$1
    local test_script=$2

    echo "Running: $test_name"
    echo "---"

    if bash "$SCRIPT_DIR/$test_script"; then
        PASSED=$((PASSED + 1))
        RESULTS="$RESULTS\n✅ $test_name"
    else
        FAILED=$((FAILED + 1))
        RESULTS="$RESULTS\n❌ $test_name"
    fi
    echo ""
}

# Run all pattern tests
run_test "Pattern 1: AQE" "test-pattern-1-aqe.sh"
run_test "Pattern 2: CBA" "test-pattern-2-cba.sh"
run_test "Pattern 3: Dependabot" "test-pattern-3-dependabot.sh"
run_test "Pattern 4: GHA" "test-pattern-4-gha.sh"
run_test "Pattern 5: Issue-to-PR" "test-pattern-5-issue-to-pr.sh"
run_test "Pattern 6: Multi-Agent" "test-pattern-6-multi-agent.sh"
run_test "Pattern 7: PR Review" "test-pattern-7-pr-review.sh"
run_test "Pattern 8: Security" "test-pattern-8-security.sh"
run_test "Pattern 9: Self-Review" "test-pattern-9-self-review.sh"
run_test "Pattern 10: Stale" "test-pattern-10-stale.sh"
run_test "Pattern 11: Testing" "test-pattern-11-testing.sh"

# Summary
echo "=========================================="
echo "  Test Results Summary"
echo "=========================================="
echo -e "$RESULTS"
echo ""
echo "Passed: $PASSED / $((PASSED + FAILED))"
echo "Failed: $FAILED / $((PASSED + FAILED))"
echo ""

if [[ $FAILED -gt 0 ]]; then
    echo "❌ SOME TESTS FAILED"
    exit 1
else
    echo "✅ ALL TESTS PASSED"
    exit 0
fi
