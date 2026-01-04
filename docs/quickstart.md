# Quickstart Guide

Get started with Ambient Code reference patterns in 5 minutes.

## What This Repository Is

This is a **documentation-only reference** for AI-assisted development patterns. It provides:

- **Pattern documentation** - CBA, architecture, security, testing
- **Example configurations** - `.claude/` agent setup examples
- **Best practices** - Documentation templates and standards

**Looking for a working application?** See [demo-fastapi](https://github.com/jeremyeder/demo-fastapi)

## Prerequisites

- Python 3.11 or 3.12 (for documentation tooling)
- `uv` (recommended) or `pip`
- Git

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/jeremyeder/reference.git
cd reference
```

### 2. Install Documentation Tooling (Optional)

```bash
# Run setup script
./scripts/setup.sh

# Or manually install
uv pip install -r requirements-dev.txt
```

This installs markdown linting and Mermaid validation tools.

## Explore the Patterns

### Browse Documentation

```bash
# Read pattern overviews
cat docs/architecture.md
cat docs/tutorial.md
cat docs/api-reference.md

# Explore CBA agent patterns
cat .claude/agents/codebase-agent.md

# Check context examples
cat .claude/context/architecture.md
cat .claude/context/security-standards.md
cat .claude/context/testing-patterns.md
```

### Understand the Structure

```bash
# See repository layout
tree -L 2 -I '.venv|.git'

# List available patterns
ls -la .claude/agents/
ls -la .claude/context/
ls -la docs/
```

## Validate Documentation (If You Modify)

### Lint Markdown

```bash
markdownlint docs/**/*.md README.md CLAUDE.md --fix
```

### Validate Mermaid Diagrams

```bash
./scripts/validate-mermaid.sh
```

## Use the Patterns

### Pick What You Need

This repository uses **standalone patterns** - adopt concepts independently:

1. **Codebase Agent Setup**
   - Copy `.claude/` structure to your project
   - Adapt agent definitions in `.claude/agents/`
   - Customize context files in `.claude/context/`

2. **Architecture Patterns**
   - Reference layered architecture in `docs/architecture.md`
   - Adapt for your tech stack (FastAPI, Express, Go, etc.)

3. **Testing Patterns**
   - Follow structures in `.claude/context/testing-patterns.md`
   - Organize tests as unit/integration/e2e

4. **CI/CD Patterns**
   - Copy workflows from `.github/workflows/`
   - Adapt for your documentation validation needs

### Example: Add CBA to Your Project

```bash
# In your project
cp -r /path/to/reference/.claude .
cd .claude/agents/

# Edit codebase-agent.md for your needs
vim codebase-agent.md

# Customize context files
cd ../context/
vim architecture.md  # Your project's architecture
vim security-standards.md  # Your security practices
```

## Next Steps

- **[Architecture](architecture.md)** - Understand pattern organization
- **[Tutorial](tutorial.md)** - Apply patterns to your project
- **[API Reference](api-reference.md)** - API design patterns

## Working Application Demo

Want to see these patterns in action?

→ **[demo-fastapi](https://github.com/jeremyeder/demo-fastapi)** - Working FastAPI application demonstrating CBA patterns

The demo includes:
- Full CRUD API with FastAPI
- CBA agent configured for the app
- Complete test suite
- Containerfile for deployment

## Troubleshooting

**Markdown linting fails?**
```bash
# Install markdownlint
npm install -g markdownlint-cli

# Fix issues automatically
markdownlint docs/**/*.md --fix
```

**Mermaid validation fails?**
```bash
# Install mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Run validation
./scripts/validate-mermaid.sh
```

**Need help with patterns?**
- Read detailed docs in `docs/`
- Check examples in `.claude/`
- See working implementation in [demo-fastapi](https://github.com/jeremyeder/demo-fastapi)
