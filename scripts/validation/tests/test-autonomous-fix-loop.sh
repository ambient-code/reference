#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

echo "Testing autonomous-fix-loop-template.sh"

echo "Test 1: Passing validation should exit 0"
cat > "$TEST_DIR/pass.sh" << 'EOF'
#!/bin/bash
echo "Validation passed"
exit 0
EOF
chmod +x "$TEST_DIR/pass.sh"

if "$SCRIPT_DIR/autonomous-fix-loop-template.sh" "$TEST_DIR/pass.sh" 2>/dev/null; then
    echo "Test 1 passed"
else
    echo "Test 1 failed"
    exit 1
fi

echo "Test 2: Failing validation should exit 1"
cat > "$TEST_DIR/fail.sh" << 'EOF'
#!/bin/bash
echo "Validation failed"
exit 1
EOF
chmod +x "$TEST_DIR/fail.sh"

if ! "$SCRIPT_DIR/autonomous-fix-loop-template.sh" "$TEST_DIR/fail.sh" 2>/dev/null; then
    echo "Test 2 passed"
else
    echo "Test 2 failed"
    exit 1
fi

echo "Test 3: Missing script should exit 1"
if ! "$SCRIPT_DIR/autonomous-fix-loop-template.sh" "/nonexistent.sh" 2>/dev/null; then
    echo "Test 3 passed"
else
    echo "Test 3 failed"
    exit 1
fi

echo ""
echo "All tests passed"
