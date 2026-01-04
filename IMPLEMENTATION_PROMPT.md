# Ambient Code Reference Repository - Complete Implementation Prompt

**Version**: 2.0
**Date**: 2025-12-17
**Type**: Cold-Start Implementation Guide

---

## Mission

Create the **Ambient Code Reference Repository** - a GitHub template demonstrating AI-assisted development best practices using the "standalone patterns approach" where teams can adopt features independently.

**Critical**: No Red Hat branding. This is pure "Ambient Code" documentation.

---

## Core Requirements

### Repository Identity
- **Name**: Ambient Code Reference Repository
- **Type**: GitHub template repository ("Use this template" button)
- **Audience**: Both AI agents and human developers
- **Philosophy**: Standalone patterns approach - features work standalone, not sequenced
- **Platform**: GitHub only

### Technology Stack
- **Application**: FastAPI microservice (Python 3.11+)
- **Agent**: "Codebase Agent" (CBA) - **NOT "Amber"**
- **Testing**: pytest with 80%+ coverage goal
- **Linting**: black (no line length), isort, ruff
- **CI/CD**: GitHub Actions
- **Container**: Podman-compatible Containerfile

### Documentation Strategy
- **Style**: Quickstart-focused, succinct, NO AI slop
- **Format**: GitHub-flavored markdown
- **Mermaid diagrams**: Rigorously validated (user notes diagrams always have errors)
- **ADR scaffolding**: Template only, NO actual content

---

## Repository Structure (Complete)

```
ambient-code-reference/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                    # Main CI pipeline
│   │   ├── security.yml              # Security scanning
│   │   ├── cba-e2e.yml              # CBA E2E tests
│   │   └── docs-validation.yml       # Mermaid + markdown checks
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   └── feature_request.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── dependabot.yml
├── .claude/
│   ├── agents/
│   │   └── codebase-agent.md        # "CBA" agent (NOT "Amber")
│   ├── commands/
│   │   ├── quickstart.md            # /quickstart
│   │   └── question-form.md         # /formgen
│   ├── context/                     # Modular memory system
│   │   ├── architecture.md
│   │   ├── security-standards.md
│   │   └── testing-patterns.md
│   ├── skills/
│   │   └── question-form-generator/ # Custom skill example
│   └── settings.local.json
├── app/                             # FastAPI microservice
│   ├── api/
│   │   ├── __init__.py
│   │   ├── health.py                # /health endpoint
│   │   └── v1/
│   │       ├── __init__.py
│   │       └── items.py             # Example resource
│   ├── core/
│   │   ├── __init__.py
│   │   ├── config.py                # Settings (Pydantic)
│   │   ├── security.py              # Auth/validation
│   │   └── logging.py               # Structured logging
│   ├── models/
│   │   ├── __init__.py
│   │   └── item.py                  # Pydantic models
│   ├── services/
│   │   ├── __init__.py
│   │   └── item_service.py
│   ├── __init__.py
│   └── main.py                      # Application entry point
├── tests/
│   ├── unit/
│   │   ├── __init__.py
│   │   └── test_items.py
│   ├── integration/
│   │   ├── __init__.py
│   │   └── test_api.py
│   └── e2e/
│       ├── __init__.py
│       └── test_cba_workflow.py     # CBA integration test
├── docs/
│   ├── quickstart.md                # Getting started guide
│   ├── architecture.md              # System design
│   ├── tutorial.md                  # Step-by-step guide
│   ├── api-reference.md             # Complete API docs
│   ├── adr/                         # Architecture Decision Records
│   │   ├── README.md                # ADR guide (blank)
│   │   └── template.md              # Format example
│   ├── tutorials/                   # Asciinema demos
│   │   ├── setup.cast
│   │   ├── first-feature.cast
│   │   └── README.md
│   ├── diagrams/                    # Mermaid sources
│   │   ├── architecture.mmd
│   │   ├── cba-workflow.mmd
│   │   └── validate.sh              # Syntax checker
│   └── observability-research.md    # Agent trajectory findings
├── scripts/
│   ├── setup.sh                     # One-command setup
│   ├── validate-mermaid.sh          # Diagram validation
│   └── record-demo.sh               # Asciinema helper
├── .gitignore
├── .python-version                  # Python 3.11+
├── pyproject.toml                   # Project config (Poetry/UV)
├── requirements.txt                 # Dependencies
├── requirements-dev.txt             # Dev dependencies
├── CLAUDE.md                        # Agent configuration
├── README.md                        # Main quickstart
├── CONTRIBUTING.md
├── LICENSE                          # MIT
└── Containerfile                    # Podman/Docker image
```

