#!/bin/bash
# Validation script for Autonomous Quality Enforcement (AQE) pattern
# This script runs all quality checks and returns non-zero on failure

set -e

echo "=== Running AQE Validation Checks ==="

# Check if markdownlint is available
if command -v markdownlint &> /dev/null; then
    echo "Running markdownlint..."
    markdownlint docs/**/*.md README.md CLAUDE.md CONTRIBUTING.md 2>/dev/null || {
        echo "❌ Markdown linting failed"
        exit 1
    }
    echo "✅ Markdown linting passed"
else
    echo "⚠️ markdownlint not installed, skipping markdown checks"
fi

# Validate documentation structure
echo "Checking documentation structure..."
test -d docs/patterns || { echo "❌ docs/patterns/ missing"; exit 1; }
test -f docs/README.md || { echo "❌ docs/README.md missing"; exit 1; }
test -d docs/adr || { echo "❌ docs/adr/ missing"; exit 1; }
echo "✅ Documentation structure valid"

# Check for required CLAUDE.md
test -f CLAUDE.md || { echo "❌ CLAUDE.md missing"; exit 1; }
echo "✅ CLAUDE.md exists"

# Check for required agent configuration
test -f .claude/agents/codebase-agent.md || { echo "❌ .claude/agents/codebase-agent.md missing"; exit 1; }
echo "✅ Codebase agent configuration exists"

# Check for context files
test -d .claude/context || { echo "❌ .claude/context/ missing"; exit 1; }
echo "✅ Context directory exists"

echo ""
echo "=== All AQE Validation Checks Passed ✅ ==="
