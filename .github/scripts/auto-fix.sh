#!/bin/bash
# Auto-fix script for Autonomous Quality Enforcement (AQE) pattern
# This script automatically fixes common issues

set -e

echo "=== Running AQE Auto-Fix ==="

# Fix markdown linting issues
if command -v markdownlint &> /dev/null; then
    echo "Running markdownlint --fix..."
    markdownlint docs/**/*.md README.md CLAUDE.md CONTRIBUTING.md --fix 2>/dev/null || true
    echo "✅ Markdown auto-fix complete"
else
    echo "⚠️ markdownlint not installed, skipping markdown fixes"
fi

# Fix trailing whitespace
echo "Removing trailing whitespace..."
find docs -name "*.md" -exec sed -i 's/[[:space:]]*$//' {} \; 2>/dev/null || true
echo "✅ Trailing whitespace removed"

# Ensure files end with newline
echo "Ensuring files end with newline..."
find docs -name "*.md" -exec sh -c 'tail -c1 "$1" | read -r _ || echo >> "$1"' _ {} \; 2>/dev/null || true
echo "✅ Newlines added"

echo ""
echo "=== AQE Auto-Fix Complete ✅ ==="
echo "Run check.sh to verify all issues are resolved"