---

## Codebase Agent (CBA) Definition

**CRITICAL**: Use "Codebase Agent" or "CBA" terminology - **NEVER "Amber"**

The Codebase Agent combines features from:
- `ambient-code/platform/agents/amber.md`
- `ambient-code/agentready/.claude/agents/agentready-dev.md`

### Core Capabilities
1. **Issue-to-PR Automation** - Convert well-defined issues into pull requests
2. **Code Reviews** - Provide actionable feedback on PRs
3. **Proactive Maintenance** - Dependency updates, linting fixes, documentation improvements

### Operating Principles
- **Safety First**: Show plan before major changes, explain reasoning, provide rollback instructions
- **High Signal, Low Noise**: Only comment when adding unique value
- **Project Standards**: Follow CLAUDE.md (black, isort, ruff, pytest, 80%+ coverage)

### Autonomy Level
- **Level 1 (Default)**: PR creation only - WAIT for human approval
- **Level 2 (Future)**: Auto-merge for low-risk changes (requires explicit configuration)

### Memory System
Modular context files in `.claude/context/`:
- `architecture.md` - Layered architecture patterns
- `security-standards.md` - Input validation, secrets management, OWASP prevention
- `testing-patterns.md` - Arrange-Act-Assert, fixtures, mocking patterns

---

## FastAPI Application Architecture

### Layered Architecture
```
API Layer (FastAPI routes)
    ↓
Service Layer (Business logic)
    ↓
Model Layer (Pydantic validation)
    ↓
Core Layer (Config, security, utilities)
```

### Example Resource: Items
**Models**: `app/models/item.py`
- ItemBase, ItemCreate, ItemUpdate, Item
- Pydantic validators for sanitization and slug validation

**Service**: `app/services/item_service.py`
- In-memory storage (simple)
- CRUD operations with business logic
- Singleton pattern

**API**: `app/api/v1/items.py`
- POST /api/v1/items (create)
- GET /api/v1/items (list with pagination)
- GET /api/v1/items/{id} (get by ID)
- GET /api/v1/items/slug/{slug} (get by slug)
- PATCH /api/v1/items/{id} (update)
- DELETE /api/v1/items/{id} (delete)

### Health Endpoints: `app/api/health.py`
- GET /health (health check)
- GET /readiness (Kubernetes readiness)
- GET /liveness (Kubernetes liveness)

### Security Patterns (Light Touch)
- **Input Validation**: Pydantic models at API boundary
- **Sanitization**: `app/core/security.py` - sanitize_string(), validate_slug()
- **Secrets**: Environment variables only (.env files in .gitignore)
- **Container**: Non-root user, minimal base image

---

## Documentation System

### Documentation Pages (4 total)

1. **quickstart.md**
   - 5-minute setup guide
   - Prerequisites, installation, first API call
   - Links to other documentation

2. **architecture.md**
   - Layered architecture explanation
   - Component responsibilities
   - Common patterns and conventions

3. **tutorial.md**
   - Step-by-step guide to building first feature
   - Code examples
   - Best practices

4. **api-reference.md**
   - Complete API documentation
   - All endpoints with request/response examples
   - Error codes and handling

