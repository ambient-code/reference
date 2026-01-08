# Ambient Code Reference Repository - Agent Configuration

**Version**: 2.1.0
**Last Updated**: 2026-01-04
**Purpose**: Documentation-only reference for AI-assisted development patterns

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Development Standards](#development-standards)
3. [Documentation Guidelines](#documentation-guidelines)
4. [Codebase Agent (CBA) Patterns](#codebase-agent-cba-patterns)
5. [Git Workflow](#git-workflow)
6. [CI/CD for Documentation](#cicd-for-documentation)

---

## Project Overview

### Repository Purpose

This is a **GitHub template repository** demonstrating AI-assisted development best practices. It's a **documentation-only** reference using the "standalone patterns approach" - concepts are standalone and independently adoptable.

**Key Principles**:

- ✅ **Standalone patterns approach** - Patterns are standalone and independently adoptable
- ✅ **Documentation-focused** - Pure reference material, no working application
- ✅ **Succinct content** - No AI slop, get to the point
- ✅ **Quality automation** - Documentation linting and validation
- ❌ **No Red Hat branding** - Pure "Ambient Code" documentation
- ❌ **No "Amber" terminology** - Use "Codebase Agent" or "CBA" only

### What This Repository Contains

**Documentation** (`docs/`):

- Quickstart guides for AI-assisted development
- Architecture pattern references
- Tutorial outlines for implementing agentic workflows
- API design patterns

**Codebase Agent Configuration** (`.claude/`):

- Agent definitions and capabilities
- Context files for modular memory system
- Example commands and skills

**CI/CD** (`.github/workflows/`):

- Documentation validation workflows
- Markdown linting
- Mermaid diagram validation

### Working Application Demo

For a **working FastAPI application** demonstrating these patterns in practice, see:
**[demo-fastapi](https://github.com/ambient-code/demo-fastapi)** - Minimal application showing CBA patterns in action

---

## Development Standards

### Python Version Support

For any code examples in documentation:

- Python 3.11 (primary)
- Python 3.12 (tested in CI matrix)

### Virtual Environment (Recommended)

When testing code examples:

```bash
# Create virtual environment
python3.11 -m venv .venv

# Activate
source .venv/bin/activate

# Verify
echo $VIRTUAL_ENV  # Should show project path
```

### Package Management

**Use `uv` instead of `pip`** for any package installations:

```bash
# Install dependencies
uv pip install -r requirements-dev.txt
```

### Code Quality Tools

For linting documentation code examples:

```bash
# Format code examples
black docs/examples/

# Sort imports in examples
isort docs/examples/

# Lint examples
ruff check docs/examples/
```

### Markdown Linting (MANDATORY)

**ALWAYS lint markdown files**:

```bash
markdownlint docs/**/*.md README.md CLAUDE.md --fix
```

---

## Documentation Guidelines

### Writing Style

- **Succinct**: No AI slop, get to the point
- **Practical**: Focus on how to use, not theory
- **Example-heavy**: Show patterns, not just descriptions
- **Quickstart-focused**: Help users understand quickly

### Documentation Structure

**Core docs** (`docs/`):

1. `quickstart.md` - 5-minute introduction to AI-assisted development
2. `architecture.md` - Common architecture patterns for agentic workflows
3. `tutorial.md` - Step-by-step guide for implementing patterns
4. `api-reference.md` - API design patterns for AI-assisted apps

### Mermaid Diagrams (CRITICAL)

**User note**: "Mermaid diagrams always have errors"

**ALWAYS validate** before committing:

```bash
./scripts/validate-mermaid.sh
```

**CI enforcement**: Blocks merge if diagrams invalid

**Example validation script**:

```bash
#!/bin/bash
# Validate all Mermaid diagrams
find docs/ -name "*.mmd" -exec mmdc -i {} -o /dev/null \;
```

### ADR (Architecture Decision Records)

**Location**: `docs/adr/`

**Scaffolding only** - NO actual content:

- `README.md` - Explains ADR purpose and format
- `template.md` - Shows format (YYYYMMDD-title.md)

**Purpose**: Provide structure for teams to document their own decisions

---

## Codebase Agent (CBA) Patterns

### Agent Configuration

**Location**: `.claude/agents/codebase-agent.md`

**Terminology**: Use "Codebase Agent" or "CBA" - **NEVER "Amber"**

### Memory System Pattern

**Location**: `.claude/context/`

**Modular context files**:

- `architecture.md` - Architecture patterns and conventions
- `security-standards.md` - Security best practices
- `testing-patterns.md` - Testing strategies and patterns

**Purpose**: Demonstrate how to structure context for AI agents to maintain consistency across development sessions.

### Agent Capability Patterns

**Common patterns to document**:

1. **Issue-to-PR Automation** - Converting well-defined issues into PRs
2. **Code Reviews** - Providing actionable feedback
3. **Proactive Maintenance** - Dependency updates, linting, docs
4. **Context Management** - Using memory systems effectively

### Autonomy Levels (Example Pattern)

Document autonomy levels teams might implement:

- **Level 1 (Conservative)**: PR creation only - WAIT for human approval
- **Level 2 (Moderate)**: Auto-merge for low-risk changes (docs, deps)
- **Level 3 (Aggressive)**: Auto-deploy after tests pass

---

## Git Workflow

### Branch Strategy

**ALWAYS work in feature branches** unless explicitly told otherwise:

```bash
# Check current branch BEFORE any modifications
git branch --show-current

# Create feature branch
git checkout -b feature/descriptive-name
```

### Commit Workflow

**Pre-commit checklist**:

1. Lint markdown: `markdownlint docs/**/*.md --fix`
2. Validate diagrams: `./scripts/validate-mermaid.sh`
3. Check git status: `git status`
4. Review changes: `git diff`

**Commit message style**:

```text
Add documentation for X pattern

- Explain Y concept
- Add diagram for Z
```

Focus on "why" rather than "what".

### Pull Request Workflow

**Before creating PR**:

1. `git status` - check untracked files
2. `git diff` - review all changes
3. `git log` - review commit history
4. Ensure CI passes (markdown linting, diagram validation)

**PR requirements**:

- [ ] Markdown linting passes
- [ ] Mermaid diagrams validated
- [ ] No broken links
- [ ] Documentation is clear and succinct

### Git Safety

**NEVER**:

- Update git config without permission
- Run destructive commands (hard reset, force push) without explicit request
- Skip hooks (--no-verify)
- Force push to main/master
- Commit secrets or credentials

---

## CI/CD for Documentation

### GitHub Actions Workflows

**Workflows**:

1. **`.github/workflows/docs-validation.yml`** (Documentation)
   - Markdown linting (markdownlint)
   - Mermaid diagram validation
   - Link checking
   - Triggers: on docs/** changes, PRs

2. **`.github/workflows/ci.yml`** (General CI)
   - Code example linting (if any)
   - Documentation build test
   - Triggers: on push, PR

### Dependabot

**File**: `.github/dependabot.yml`

**Configuration**:

- **Schedule**: Weekly
- **Auto-label**: "dependencies"
- **Package ecosystem**: pip (for doc tooling)

### Documentation Deployment (Optional)

Teams can extend with:

- GitHub Pages deployment
- MkDocs builds
- Static site generation

---

## Quick Reference

### Setup Commands

```bash
# Clone repository
git clone https://github.com/yourusername/reference.git
cd reference

# Install doc tooling
uv pip install -r requirements-dev.txt

# Lint documentation
markdownlint docs/**/*.md --fix

# Validate diagrams
./scripts/validate-mermaid.sh
```

### Documentation Workflow

```bash
# 1. Create feature branch
git checkout -b docs/topic-name

# 2. Edit documentation
# ... make changes ...

# 3. Validate
markdownlint docs/**/*.md --fix
./scripts/validate-mermaid.sh

# 4. Commit
git add docs/
git commit -m "Add documentation for X"

# 5. Push and create PR
git push -u origin docs/topic-name
gh pr create --title "docs: Add X" --body "Documentation for X pattern"
```

---

## Architecture Patterns (Reference)

### Layered Architecture Pattern

Common pattern for AI-assisted applications:

```text
API Layer (Routes/Endpoints)
    ↓ Handles HTTP, validation, serialization
Service Layer (Business logic)
    ↓ Core business rules, orchestration
Model Layer (Data validation)
    ↓ Data validation, serialization
Core Layer (Config, utilities)
    ↓ Cross-cutting concerns
```

### Component Responsibility Patterns

**API Layer**:

- Route handlers
- Request/response validation
- HTTP status codes
- Error responses
- API documentation

**Service Layer**:

- Business logic
- Data manipulation
- Transaction coordination
- No transport concerns

**Model Layer**:

- Data validation
- Type annotations
- Serialization rules

**Core Layer**:

- Configuration management
- Security utilities
- Logging configuration
- Shared utilities

---

## Security Patterns (Reference)

### Input Validation Pattern

**Validate at boundaries only**:

- Validate all external input (user requests, API calls)
- Trust internal code between layers
- Use schema validation libraries

### Sanitization Pattern

Common sanitization functions to implement:

- `sanitize_string()` - Remove dangerous characters
- `validate_slug()` - Ensure URL-safe identifiers
- `sanitize_path()` - Prevent path traversal

### Secrets Management Pattern

- **Environment variables only** - Use `.env` files
- **Config from environment** - Never hardcode secrets
- **Container secrets** - Pass as environment variables
- **Never commit** - `.env` files in `.gitignore`

---

## Anti-Requirements

**NEVER include**:

- ❌ Red Hat branding or references
- ❌ "Amber" terminology (use "Codebase Agent" or "CBA")
- ❌ Sequenced/linear adoption path (standalone patterns approach only)
- ❌ Deployment infrastructure (focus on development)
- ❌ AI slop in documentation
- ❌ Security overrotation (light touch, practical)
- ❌ Mermaid syntax errors (always validate)
- ❌ Actual ADR content (scaffolding only)
- ❌ Time estimates (unless explicitly requested)
- ❌ Working application code (documentation-only)

---

## End of Configuration

This CLAUDE.md file is the source of truth for all AI-assisted development in this repository. Follow these standards strictly.
