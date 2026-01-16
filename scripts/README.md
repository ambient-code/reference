# Scripts Directory

Automation scripts for the Ambient Code reference repository.

## Repomap Management

### `update-repomap.sh`

Updates or validates the repository map (`.repomap.txt`) - an AI-friendly code structure map that optimizes context window usage.

**Usage:**

```bash
# Regenerate repomap
./scripts/update-repomap.sh

# Validate repomap is current (CI usage)
./scripts/update-repomap.sh --check

# Show help
./scripts/update-repomap.sh --help
```

**Features:**

- Automatically regenerates `.repomap.txt` using `repomap.py`
- Validates that repomap is current (useful for CI)
- Clear error messages with dependency installation hints
- Used by pre-commit hook to auto-update on code changes

**When to use:**

- After adding/removing files or functions
- Before creating pull requests
- When structural changes occur
- Automatically triggered by pre-commit hook

**Dependencies:** Installed via `requirements.txt`:

```bash
uv pip install -r requirements.txt
```

## Documentation Validation

### `validate-mermaid.sh`

Validates all Mermaid diagrams in the documentation.

**Usage:**

```bash
./scripts/validate-mermaid.sh
```

**Purpose:** Ensures Mermaid diagrams are syntactically correct before committing, preventing broken diagrams in documentation.

## Development Setup

### `setup.sh`

Initial repository setup script.

**Usage:**

```bash
./scripts/setup.sh
```

**What it does:**

- Installs dependencies
- Sets up pre-commit hooks
- Initializes development environment

## Demo Recording

### `record-demo.sh`

Records demonstration videos/screenshots for documentation.

**Usage:**

```bash
./scripts/record-demo.sh
```

## Autonomous Review

Scripts for automated code review workflows.

### `autonomous-review/review-reference.sh`

Performs automated review of reference documentation.

**Usage:**

```bash
./scripts/autonomous-review/review-reference.sh
```

## Validation

Scripts for continuous validation and testing.

### `validation/autonomous-fix-loop-template.sh`

Template for autonomous validation and fix loops.

### `validation/tests/`

Test scripts for validation workflows:

- `run-all.sh` - Run all validation tests
- `test-autonomous-fix-loop.sh` - Test autonomous fix loop

## Quick Reference

**Common workflows:**

```bash
# Setup new development environment
./scripts/setup.sh

# Update repomap after code changes
./scripts/update-repomap.sh

# Validate documentation
./scripts/validate-mermaid.sh
markdownlint docs/**/*.md --fix

# Run all validation tests
./scripts/validation/tests/run-all.sh
```

## CI Integration

These scripts are integrated into GitHub Actions workflows:

- **`update-repomap.sh --check`** - CI job validates repomap is current
- **`validate-mermaid.sh`** - CI job validates diagrams before merge
- **Pre-commit hook** - Auto-runs `update-repomap.sh` on code changes

## Development Notes

- All scripts use `#!/usr/bin/env bash` for portability
- Scripts include error handling (`set -euo pipefail`)
- Scripts provide helpful error messages with actionable suggestions
- Scripts follow the "fail fast" principle