### Writing Style
- **Succinct**: No AI slop, get to the point
- **Practical**: Focus on how to use, not theory
- **Code-heavy**: Show examples, not just descriptions
- **Quickstart-focused**: Help users get running fast

---

## Testing Strategy

### Unit Tests: `tests/unit/test_item_service.py`
- Test service layer in isolation
- Arrange-Act-Assert pattern
- Fixtures for test data
- Edge cases (duplicates, missing items, pagination)

### Integration Tests: `tests/integration/test_api.py`
- Test API endpoints with TestClient
- Full request/response cycle
- Error cases (404, 409, 422)
- Input validation tests

### E2E Tests: `tests/e2e/test_cba_workflow.py`
- **OUTLINE ONLY** (requires GitHub API credentials)
- Documents CBA workflow:
  1. Create GitHub issue
  2. Trigger CBA (via label)
  3. Wait for PR creation
  4. Verify PR contents
  5. Verify CI passes
  6. Clean up

### Coverage Goal
- **Minimum**: 80% overall
- **Critical paths**: 100% (auth, business logic)
- **Configuration**: Excluded

---

## CI/CD Strategy

### GitHub Actions Workflows

**`.github/workflows/ci.yml`**:
- Lint: black --check, isort --check, ruff check
- Test: pytest with coverage (Python 3.11 + 3.12 matrix)
- Build: podman build + health check test
- Upload coverage to Codecov

**`.github/workflows/security.yml`**:
- Bandit: Python static analysis
- Safety: Dependency vulnerability scanning
- Weekly schedule + on push/PR

