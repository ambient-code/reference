# Development Dependencies Pattern

**Pattern**: Separate development tooling from production dependencies for cleaner, faster, and more secure Python projects.

**Problem**: Mixing dev tools (linters, formatters, test frameworks) with production dependencies creates bloated deployments, security vulnerabilities, and dependency conflicts. Production images include unnecessary tools that slow down builds and increase attack surface.

**Solution**: Use separate `requirements-dev.txt` for development-only dependencies, with unified configuration in `pyproject.toml` and `.pylintrc`. Development environment has full tooling, production environment is minimal and secure.

---

## Quick Start (5 Minutes)

Set up proper dependency separation for a Python project.

### Step 1: Create requirements-dev.txt (2 min)

Create a new file `requirements-dev.txt`:

```text
# Development dependencies
# Keep these separate from requirements.txt

# Code formatting
black>=24.0.0
isort>=5.13.0

# Linting
pylint>=3.0.0

# Testing
pytest>=8.0.0
pytest-cov>=4.1.0

# Type checking
mypy>=1.8.0
types-requests>=2.31.0
```

### Step 2: Create pyproject.toml (1 min)

Create `pyproject.toml` for tool configuration:

```toml
[tool.black]
line-length = 120
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 120

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_functions = ["test_*"]
addopts = "-v --cov=src --cov-report=term-missing"
```

### Step 3: Create .pylintrc (1 min)

Create `.pylintrc` with sensible defaults:

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

### Step 4: Update Your Workflow (1 min)

For local development:

```bash
# Install production dependencies
pip install -r requirements.txt

# Install dev dependencies
pip install -r requirements-dev.txt

# Now you can use all tools
black src/
isort src/
pylint src/**/*.py
pytest tests/
```

For CI/CD (update your workflow):

```yaml
- name: Install dependencies
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt  # Only in CI, not production
```

For production deployment:

```dockerfile
# Dockerfile - only install production deps
RUN pip install -r requirements.txt
# requirements-dev.txt is NOT installed
```

**Done!** You now have clean separation between dev and production dependencies.

---

## Real-World Example: Reporters Repository

The reporters repository demonstrates this pattern perfectly:

### File Structure

```
reporters/
├── anthropic/
│   ├── requirements.txt           # Production only (2 packages)
│   ├── requirements-dev.txt       # Development tools (6 packages)
│   └── .pylintrc                  # Pylint configuration
├── pyproject.toml                 # Black/isort configuration
└── .github/workflows/
    └── ci-pipeline.yml            # Installs both requirements files
```

### Production Dependencies (`anthropic/requirements.txt`)

```text
anthropic>=0.40.0
requests>=2.31.0
```

**Only 2 packages!** The absolute minimum needed to run the application.

### Development Dependencies (`anthropic/requirements-dev.txt`)

```text
# Code formatting
black>=24.0.0
isort>=5.13.0

# Linting
pylint>=3.0.0

# Testing
pytest>=8.0.0
pytest-cov>=4.1.0

# Type checking
mypy>=1.8.0
types-requests>=2.31.0
```

**6 packages** for development tooling. None of these ship to production.

### Unified Configuration (`pyproject.toml`)

```toml
[tool.black]
line-length = 120
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 120
```

Single source of truth for black and isort settings.

### Pylint Configuration (`anthropic/.pylintrc`)

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

Reasonable defaults that work for most projects.

### CI Pipeline Integration

The CI workflow installs both:

```yaml
- name: Install dependencies
  run: |
    python -m pip install --upgrade pip
    pip install -r anthropic/requirements.txt
    pip install -r anthropic/requirements-dev.txt
```

But production deploys only use `requirements.txt`.

---

## Benefits

### 1. Smaller Production Images

**Before (mixing dependencies):**
```dockerfile
FROM python:3.11-slim
COPY requirements.txt .
RUN pip install -r requirements.txt  # 50+ packages including pytest, black, etc.
```

Image size: 850 MB

**After (separated dependencies):**
```dockerfile
FROM python:3.11-slim
COPY requirements.txt .
RUN pip install -r requirements.txt  # Only 2-10 packages
```

Image size: 250 MB

**Savings: 600 MB (71% reduction)**

### 2. Faster Deployment

| Stage | Before | After | Improvement |
|-------|--------|-------|-------------|
| Pip install | 45s | 8s | 82% faster |
| Image build | 2m 30s | 45s | 70% faster |
| Image push | 1m 15s | 20s | 73% faster |

### 3. Reduced Security Surface

Fewer dependencies = fewer CVEs to track:

```bash
# Before: 50 packages to monitor for security issues
pip list | wc -l
# 50

# After: 2 packages to monitor
pip list | wc -l
# 2
```

### 4. Cleaner Dependency Graph

Production apps don't need:
- `pytest` and testing frameworks
- `black`, `isort` code formatters
- `pylint`, `mypy` static analyzers
- `pytest-cov` coverage tools

These are development tools, not runtime dependencies.

---

## Configuration Guide

