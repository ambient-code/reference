#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Validating Mermaid diagrams..."
echo ""

if ! command -v mmdc &> /dev/null; then
    echo -e "${YELLOW}Warning: mermaid-cli (mmdc) is not installed${NC}"
    echo "Install with: npm install -g @mermaid-js/mermaid-cli"
    echo ""
    echo "Falling back to syntax-only validation..."
    MMDC_AVAILABLE=false
else
    MMDC_AVAILABLE=true
fi

ERRORS=0
TOTAL=0

validate_markdown_file() {
    local file="$1"
    local block_num=0
    local in_mermaid=false
    local mermaid_content=""
    local line_num=0
    local block_start_line=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        line_num=$((line_num + 1))
        
        if [[ "$line" =~ ^\`\`\`mermaid ]]; then
            in_mermaid=true
            mermaid_content=""
            block_start_line=$line_num
            continue
        fi
        
        if [[ "$in_mermaid" == true ]]; then
            if [[ "$line" =~ ^\`\`\` ]]; then
                in_mermaid=false
                block_num=$((block_num + 1))
                TOTAL=$((TOTAL + 1))
                
                local temp_file="$TEMP_DIR/diagram_${block_num}.mmd"
                echo "$mermaid_content" > "$temp_file"
                
                if [[ "$MMDC_AVAILABLE" == true ]]; then
                    if mmdc -i "$temp_file" -o "$TEMP_DIR/output.svg" 2>"$TEMP_DIR/error.log"; then
                        echo -e "${GREEN}✓${NC} $file:$block_start_line (block $block_num)"
                    else
                        echo -e "${RED}✗${NC} $file:$block_start_line (block $block_num)"
                        echo "  Error: $(head -3 "$TEMP_DIR/error.log")"
                        ERRORS=$((ERRORS + 1))
                    fi
                else
                    local has_error=false
                    if ! echo "$mermaid_content" | head -1 | grep -qE '^[[:space:]]*(flowchart|sequenceDiagram|classDiagram|stateDiagram|erDiagram|gantt|pie|gitGraph|journey|mindmap|timeline|quadrantChart|sankey|xychart|block)'; then
                        echo -e "${RED}✗${NC} $file:$block_start_line (block $block_num)"
                        echo "  Error: No valid diagram type found on first line"
                        has_error=true
                        ERRORS=$((ERRORS + 1))
                    fi
                    
                    if [[ "$has_error" == false ]]; then
                        echo -e "${YELLOW}?${NC} $file:$block_start_line (block $block_num) - syntax check only"
                    fi
                fi
            else
                mermaid_content+="$line"$'\n'
            fi
        fi
    done < "$file"
}

echo "=== Standalone .mmd files ==="
MMD_FILES=$(find "$REPO_ROOT" -name "*.mmd" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null || true)

if [ -z "$MMD_FILES" ]; then
    echo "No standalone .mmd files found"
else
    for file in $MMD_FILES; do
        TOTAL=$((TOTAL + 1))
        if [[ "$MMDC_AVAILABLE" == true ]]; then
            if mmdc -i "$file" -o "$TEMP_DIR/output.svg" 2>"$TEMP_DIR/error.log"; then
                echo -e "${GREEN}✓${NC} $file"
            else
                echo -e "${RED}✗${NC} $file"
                echo "  Error: $(head -3 "$TEMP_DIR/error.log")"
                ERRORS=$((ERRORS + 1))
            fi
        else
            echo -e "${YELLOW}?${NC} $file - skipped (mmdc not available)"
        fi
    done
fi

echo ""
echo "=== Inline mermaid blocks in markdown ==="

MD_FILES=$(find "$REPO_ROOT" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null || true)

if [ -z "$MD_FILES" ]; then
    echo "No markdown files found"
else
    for file in $MD_FILES; do
        if grep -q '```mermaid' "$file" 2>/dev/null; then
            validate_markdown_file "$file"
        fi
    done
fi

echo ""
echo "=== Summary ==="
echo "Total diagrams checked: $TOTAL"

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Errors found: $ERRORS${NC}"
    exit 1
elif [ $TOTAL -eq 0 ]; then
    echo "No Mermaid diagrams found to validate"
    exit 0
else
    echo -e "${GREEN}All $TOTAL diagram(s) valid!${NC}"
    exit 0
fi