**`.github/workflows/docs-validation.yml`**:
- Mermaid validation (all diagrams)
- Markdownlint
- Triggers on docs/** changes

**`.github/workflows/cba-e2e.yml`**:
- E2E tests for CBA workflow
- Manual workflow_dispatch only
- Requires GITHUB_TOKEN

**`.github/dependabot.yml`**:
- Weekly Python dependency updates
- Auto-label "dependencies" + "security"

---

## Observability Research (Document Only - NOT Implemented)

**File**: `docs/observability-research.md`

**Content**:
1. **Anthropic API Capabilities**: Message response structure, tool use tracking
2. **Collection Strategies**: API response logging, Anthropic Console, third-party platforms
3. **CBA-Specific Considerations**: Tool sequences, decisions, errors, performance
4. **Example Trajectory Format**: JSON structure for session flow
5. **Recommendations**: Why NOT to implement (complexity, privacy, cost)
6. **Production Guidance**: How users could implement if needed

**EXPLICITLY STATE**: "This is RESEARCH ONLY, not implemented in the reference repository"

---

## Mermaid Validation (Critical)

**User Note**: "Mermaid diagrams always have errors"

### Validation Script: `scripts/validate-mermaid.sh`
- Finds all .mmd files and embedded mermaid in markdown
- Validates with `mmdc` (mermaid-cli)
- Generates error log
- Exits 1 if any diagrams invalid

### CI Integration
- Runs in `.github/workflows/docs-validation.yml`
- Blocks merge if diagrams invalid
- Uploads error log as artifact on failure

### Pre-commit Hook (Optional)
- Can be enabled for local validation
- Prevents committing broken diagrams

---

## Implementation Priorities

### Critical Files (Start Here)

1. **`CLAUDE.md`** (HIGHEST)
   - Foundation for all agent behavior
   - ~400 lines based on detailed agent plan
   - Development standards, architecture, security, testing

2. **`.claude/agents/codebase-agent.md`** (CRITICAL)
   - Core CBA definition
   - Combines Amber + AgentReady features
   - Issue-to-PR automation patterns

3. **`scripts/validate-mermaid.sh`** (HIGH)
   - Prevents broken diagrams
   - CI integration required

4. **`README.md`** (HIGH)
   - Standalone patterns approach landing page
   - Quickstart (< 5 minutes)
   - Links to documentation

5. **`app/main.py`** (CRITICAL)
   - Working FastAPI application
   - Demonstrates patterns CBA can operate on

### Documentation Files

6. **`docs/quickstart.md`** (CRITICAL)
7. **`docs/architecture.md`** (HIGH)
8. **`docs/tutorial.md`** (HIGH)
9. **`docs/api-reference.md`** (MEDIUM)

---

## 4-Week Implementation Sequence

### Week 1: Foundation & Application
- [ ] Git initialization (main branch, .gitignore)
- [ ] CLAUDE.md (~400 lines)
- [ ] pyproject.toml (UV-compatible)
- [ ] requirements.txt + requirements-dev.txt
- [ ] scripts/setup.sh (one-command setup)
- [ ] README.md (standalone patterns approach)
- [ ] LICENSE (MIT)
- [ ] .python-version (3.11)
- [ ] app/core/ (config.py, security.py, logging.py)
- [ ] app/models/item.py (Pydantic models with validators)
- [ ] app/services/item_service.py (business logic)
- [ ] app/api/health.py (health endpoints)
- [ ] app/api/v1/items.py (CRUD endpoints)
- [ ] app/main.py (FastAPI entry point)
- [ ] Containerfile (Podman-compatible)

### Week 2: Codebase Agent + Tests
- [ ] .claude/agents/codebase-agent.md
- [ ] .claude/context/ (architecture.md, security-standards.md, testing-patterns.md)
- [ ] tests/unit/test_item_service.py
- [ ] tests/integration/test_api.py
- [ ] tests/e2e/test_cba_workflow.py (outline)
- [ ] pytest configuration

### Week 3: Documentation
- [ ] docs/quickstart.md
- [ ] docs/architecture.md
- [ ] docs/tutorial.md
- [ ] docs/api-reference.md
- [ ] docs/adr/ scaffolding (template only, NO content)
- [ ] Mermaid diagrams (architecture.mmd, cba-workflow.mmd)

### Week 4: CI/CD & Polish
- [ ] .github/workflows/ci.yml
- [ ] .github/workflows/security.yml
- [ ] .github/workflows/docs-validation.yml
- [ ] .github/dependabot.yml
- [ ] scripts/validate-mermaid.sh
- [ ] Validate all diagrams pass
- [ ] docs/observability-research.md (research ONLY)
- [ ] Asciinema tutorials (scripts/record-demo.sh, demos/)
- [ ] Final testing (`./scripts/setup.sh` → `uvicorn app.main:app --reload`)
- [ ] Polish documentation

---

## Acceptance Criteria (Must Have)

### Repository & Configuration
- [ ] MIT License
- [ ] .gitignore (Python, Node, OS-specific, Claude Code)
- [ ] .python-version (3.11)
- [ ] pyproject.toml (UV-compatible)
- [ ] requirements.txt + requirements-dev.txt
- [ ] README.md with standalone patterns approach
- [ ] CLAUDE.md with comprehensive standards
- [ ] CONTRIBUTING.md

### Codebase Agent (CBA)
- [ ] `.claude/agents/codebase-agent.md` (NOT "Amber")
- [ ] Modular context files (architecture, security, testing)
- [ ] Memory system documented
- [ ] Issue-to-PR workflow defined
- [ ] Code review patterns documented

### FastAPI Application
- [ ] Working microservice (app/main.py)
- [ ] Layered architecture (API, Service, Model, Core)
- [ ] Health endpoints (/health, /readiness, /liveness)
- [ ] CRUD endpoints for Items resource
- [ ] Pydantic models with validation
- [ ] Security patterns (input validation, sanitization)
- [ ] Structured logging (JSON format)
- [ ] Containerfile (Podman-compatible)

### Testing
- [ ] Unit tests (tests/unit/)
- [ ] Integration tests (tests/integration/)
- [ ] E2E test structure (outline)
- [ ] 80%+ coverage goal documented
- [ ] pytest configuration

### Documentation
- [ ] docs/quickstart.md
- [ ] docs/architecture.md
- [ ] docs/tutorial.md
- [ ] docs/api-reference.md

### CI/CD & Quality
- [ ] .github/workflows/ci.yml (lint, test, build)
- [ ] .github/workflows/security.yml (bandit, safety)
- [ ] .github/workflows/docs-validation.yml (Mermaid + markdown)
- [ ] .github/dependabot.yml
- [ ] scripts/validate-mermaid.sh
- [ ] All Mermaid diagrams syntax-validated

### Other Requirements
- [ ] scripts/setup.sh (one-command setup)
- [ ] docs/adr/ scaffolding (template only, NO content)
- [ ] docs/observability-research.md (research ONLY)
- [ ] Asciinema tutorials (docs/tutorials/)
- [ ] Question-form-generator skill integrated

---

## Anti-Requirements (Must NOT Have)

- ❌ **Red Hat branding** or references (keep as "Ambient Code")
- ❌ **"Amber" terminology** (use "Codebase Agent" or "CBA" only)
- ❌ **Sequenced/linear adoption path** (standalone patterns approach only)
- ❌ **Deployment infrastructure** (development-focused)
- ❌ **AI slop** in documentation (succinct, no fluff)
- ❌ **Security overrotation** (light touch only)
- ❌ **Mermaid syntax errors** (must validate before commit)
- ❌ **Actual ADR content** (scaffolding/template only)
- ❌ **Implemented observability** (research document only)
- ❌ **Time estimates** in documentation
- ❌ **GitLab support** (GitHub only)
- ❌ **Multiple documentation versions** (single version only)

---

## Validation Checklist

### Technical Success
- [ ] `./scripts/setup.sh` completes successfully
- [ ] `uvicorn app.main:app --reload` starts without errors
- [ ] `curl http://localhost:8000/health` returns healthy status
- [ ] All CRUD operations work via API
- [ ] `pytest` runs with 80%+ coverage
- [ ] Container builds and runs successfully

### Code Quality
- [ ] `black --check app/ tests/` passes
- [ ] `isort --check-only app/ tests/` passes
- [ ] `ruff check app/ tests/` passes
- [ ] All GitHub Actions workflows pass
- [ ] Security scans complete (bandit, safety)

### Documentation
- [ ] Mermaid validation passes (all diagrams)
- [ ] Markdownlint passes
- [ ] All docs are succinct (no AI slop)

### Standalone Patterns
- [ ] Features are independent (can adopt one without others)
- [ ] Clear "what's included" section in README
- [ ] No prescribed sequence of adoption

---

## Reference Materials

### Codebase Agent Sources
- `ambient-code/platform/agents/amber.md`
- `ambient-code/agentready/.claude/agents/agentready-dev.md`

### Existing Inventories
- `AMBIENT_TECHNIQUES_INVENTORY.md` (already exists in repo)
- `FEATURES_INVENTORY.md` (already exists in repo)

---

## Quick Reference Commands

```bash
# Setup
./scripts/setup.sh

# Run application
source .venv/bin/activate
uvicorn app.main:app --reload

# Run tests
pytest

# Run linters
black app/ tests/
isort app/ tests/
ruff check app/ tests/

# Security scans
bandit -r app/
safety check

# Validate Mermaid diagrams
./scripts/validate-mermaid.sh

# Record tutorial
./scripts/record-demo.sh setup
```

---

## Success Criteria Summary

A successful implementation will:
1. **Run locally** in < 10 minutes from clone to running app
2. **Pass all linters** (black, isort, ruff)
3. **Pass all tests** (80%+ coverage)
4. **Validate all diagrams** (no Mermaid syntax errors)
5. **Demonstrate standalone patterns approach** (features work independently)
6. **Work as GitHub template** ("Use this template" button functional)
7. **Have succinct documentation** (no AI slop)

---

**End of Implementation Prompt**

Use this document as a standalone reference to implement the Ambient Code Reference Repository from scratch. All requirements, structure, and validation criteria are included above.