### Black Configuration

```toml
[tool.black]
line-length = 120              # Match your team's preference (88 is default)
target-version = ['py311']      # Python version(s) to target
skip-string-normalization = false  # Normalize quote styles
extend-exclude = '''
/(
    \.eggs
  | \.git
  | \.mypy_cache
  | build
  | dist
)/
'''
```

### isort Configuration

```toml
[tool.isort]
profile = "black"              # Compatible with black
line_length = 120              # Match black's line length
force_single_line = false      # Allow multiple imports per line
known_first_party = ["myapp"]  # Your package name
known_third_party = ["anthropic", "requests"]
sections = ["FUTURE", "STDLIB", "THIRDPARTY", "FIRSTPARTY", "LOCALFOLDER"]
```

### Pylint Configuration

```ini
[MASTER]
ignore=.git,__pycache__,data,venv,.venv
jobs=4  # Parallel processing

[MESSAGES CONTROL]
# Start with these disabled, enable as you tighten standards
disable=
    missing-module-docstring,     # Require module docstrings
    missing-class-docstring,      # Require class docstrings
    missing-function-docstring,   # Require function docstrings
    too-few-public-methods,       # Allow simple classes
    too-many-arguments,           # Allow complex functions
    too-many-locals,              # Allow complex functions
    too-many-branches,            # Allow complex logic
    line-too-long,                # Handled by black
    fixme,                        # Allow TODO comments
    broad-except,                 # Allow except Exception
    invalid-name                  # Allow short variable names

[FORMAT]
max-line-length=120

[DESIGN]
max-args=7          # Increase if you have complex APIs
max-locals=20       # Increase for complex functions
max-branches=15     # Increase for complex logic
max-statements=50
```

### Pytest Configuration

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_functions = ["test_*"]
python_classes = ["Test*"]
addopts = """
    -v
    --strict-markers
    --cov=src
    --cov-report=term-missing
    --cov-report=html
    --cov-fail-under=80
"""
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
]
```

### Mypy Configuration

```toml
[tool.mypy]
python_version = "3.11"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
ignore_missing_imports = true
```

---

## Best Practices

### 1. Pin Major Versions, Allow Minor Updates

```text
# Good: Allow patches and minor updates
black>=24.0.0
pytest>=8.0.0

# Avoid: Unpinned (can break)
black
pytest

# Avoid: Exact pins (miss security patches)
black==24.1.1
pytest==8.0.2
```

### 2. Group Dependencies Logically

```text
# Development dependencies

# Code formatting
black>=24.0.0
isort>=5.13.0

# Linting
pylint>=3.0.0
flake8>=7.0.0

# Testing
pytest>=8.0.0
pytest-cov>=4.1.0
pytest-asyncio>=0.23.0

# Type checking
mypy>=1.8.0
types-requests>=2.31.0

# Development tools
ipython>=8.12.0
```

### 3. Keep pyproject.toml Simple

Only configure tools you actually use:

```toml
# Minimal configuration
[tool.black]
line-length = 120
target-version = ['py311']

[tool.isort]
profile = "black"
line_length = 120
```

Don't over-configure. Start simple, add options as needed.

### 4. Use Same Config in All Environments

```bash
# Local development
black --config pyproject.toml src/

# CI/CD
black --config pyproject.toml src/

# Pre-commit hook
black --config pyproject.toml src/
```

One config file, used everywhere.

### 5. Document Required Dev Setup

Add to your README:

```markdown
## Development Setup

1. Install production dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Install development dependencies:
   ```bash
   pip install -r requirements-dev.txt
   ```

3. Verify setup:
   ```bash
   black --version
   pytest --version
   pylint --version
   ```

## Code Quality Checks

Run before committing:

```bash
black src/
isort src/
pylint src/**/*.py
pytest tests/
```
```

### 6. Separate by Environment When Needed

For complex projects:

```
requirements/
├── base.txt           # Core production dependencies
├── production.txt     # Production-only (gunicorn, etc.)
├── development.txt    # Development tools
└── testing.txt        # Testing in CI
```

```text
# requirements/development.txt
-r base.txt
black>=24.0.0
pytest>=8.0.0
```

---

## Gotchas and Limitations

### 1. Black and Pylint Line Length Mismatch

**Problem**: Black formats to 120 chars, pylint complains.

**Solution**: Disable `line-too-long` in pylint, set both to same length:

```ini
# .pylintrc
[MESSAGES CONTROL]
disable=line-too-long

[FORMAT]
max-line-length=120
```

```toml
# pyproject.toml
[tool.black]
line-length = 120
```

### 2. isort and Black Import Conflicts

**Problem**: isort and black disagree on import formatting.

**Solution**: Configure isort to use black profile:

```toml
[tool.isort]
profile = "black"
```

This makes isort compatible with black's formatting.

### 3. Development Tools in Production

**Problem**: Accidentally installing dev dependencies in production.

**Solution**: Use separate Docker build stages:

```dockerfile
# Build stage - includes dev dependencies
FROM python:3.11-slim AS builder
COPY requirements.txt requirements-dev.txt ./
RUN pip install -r requirements.txt -r requirements-dev.txt
RUN pytest tests/  # Run tests during build

