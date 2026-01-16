#!/usr/bin/env bash
#
# Update repository map (.repomap.txt)
#
# This script regenerates the .repomap.txt file using repomap.py.
# The repomap provides AI-friendly context about code structure,
# reducing token usage while maintaining code understanding.
#
# Usage:
#   ./scripts/update-repomap.sh                # Update repomap
#   ./scripts/update-repomap.sh --check        # Validate repomap is current
#   ./scripts/update-repomap.sh --help         # Show help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPOMAP_FILE="$REPO_ROOT/.repomap.txt"
REPOMAP_PY="$REPO_ROOT/repomap.py"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Update or validate the repository map (.repomap.txt).

OPTIONS:
    --check     Validate that repomap is current (doesn't update)
    --help      Show this help message

EXAMPLES:
    # Regenerate repomap
    ./scripts/update-repomap.sh

    # Validate repomap is current (CI usage)
    ./scripts/update-repomap.sh --check

    # Manual regeneration
    python repomap.py . > .repomap.txt
EOF
}

check_dependencies() {
    if [[ ! -f "$REPOMAP_PY" ]]; then
        echo -e "${RED}Error: repomap.py not found at $REPOMAP_PY${NC}" >&2
        exit 1
    fi

    if ! command -v python3 &>/dev/null; then
        echo -e "${RED}Error: python3 not found. Install Python 3.11+${NC}" >&2
        exit 1
    fi
}

generate_repomap() {
    echo -e "${YELLOW}Generating repository map...${NC}"

    cd "$REPO_ROOT"

    # Generate new repomap
    local error_output
    if error_output=$(python3 "$REPOMAP_PY" . 2>&1 > "${REPOMAP_FILE}.new"); then
        mv "${REPOMAP_FILE}.new" "$REPOMAP_FILE"
        echo -e "${GREEN}✓ Repository map updated: $REPOMAP_FILE${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to generate repository map${NC}" >&2
        echo -e "${YELLOW}$error_output${NC}" >&2
        if echo "$error_output" | grep -q "tree-sitter packages not installed"; then
            echo -e "${YELLOW}Install dependencies: pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash${NC}" >&2
        fi
        rm -f "${REPOMAP_FILE}.new"
        return 1
    fi
}

check_repomap_current() {
    echo -e "${YELLOW}Checking if repomap is current...${NC}"

    if [[ ! -f "$REPOMAP_FILE" ]]; then
        echo -e "${RED}✗ Repomap file not found: $REPOMAP_FILE${NC}" >&2
        echo -e "${YELLOW}Run: ./scripts/update-repomap.sh${NC}" >&2
        return 1
    fi

    cd "$REPO_ROOT"

    # Generate temp repomap
    local error_output
    if ! error_output=$(python3 "$REPOMAP_PY" . 2>&1 > "${REPOMAP_FILE}.check"); then
        echo -e "${RED}✗ Failed to generate repomap for comparison${NC}" >&2
        echo -e "${YELLOW}$error_output${NC}" >&2
        if echo "$error_output" | grep -q "tree-sitter packages not installed"; then
            echo -e "${YELLOW}Install dependencies: pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash${NC}" >&2
        fi
        rm -f "${REPOMAP_FILE}.check"
        return 1
    fi

    # Compare with existing
    if diff -q "$REPOMAP_FILE" "${REPOMAP_FILE}.check" >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Repomap is current${NC}"
        rm -f "${REPOMAP_FILE}.check"
        return 0
    else
        echo -e "${RED}✗ Repomap is outdated${NC}" >&2
        echo -e "${YELLOW}Run: ./scripts/update-repomap.sh${NC}" >&2

        # Show diff if verbose
        if [[ "${VERBOSE:-0}" == "1" ]]; then
            echo -e "\n${YELLOW}Differences:${NC}"
            diff "$REPOMAP_FILE" "${REPOMAP_FILE}.check" || true
        fi

        rm -f "${REPOMAP_FILE}.check"
        return 1
    fi
}

main() {
    local check_mode=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                check_mode=true
                shift
                ;;
            --help)
                usage
                exit 0
                ;;
            *)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                usage
                exit 1
                ;;
        esac
    done

    check_dependencies

    if [[ "$check_mode" == true ]]; then
        check_repomap_current
    else
        generate_repomap
    fi
}

main "$@"
