# Repomap - AI-Friendly Code Structure Maps

Generate clean, token-optimized code structure maps using tree-sitter for AI-assisted development.

**Inspired by**: [Aider's repomap.py](https://github.com/Aider-AI/aider/blob/main/aider/repomap.py)

**Purpose**: Reduce context window tokens while maintaining code understanding, improving AI performance and reducing costs.

## Quick Start

This repository includes **complete automation** for repomap management. The repomap is automatically updated via pre-commit hooks and validated in CI.

```bash
# Install dependencies (includes tree-sitter packages)
uv pip install -r requirements.txt

# Install pre-commit hooks (includes repomap auto-update)
pre-commit install

# Manual update (if needed)
./scripts/update-repomap.sh

# Validate repomap is current
./scripts/update-repomap.sh --check
```

**That's it!** The repomap will auto-update when you commit code changes.

## Installation

### Requirements

- Python 3.11+
- pip or uv package manager

### Install Dependencies

```bash
# Recommended method
uv pip install -r requirements.txt

# Or install individually with uv
uv pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash
```

## Usage

### Basic Usage

```bash
# Map current directory
python repomap.py .

# Map specific directory
python repomap.py /path/to/repo

# Show verbose output (processing details, warnings)
python repomap.py . --verbose

# Disable parallel processing
python repomap.py . --no-parallel

# Set maximum file size (default: 1MB)
python repomap.py . --max-file-size 2097152  # 2MB
```

### Save Output

```bash
# Save to file
python repomap.py . > repomap.txt

# Copy to clipboard (macOS)
python repomap.py . | pbcopy

# Copy to clipboard (Linux)
python repomap.py . | xclip -selection clipboard
```

## Output Format

Repomap generates a clean tree structure showing:

- File hierarchy
- Code symbols (classes, functions, methods, interfaces, structs)
- Nesting relationships

### Example Output

```text
src/
  main.py
    class Application
      def __init__()
      def run()
    def main()
  utils/
    helpers.py
      def sanitize_string()
      def validate_slug()
    config.py
      class Config
        def load()
```

## Supported Languages

| Language   | Extensions       | Symbols Extracted                    |
| ---------- | ---------------- | ------------------------------------ |
| Python     | `.py`            | Functions, Classes, Methods          |
| JavaScript | `.js`            | Functions, Classes                   |
| TypeScript | `.ts`, `.tsx`    | Functions, Classes, Interfaces       |
| Go         | `.go`            | Functions, Methods, Structs          |
| Shell      | `.sh`, `.bash`   | Functions                            |

## Features

### Automatic Filtering

Repomap automatically skips:

- Binary files (detected via null bytes)
- Large files (>1MB by default, configurable)
- Files matching `.gitignore` patterns
- Common ignore patterns (`.git`, `__pycache__`, `node_modules`, `.venv`, etc.)

### Performance Features

- **Parallel processing**: Uses multiprocessing for faster parsing (disable with `--no-parallel`)
- **Efficient parsing**: Tree-sitter provides fast, incremental parsing
- **Smart filtering**: Skips irrelevant files before parsing

### Error Handling

- Gracefully handles parse errors (continues processing other files)
- Skips unsupported file types silently
- Reports errors in verbose mode (`--verbose`)

## Use Cases

### 1. Local Development

```bash
# Generate map for AI context
python repomap.py . > repomap.txt

# Use in AI prompts
cat repomap.txt | pbcopy  # Copy to clipboard
```

### 2. CI/CD Integration

#### GitHub Actions

```yaml
# .github/workflows/generate-repomap.yml
name: Generate Repomap
on: [push, pull_request]

jobs:
  repomap:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install uv
          uv pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash

      - name: Generate repomap
        run: python repomap.py . > repomap.txt

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: repomap
          path: repomap.txt
```

#### GitLab CI

```yaml
# .gitlab-ci.yml
generate_repomap:
  stage: build
  image: python:3.11
  script:
    - pip install uv
    - uv pip install tree-sitter tree-sitter-python tree-sitter-javascript tree-sitter-typescript tree-sitter-go tree-sitter-bash
    - python repomap.py . > repomap.txt
  artifacts:
    paths:
      - repomap.txt
```

### 3. Automated Workflow (This Repository)

This reference repository includes **complete repomap automation**:

#### Pre-commit Hook

The pre-commit hook automatically regenerates `.repomap.txt` when you commit changes to code files:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: repomap-update
        name: Update repository map
        entry: scripts/update-repomap.sh
        language: system
        pass_filenames: false
        files: '\.(py|js|ts|tsx|go|sh|bash)$'
```

**Triggers on**: `.py`, `.js`, `.ts`, `.tsx`, `.go`, `.sh`, `.bash` file changes

**What it does**: Runs `./scripts/update-repomap.sh` to regenerate `.repomap.txt` before commit

#### CI Validation

GitHub Actions workflow validates repomap is current on every push/PR:

```yaml
# .github/workflows/ci.yml
repomap-validation:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.11'
    - name: Install repomap dependencies
      run: |
        pip install uv
        uv pip install tree-sitter tree-sitter-python tree-sitter-javascript \
                       tree-sitter-typescript tree-sitter-go tree-sitter-bash
    - name: Validate repomap is current
      run: ./scripts/update-repomap.sh --check
```

**What it does**: Blocks merge if `.repomap.txt` is outdated

#### Automation Script

The `scripts/update-repomap.sh` script provides:

```bash
# Regenerate repomap
./scripts/update-repomap.sh

# Validate repomap is current (CI usage)
./scripts/update-repomap.sh --check

# Show help
./scripts/update-repomap.sh --help
```

**Features**:
- Clear error messages with dependency installation hints
- Validates repomap currency for CI/CD
- Used by pre-commit hook for auto-updates

#### Manual Pre-commit Hook (Alternative)

If you prefer a simpler manual hook in other repositories:

```bash
# .git/hooks/pre-commit
#!/bin/bash
python repomap.py . > .repomap.txt
git add .repomap.txt
```

## Configuration

### File Size Limit

Control maximum file size to parse:

```bash
# Default: 1MB (1048576 bytes)
python repomap.py . --max-file-size 2097152  # 2MB
```

### Gitignore Patterns

Repomap automatically respects `.gitignore` patterns in the repository root.

**Default ignore patterns** (always applied):

- `.git`
- `__pycache__`
- `node_modules`
- `.venv`
- `venv`
- `*.pyc`
- `.DS_Store`

## Limitations

### Current Version (v1.0)

- **No caching**: Always recomputes (acceptable performance trade-off)
- **Simple gitignore**: Basic pattern matching (not full gitignore spec)
- **No incremental updates**: Generates full map on each run
- **Limited symbol extraction**: Focuses on primary code symbols (functions, classes)

### Future Enhancements

Potential improvements for future versions:

- File-level caching (only reparse changed files)
- Full gitignore specification support
- Additional symbol types (variables, imports, exports)
- Configurable output formats (JSON, Markdown, etc.)
- Symbol filtering (include/exclude patterns)

## Performance

**Benchmark**: Medium-sized repository (~1000 files)

- **Sequential**: ~15-20 seconds
- **Parallel**: ~5-8 seconds (on multi-core systems)

**Optimization tips**:

- Use `--max-file-size` to skip large generated files
- Ensure `.gitignore` excludes build artifacts and dependencies
- Use `--no-parallel` only for debugging (slower)

## Troubleshooting

### Import Errors

**Problem**: `ImportError: No module named 'tree_sitter'`

**Solution**: Install dependencies

```bash
uv pip install -r requirements.txt
```

### Parse Errors

**Problem**: Files not showing symbols or "Error" messages in verbose mode

**Possible causes**:

- Syntax errors in source files
- Unsupported language features
- Encoding issues (non-UTF-8 files)

**Solution**: Run with `--verbose` to see detailed error messages

```bash
python repomap.py . --verbose
```

### Performance Issues

**Problem**: Slow parsing on large repositories

**Solutions**:

- Reduce `--max-file-size` to skip large files
- Update `.gitignore` to exclude build artifacts
- Use parallel processing (default, faster on multi-core systems)

## Contributing

This is a reference implementation. Contributions welcome:

- Additional language support
- Performance optimizations
- Enhanced gitignore pattern matching
- Additional output formats

## References

- [Aider repomap documentation](https://aider.chat/docs/repomap.html)
- [Code Maps article](https://origo.prose.sh/code-maps)
- [Aider repomap.py source](https://github.com/Aider-AI/aider/blob/main/aider/repomap.py)
- [Tree-sitter documentation](https://tree-sitter.github.io/tree-sitter/)

## License

See LICENSE file in repository root.

---

**Quickstart**:

1. Install dependencies: `uv pip install -r requirements.txt`
2. Install pre-commit hooks: `pre-commit install`
3. The repomap auto-updates on commits!

**Manual usage** (if needed):

```bash
./scripts/update-repomap.sh          # Regenerate
./scripts/update-repomap.sh --check  # Validate
python repomap.py .                  # Direct generation
```
