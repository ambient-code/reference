#!/bin/bash
#
# lint-all.sh - Run all validation checks
#
# Usage: ./scripts/lint-all.sh
#
# Runs:
# - Markdown linting
# - Documentation pair validation
# - Mermaid diagram validation
# - Shell script validation
# - Style guide compliance
#
# Exit codes:
#   0 - All checks passed
#   1 - One or more checks failed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track overall status
OVERALL_EXIT=0

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Ambient Code Reference Repository Linter     ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo

cd "$REPO_ROOT"

# ============================================================================
# 1. Markdown Linting
# ============================================================================
echo -e "${BLUE}[1/6] Markdown Linting${NC}"
echo "Running markdownlint on docs/**/*.md..."

if command -v markdownlint &> /dev/null; then
    if markdownlint 'docs/**/*.md' --config .markdownlint.json; then
        echo -e "${GREEN}✓${NC} Markdown linting passed"
    else
        echo -e "${RED}✗${NC} Markdown linting failed"
        OVERALL_EXIT=1
    fi
else
    echo -e "${YELLOW}⚠${NC} markdownlint not installed - skipping (install: npm install -g markdownlint-cli)"
fi

echo

# ============================================================================
# 2. Documentation Pairs
# ============================================================================
echo -e "${BLUE}[2/6] Documentation Pairs${NC}"
echo "Validating standard and Terry documentation pairs..."

if [ -x "$SCRIPT_DIR/check-doc-pairs.sh" ]; then
    if "$SCRIPT_DIR/check-doc-pairs.sh"; then
        echo -e "${GREEN}✓${NC} Documentation pairs validated"
    else
        echo -e "${RED}✗${NC} Documentation pair validation failed"
        OVERALL_EXIT=1
    fi
else
    echo -e "${RED}✗${NC} check-doc-pairs.sh not found or not executable"
    OVERALL_EXIT=1
fi

echo

# ============================================================================
# 3. Mermaid Diagrams
# ============================================================================
echo -e "${BLUE}[3/6] Mermaid Diagrams${NC}"
echo "Validating Mermaid diagram syntax..."

if [ -x "$SCRIPT_DIR/validate-mermaid.sh" ]; then
    if "$SCRIPT_DIR/validate-mermaid.sh"; then
        echo -e "${GREEN}✓${NC} Mermaid diagrams validated"
    else
        echo -e "${RED}✗${NC} Mermaid diagram validation failed"
        OVERALL_EXIT=1
    fi
else
    echo -e "${YELLOW}⚠${NC} validate-mermaid.sh not found or not executable - skipping"
fi

echo

# ============================================================================
# 4. Shell Scripts
# ============================================================================
echo -e "${BLUE}[4/6] Shell Scripts${NC}"
echo "Running shellcheck on scripts/*.sh..."

if command -v shellcheck &> /dev/null; then
    SHELLCHECK_FAILED=0
    for script in scripts/*.sh; do
        if [ -f "$script" ]; then
            if shellcheck "$script"; then
                echo -e "${GREEN}✓${NC} $(basename "$script")"
            else
                echo -e "${RED}✗${NC} $(basename "$script") - shellcheck failed"
                SHELLCHECK_FAILED=1
            fi
        fi
    done

    if [ $SHELLCHECK_FAILED -eq 0 ]; then
        echo -e "${GREEN}✓${NC} All shell scripts passed shellcheck"
    else
        echo -e "${RED}✗${NC} Some shell scripts failed shellcheck"
        OVERALL_EXIT=1
    fi
else
    echo -e "${YELLOW}⚠${NC} shellcheck not installed - skipping (install: apt-get install shellcheck)"
fi

echo

# ============================================================================
# 5. Style Guide Compliance
# ============================================================================
echo -e "${BLUE}[5/6] Style Guide Compliance${NC}"
echo "Checking for AI slop patterns and prohibited terminology..."

# AI slop patterns
AI_SLOP_FOUND=0
PATTERNS=(
    "it's worth noting"
    "it's important to note"
    "dive deep"
    "let's explore"
    "game-changer"
    "revolutionary"
    "cutting-edge"
)

for pattern in "${PATTERNS[@]}"; do
    if grep -ri "$pattern" docs/*.md 2>/dev/null; then
        echo -e "${RED}✗${NC} Found AI slop pattern: '$pattern'"
        AI_SLOP_FOUND=1
    fi
done

if [ $AI_SLOP_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No AI slop patterns detected"
else
    OVERALL_EXIT=1
fi

# Prohibited terminology
PROHIBITED_FOUND=0

# Check for "Amber" (should use "Codebase Agent" or "CBA")
if grep -ri "Amber" docs/ .claude/ 2>/dev/null | grep -v "STYLE_GUIDE.md"; then
    echo -e "${RED}✗${NC} Found 'Amber' terminology (use 'Codebase Agent' or 'CBA')"
    PROHIBITED_FOUND=1
fi

if [ $PROHIBITED_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No prohibited terminology found"
else
    OVERALL_EXIT=1
fi

echo

# ============================================================================
# 6. Script Permissions
# ============================================================================
echo -e "${BLUE}[6/6] Script Permissions${NC}"
echo "Verifying scripts are executable..."

PERMISSION_FAILED=0
for script in scripts/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo -e "${GREEN}✓${NC} $(basename "$script") is executable"
        else
            echo -e "${RED}✗${NC} $(basename "$script") is not executable - run: chmod +x $script"
            PERMISSION_FAILED=1
        fi
    fi
done

if [ $PERMISSION_FAILED -eq 1 ]; then
    OVERALL_EXIT=1
fi

echo

# ============================================================================
# Summary
# ============================================================================
echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                     Summary                       ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo

if [ $OVERALL_EXIT -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo
    echo "Template is ready to use."
else
    echo -e "${RED}❌ Some validations failed${NC}"
    echo
    echo "Please fix the issues above and run this script again."
fi

echo

exit $OVERALL_EXIT
