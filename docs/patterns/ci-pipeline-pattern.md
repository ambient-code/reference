# CI Pipeline Pattern

**Pattern**: Comprehensive CI pipeline for Python projects with linting, testing, validation, and security scanning.

**Problem**: Manual code quality checks are inconsistent, slow development, and allow bugs to reach production. Teams waste time catching issues that could be automated.

**Solution**: GitHub Actions workflow that enforces code quality standards automatically on every push and PR. Runs black, isort, pylint, pytest, JSON validation, and security scanning. Provides helpful feedback when checks fail.

---

## Quick Start (10 Minutes)

Get a production-ready CI pipeline running in your Python project.

### Prerequisites

```bash
# Your project should have:
# - Python 3.11+
# - requirements.txt for production dependencies
# - Some Python source code to check
```

### Step 1: Add Development Dependencies (2 min)

Create `requirements-dev.txt`:

```text
# Development dependencies
# Code formatting
black>=24.0.0
isort>=5.13.0

# Linting
pylint>=3.0.0

# Testing
pytest>=8.0.0
pytest-cov>=4.1.0

# Type checking (optional)
mypy>=1.8.0
types-requests>=2.31.0
```

### Step 2: Configure Black and Isort (1 min)

Create `pyproject.toml`:

```toml
[tool.black]
line-length = 120
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 120
```

### Step 3: Configure Pylint (1 min)

Create `.pylintrc`:

```ini
[MASTER]
ignore=.git,__pycache__,data

[MESSAGES CONTROL]
disable=
    missing-module-docstring,
    too-few-public-methods,
    line-too-long,
    fixme,
    broad-except

[FORMAT]
max-line-length=120

[DESIGN]
max-args=7
max-locals=20
max-branches=15
```

### Step 4: Create CI Workflow (3 min)

Create `.github/workflows/ci-pipeline.yml`:

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pull-requests: write

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python 3.11
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install -r requirements-dev.txt

      - name: Format check with Black
        run: |
          black --check --diff src/
        continue-on-error: false

      - name: Import sort check with isort
        run: |
          isort --check-only --diff src/
        continue-on-error: false

      - name: Lint with Pylint
        run: |
          pylint src/**/*.py --disable=C0114,C0115,C0116 --max-line-length=120
        continue-on-error: false

      - name: Run tests with pytest
        if: hashFiles('tests/**/*.py') != ''
        run: |
          pytest tests/ -v --cov=src --cov-report=term-missing
        continue-on-error: false

      - name: Check for common issues
        run: |
          echo "Checking for common Python issues..."

          # Check for print statements (should use logging)
          if grep -rn "print(" src/ --include="*.py" | grep -v "#.*print"; then
            echo "::warning::Consider using logging instead of print statements"
          fi

          # Check for TODO/FIXME comments
          if grep -rn "TODO\|FIXME" src/ --include="*.py"; then
            echo "::notice::Found TODO/FIXME comments - consider addressing before merge"
          fi

          # Check for bare except clauses
          if grep -rn "except:" src/ --include="*.py"; then
            echo "::warning::Bare except clauses found - specify exception types"
          fi

          echo "Common issues check complete"

      - name: Security check for secrets
        run: |
          echo "Checking for potential secrets..."

          # Check for hardcoded API keys
          if grep -rn -iE '(api[_-]?key|secret|token|password)\s*=\s*["\047][^"\047]{20,}' src/ --include="*.py"; then
            echo "::error::Potential hardcoded credentials found"
            exit 1
          fi

          echo "Security check passed"

      - name: Post quality report
        if: github.event_name == 'pull_request' && failure()
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: `## Quality Check Failed

            One or more quality checks failed. Please review the workflow logs for details.

            **Common fixes:**
            - Format code: \`black src/\`
            - Sort imports: \`isort src/\`
            - Fix linting issues: Review pylint output
            - Run tests: \`pytest tests/\`

            Run all checks locally:
            \`\`\`bash
            black src/
            isort src/
            pylint src/**/*.py --max-line-length=120
            pytest tests/ -v
            \`\`\`

            Push changes and the workflow will re-run automatically.`
            })
```

### Step 5: Test Locally (3 min)

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Format code
black src/

# Sort imports
isort src/

# Run lint
pylint src/**/*.py --max-line-length=120

# Run tests (if you have them)
pytest tests/ -v

# Commit and push
git add .
git commit -m "Add CI pipeline"
git push
```

**Done!** Your CI pipeline is now running on every push and PR.

---

## Real-World Example: Reporters Repository

