#!/usr/bin/env python3
"""
Generate coverage comment markdown from coverage data files.

This script aggregates coverage data from multiple JSON files and generates
a markdown comment suitable for posting to GitHub PRs.

Usage:
    python generate_coverage_comment.py <coverage_data_dir> <workflow_run_id> <workflow_run_url>

Input JSON format (per file):
    {
        "pr_number": 123,
        "component": "Backend",
        "pr_coverage": 85.5,
        "main_coverage": 82.0,
        "diff": 3.5
    }

Output:
    Markdown file written to stdout
"""

import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, List


def sanitize_component_name(name: str) -> str:
    """
    Sanitize component name to prevent injection attacks.

    Allows only alphanumeric characters, spaces, hyphens, and underscores.
    Truncates to 50 characters.
    """
    # Remove any non-safe characters and strip whitespace
    sanitized = re.sub(r'[^a-zA-Z0-9 _-]', '', name).strip()
    # Truncate to 50 chars
    return sanitized[:50] if sanitized else "Unknown"


def validate_number(value: Any, default: float = 0.0) -> float:
    """
    Validate that a value is a valid number.

    Returns the float value if valid, otherwise returns default.
    """
    try:
        num = float(value)
        # Check if it's a valid float (not NaN, not Inf)
        if num != num or num == float('inf') or num == float('-inf'):
            return default
        return num
    except (ValueError, TypeError):
        return default


def format_diff(diff: float) -> str:
    """
    Format diff value with appropriate sign.

    Args:
        diff: The difference value (can be positive, negative, or zero)

    Returns:
        Formatted string like "+3.5%" or "-2.1%" or "0.0%"
    """
    if diff > 0:
        return f"+{diff:.1f}%"
    elif diff < 0:
        return f"{diff:.1f}%"
    else:
        return "0.0%"


def load_coverage_data(coverage_dir: Path) -> List[Dict]:
    """
    Load and validate coverage data from all JSON files in directory.

    Args:
        coverage_dir: Path to directory containing coverage JSON files

    Returns:
        List of validated coverage data dictionaries
    """
    coverage_data = []

    # Find all JSON files in directory
    json_files = list(coverage_dir.glob("*.json"))

    if not json_files:
        print("⚠️  No coverage JSON files found", file=sys.stderr)
        return coverage_data

    for json_file in json_files:
        try:
            with open(json_file, 'r') as f:
                data = json.load(f)

            # Validate required fields
            component = sanitize_component_name(data.get('component', 'Unknown'))
            pr_coverage = validate_number(data.get('pr_coverage', 0))
            main_coverage = validate_number(data.get('main_coverage', 0))
            diff = validate_number(data.get('diff', 0))

            # Only include if we have valid data
            if component != "Unknown" or pr_coverage > 0:
                coverage_data.append({
                    'component': component,
                    'pr_coverage': pr_coverage,
                    'main_coverage': main_coverage,
                    'diff': diff
                })

        except (json.JSONDecodeError, IOError) as e:
            print(f"⚠️  Failed to read {json_file}: {e}", file=sys.stderr)
            continue

    return coverage_data


def generate_coverage_markdown(
    coverage_data: List[Dict],
    workflow_run_id: str,
    workflow_run_url: str
) -> str:
    """
    Generate markdown table from coverage data.

    Args:
        coverage_data: List of coverage data dictionaries
        workflow_run_id: GitHub workflow run ID
        workflow_run_url: GitHub workflow run URL

    Returns:
        Markdown string
    """
    lines = [
        "## 📊 Test Coverage Report",
        "",
        "Coverage results from automated tests:",
        "",
        "| Component | Coverage | Change |",
        "|-----------|----------|--------|"
    ]

    # Sort by component name for consistent ordering
    sorted_data = sorted(coverage_data, key=lambda x: x['component'])

    for item in sorted_data:
        component = item['component']
        pr_cov = item['pr_coverage']
        diff = item['diff']
        diff_display = format_diff(diff)

        lines.append(f"| {component} | {pr_cov:.1f}% | {diff_display} |")

    lines.extend([
        "",
        f"*Coverage generated from workflow run [#{workflow_run_id}]({workflow_run_url})*"
    ])

    return "\n".join(lines)


def main():
    """Main entry point."""
    if len(sys.argv) != 4:
        print("Usage: generate_coverage_comment.py <coverage_data_dir> <workflow_run_id> <workflow_run_url>", file=sys.stderr)
        sys.exit(1)

    coverage_dir = Path(sys.argv[1])
    workflow_run_id = sys.argv[2]
    workflow_run_url = sys.argv[3]

    # Validate coverage directory exists
    if not coverage_dir.exists():
        print(f"❌ Coverage directory not found: {coverage_dir}", file=sys.stderr)
        sys.exit(1)

    # Load coverage data
    coverage_data = load_coverage_data(coverage_dir)

    if not coverage_data:
        print("❌ No valid coverage data found", file=sys.stderr)
        sys.exit(1)

    # Generate markdown
    markdown = generate_coverage_markdown(coverage_data, workflow_run_id, workflow_run_url)

    # Output to stdout
    print(markdown)

    # Success message to stderr (so it doesn't pollute markdown output)
    print(f"✅ Generated coverage comment for {len(coverage_data)} component(s)", file=sys.stderr)


if __name__ == "__main__":
    main()