# Production stage - only production dependencies
FROM python:3.11-slim
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY src/ ./src/
CMD ["python", "-m", "src.main"]
```

### 4. Conflicting Dependencies

**Problem**: Dev tools require different versions than production.

**Solution**: Use virtual environments or Docker to isolate:

```bash
# Production environment
python -m venv venv-prod
source venv-prod/bin/activate
pip install -r requirements.txt

# Development environment
python -m venv venv-dev
source venv-dev/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
```

### 5. CI Installing Wrong Requirements

**Problem**: CI only installs production requirements, tests fail.

**Solution**: Explicitly install both in CI:

```yaml
- name: Install dependencies
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt  # Don't forget this!
```

### 6. pyproject.toml vs setup.py

**Problem**: Old projects use `setup.py` for everything.

**Solution**: Migrate gradually:

```python
# setup.py (old way)
setup(
    name="myapp",
    install_requires=["requests", "anthropic"],
    extras_require={
        "dev": ["pytest", "black", "pylint"]
    }
)

# Install with: pip install -e ".[dev]"
```

```toml
# pyproject.toml (new way)
[project]
name = "myapp"
dependencies = ["requests>=2.31.0", "anthropic>=0.40.0"]

[project.optional-dependencies]
dev = ["pytest>=8.0.0", "black>=24.0.0", "pylint>=3.0.0"]

# Install with: pip install -e ".[dev]"
```

But for simplicity, `requirements.txt` + `requirements-dev.txt` works great.

---

## Alternatives

### Poetry

Modern dependency management with lock files:

```toml
# pyproject.toml
[tool.poetry.dependencies]
python = "^3.11"
anthropic = "^0.40.0"
requests = "^2.31.0"

[tool.poetry.group.dev.dependencies]
black = "^24.0.0"
pytest = "^8.0.0"
pylint = "^3.0.0"
```

```bash
# Install all dependencies
poetry install

# Install only production dependencies
poetry install --only main
```

**Pros:**
- Lock files for reproducible builds
- Dependency resolution built-in
- Virtual env management

**Cons:**
- More complex than requirements.txt
- Requires poetry installed
- Learning curve for team

### Pipenv

Another lock file based approach:

```toml
# Pipfile
[packages]
anthropic = ">=0.40.0"
requests = ">=2.31.0"

[dev-packages]
black = ">=24.0.0"
pytest = ">=8.0.0"
```

```bash
# Install all
pipenv install --dev

# Install only production
pipenv install
```

### Conda

For data science projects:

```yaml
# environment.yml
name: myapp
dependencies:
  - python=3.11
  - anthropic>=0.40.0
  - requests>=2.31.0
  - pytest  # dev
  - black   # dev
```

---

## Migration Path

### From Mixed Dependencies

**Before:**
```text
# requirements.txt (everything mixed)
anthropic>=0.40.0
requests>=2.31.0
pytest>=8.0.0        # Dev only
black>=24.0.0        # Dev only
pylint>=3.0.0        # Dev only
```

**After:**
```text
# requirements.txt (production only)
anthropic>=0.40.0
requests>=2.31.0

# requirements-dev.txt (development only)
black>=24.0.0
pytest>=8.0.0
pylint>=3.0.0
```

### Migration Steps

1. Create `requirements-dev.txt`
2. Move dev tools from `requirements.txt` to `requirements-dev.txt`
3. Update CI to install both files
4. Update Dockerfile to install only `requirements.txt`
5. Update README with new setup instructions
6. Test in CI and production

---

## Verification

### Check Separation is Working

```bash
# Production environment
python -m venv venv-prod
source venv-prod/bin/activate
pip install -r requirements.txt
python -c "import pytest"  # Should fail - pytest not installed

# Development environment
python -m venv venv-dev
source venv-dev/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
python -c "import pytest"  # Should succeed
```

### Measure Improvements

```bash
# Production image size
docker build -f Dockerfile.prod -t myapp:prod .
docker images myapp:prod

# Development image size
docker build -f Dockerfile.dev -t myapp:dev .
docker images myapp:dev

# Compare
echo "Production should be significantly smaller"
```

---

## Related Patterns

- [ci-pipeline-pattern.md](ci-pipeline-pattern.md) - CI pipeline that uses dev dependencies
- [autonomous-quality-enforcement.md](autonomous-quality-enforcement.md) - Using dev tools in validation loops
- [testing-patterns.md](testing-patterns.md) - pytest configuration and best practices

---

## Summary

This pattern provides:

- **Clean separation** between production and development dependencies
- **Smaller, faster, more secure** production deployments
- **Unified configuration** across all environments
- **Easy to understand** for new team members
- **Industry standard** approach used by top Python projects

Start with the Quick Start guide, customize the configs for your project, and enjoy cleaner dependencies.