The [ambient-code/reporters](https://github.com/ambient-code/reporters) repository uses this exact pattern:

### File Structure

```
reporters/
├── .github/
│   └── workflows/
│       └── ci-pipeline.yml          # Main CI workflow
├── anthropic/
│   ├── src/signal/                  # Python source code
│   ├── requirements.txt             # Production deps
│   ├── requirements-dev.txt         # Dev deps
│   └── .pylintrc                    # Pylint config
├── pyproject.toml                   # Black/isort config
└── tests/                           # Tests (pytest)
```

### What Gets Checked

1. **Black**: Code formatting (120 char line length)
2. **isort**: Import organization (black profile)
3. **Pylint**: Code quality and potential bugs
4. **pytest**: Unit tests with coverage reporting
5. **JSON validation**: Data file structure checks
6. **Security**: Hardcoded credential detection
7. **Common issues**: Print statements, bare excepts, TODOs

### Results

- All PRs must pass CI before merge
- Automatic feedback on failures with fix suggestions
- Consistent code quality across all contributions
- No hardcoded secrets in code
- Zero manual quality checking

---

## Customization Guide

### Adjust Paths for Your Project

Update paths in the workflow to match your structure:

```yaml
# If your code is in different directories
- name: Format check with Black
  run: black --check --diff app/ lib/ utils/

# If you have multiple requirement files
- name: Install dependencies
  run: |
    pip install -r requirements/base.txt
    pip install -r requirements/dev.txt
```

### Add JSON Validation

For projects with JSON data files:

```yaml
- name: Validate JSON structure
  run: |
    python -c "import json; data = json.load(open('data/config.json')); print(f'Validated {len(data)} items')"
```

### Add Type Checking with mypy

```yaml
- name: Type check with mypy
  run: |
    mypy src/ --ignore-missing-imports
  continue-on-error: false
```

### Add Security Scanning

For more comprehensive security scanning:

```yaml
- name: Security scan with bandit
  run: |
    pip install bandit
    bandit -r src/ -ll
```

### Adjust Pylint Strictness

Edit `.pylintrc` to be more or less strict:

```ini
# More strict - fewer disabled rules
[MESSAGES CONTROL]
disable=
    missing-module-docstring,
    fixme

# Less strict - more disabled rules
[MESSAGES CONTROL]
disable=
    missing-module-docstring,
    missing-class-docstring,
    missing-function-docstring,
    too-few-public-methods,
    too-many-arguments,
    too-many-locals,
    line-too-long,
    fixme,
    broad-except,
    invalid-name
```

### Skip Tests If They Don't Exist

The workflow already handles this:

```yaml
- name: Run tests with pytest
  if: hashFiles('tests/**/*.py') != ''  # Only run if tests exist
  run: pytest tests/ -v
```

---

## Gotchas and Limitations

### 1. Black and Pylint Conflicts

**Issue**: Pylint's `line-too-long` check conflicts with black's formatting.

**Solution**: Disable `line-too-long` in `.pylintrc`:

```ini
[MESSAGES CONTROL]
disable=line-too-long
```

And configure both tools to use the same line length:

```toml
# pyproject.toml
[tool.black]
line-length = 120
```

```ini
# .pylintrc
[FORMAT]
max-line-length=120
```

### 2. isort and Black Import Ordering

**Issue**: isort and black can disagree on import formatting.

**Solution**: Configure isort to use black profile:

```toml
[tool.isort]
profile = "black"
```

### 3. Pip Cache Not Working

**Issue**: Dependencies install slowly every run.

**Solution**: Use actions/setup-python with cache:

```yaml
- name: Set up Python 3.11
  uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'  # Enable pip caching
```

### 4. Tests Failing in CI But Pass Locally

**Issue**: Different environments cause test failures.

**Solution**: Pin all dependency versions:

```bash
# Generate exact versions
pip freeze > requirements.txt

# Or use poetry/pipenv for deterministic installs
```

### 5. Security Regex False Positives

**Issue**: Legitimate code triggers hardcoded secret detection.

**Solution**: Refine the regex pattern or add exceptions:

```bash
# Exclude test files
if grep -rn -iE '(api[_-]?key|secret)' src/ --include="*.py" --exclude="*test*"; then
  echo "::error::Potential hardcoded credentials found"
  exit 1
fi
```

### 6. Workflow Permissions Issues

**Issue**: Cannot post comments on PRs.

**Solution**: Add proper permissions:

```yaml
permissions:
  contents: read
  pull-requests: write  # Required for posting comments
```

### 7. Continue-on-error Gotcha

**Issue**: Setting `continue-on-error: true` makes failures non-blocking.

**Solution**: Use `continue-on-error: false` (or omit it) for required checks:

```yaml
- name: Format check with Black
  run: black --check --diff src/
  continue-on-error: false  # Fail the workflow if black check fails
```

---

## Best Practices

### 1. Run Checks Locally First

Add a convenience script:

```bash
#!/bin/bash
# scripts/check.sh
set -e

echo "Running CI checks locally..."

black --check --diff src/
isort --check-only --diff src/
pylint src/**/*.py --max-line-length=120
pytest tests/ -v

echo "All checks passed!"
```

### 2. Auto-fix Before Committing

Add a pre-commit hook:

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Auto-format
black src/
isort src/

# Re-stage formatted files
git add -u

# Run checks
pylint src/**/*.py --max-line-length=120
pytest tests/ -v
```

### 3. Use Same Config Everywhere

One `.pylintrc` for:
- Local development
- CI pipeline
- Pre-commit hooks

One `pyproject.toml` for:
- Black formatting
- isort configuration
- Project metadata

### 4. Cache Dependencies Aggressively

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements*.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-
```

### 5. Fail Fast for Critical Issues

Order checks from fastest/most critical to slowest:

```yaml
1. Security checks (fast, critical)
2. Black formatting (fast, easy fix)
3. isort (fast, easy fix)
4. Pylint (medium, may need refactoring)
5. Tests (slow, may require investigation)
```

### 6. Provide Helpful Error Messages

Use GitHub Actions annotations:

```bash
echo "::error::Hardcoded credentials found in src/api.py:42"
echo "::warning::Consider using logging instead of print"
echo "::notice::Found 3 TODO comments to address"
```

### 7. Document Expected Local Workflow

Add to your README:

```markdown
## Development Workflow

Before committing:
1. `black src/` - Format code
2. `isort src/` - Sort imports
3. `pylint src/**/*.py` - Check for issues
4. `pytest tests/` - Run tests

Or use the convenience script: `./scripts/check.sh`
```

---

## Manual Setup Alternative

If you prefer to set up CI manually:

### Using GitHub CLI

```bash
# Create workflow directory
mkdir -p .github/workflows

# Copy workflow from this pattern
# (paste the YAML from Step 4 above)

# Add required files
touch requirements-dev.txt .pylintrc pyproject.toml

# Commit and push
git add .github/ requirements-dev.txt .pylintrc pyproject.toml
git commit -m "Add CI pipeline"
git push
```

### Using GitHub Web UI

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Click "New workflow"
4. Click "set up a workflow yourself"
5. Paste the workflow YAML from Step 4
6. Commit directly to main or create a PR

---

## Integration with Branch Protection

Once CI is working, require it to pass before merging:

1. Go to Settings > Branches
2. Click "Add rule" for `main` branch
3. Enable "Require status checks to pass before merging"
4. Select `ci` (the job name from the workflow)
5. Save changes

Now all PRs must pass CI before they can be merged.

See [branch-protection-automation.md](branch-protection-automation.md) for automated setup.

---

## Cost and Performance

### GitHub Actions Usage

- **Free tier**: 2,000 minutes/month for private repos
- **Typical run time**: 2-5 minutes per workflow
- **Optimization**: Use pip caching to reduce to 1-2 minutes

### Compute Resources

```yaml
# Default: Standard 2-core Ubuntu runner
runs-on: ubuntu-latest

# For faster runs (if you have GitHub Pro/Enterprise):
runs-on: ubuntu-latest-4-core
```

---

## Troubleshooting

### CI Passes Locally But Fails in GitHub Actions

**Check:**
1. Python version matches (3.11 in both places)
2. Dependencies are pinned to same versions
3. Environment variables are set correctly
4. File paths are correct (case-sensitive on Linux)

### Workflow Not Triggering

**Check:**
1. Workflow file is in `.github/workflows/`
2. YAML syntax is valid (use `yamllint`)
3. Trigger conditions match your branch names
4. Repository Actions are enabled in Settings

### Permission Denied Errors

**Check:**
1. Workflow has correct permissions block
2. GITHUB_TOKEN has required scopes
3. Protected branch rules allow workflow to run

---

## Related Patterns

- [dev-dependencies-pattern.md](dev-dependencies-pattern.md) - Managing development dependencies
- [branch-protection-automation.md](branch-protection-automation.md) - Automating branch protection setup
- [autonomous-quality-enforcement.md](autonomous-quality-enforcement.md) - Validation loops and git hooks
- [testing-patterns.md](testing-patterns.md) - Test organization and best practices
- [security-patterns.md](security-patterns.md) - Security scanning and hardening

---

## Summary

This CI pipeline pattern provides:

- **Automated quality enforcement** on every push and PR
- **Fast feedback** with helpful error messages
- **Security scanning** to prevent credential leaks
- **Consistent standards** across all contributors
- **Low maintenance** with sensible defaults

Copy the Quick Start steps, customize for your project, and ship with confidence.
