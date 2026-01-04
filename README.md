# Ambient Code Reference Repository

A **documentation-only** GitHub template demonstrating AI-assisted development patterns with a **standalone patterns approach** - adopt concepts independently, no prescribed sequence.

## Quick Start

```bash
# Clone this repository
git clone https://github.com/jeremyeder/reference.git
cd reference

# Install documentation tooling
uv pip install -r requirements-dev.txt

# Explore the documentation
cat docs/quickstart.md

# Validate your own Mermaid diagrams
./scripts/validate-mermaid.sh
```

## What's Included

This repository provides documentation and patterns for:

- ✅ **Codebase Agent (CBA) Patterns** - AI agent configuration for issue-to-PR automation, code reviews, and proactive maintenance
- ✅ **Architecture Patterns** - Layered architecture, component responsibilities, data flow
- ✅ **Security Patterns** - Input validation, sanitization, secrets management
- ✅ **Testing Patterns** - Unit, integration, E2E test structures
- ✅ **CI/CD Patterns** - GitHub Actions for documentation validation
- ✅ **Documentation Templates** - Quickstart, architecture, tutorials, API reference
- ✅ **Quality Automation** - Markdown linting, Mermaid diagram validation

## Standalone Patterns

Pick what you need. Each pattern works independently:

| Pattern | Description | How to Adopt |
| ------- | ----------- | ------------ |
| **Codebase Agent** | AI agent configuration patterns | Copy `.claude/` structure |
| **Architecture** | Layered architecture patterns | Reference `docs/architecture.md` |
| **Security** | Security best practices | Reference `.claude/context/security-standards.md` |
| **Testing** | Test organization patterns | Reference `.claude/context/testing-patterns.md` |
| **CI/CD** | Documentation validation | Copy `.github/workflows/docs-validation.yml` |
| **ADR** | Decision record scaffolding | Copy `docs/adr/` structure |

## Repository Structure

```text
ambient-code-reference/
├── .claude/               # Codebase Agent patterns
│   ├── agents/           # CBA agent definition patterns
│   └── context/          # Modular memory system examples
├── docs/                 # Documentation templates
│   ├── quickstart.md    # 5-minute introduction
│   ├── architecture.md  # Architecture patterns
│   ├── tutorial.md      # Implementation guide
│   ├── api-reference.md # API design patterns
│   └── adr/            # ADR scaffolding
├── .github/workflows/   # CI/CD for documentation
└── scripts/            # Validation and setup scripts
```

## Working Application Demo

Want to see these patterns in a working FastAPI application?

**→ [demo-fastapi](https://github.com/jeremyeder/demo-fastapi)** - Toy application demonstrating CBA patterns in practice

The demo repository includes:

- Working FastAPI service with CRUD endpoints
- CBA agent configuration
- Full test suite (unit, integration, E2E)
- Container support (Podman/Docker)

## Key Patterns

### Codebase Agent (CBA)

AI agent configuration patterns for:

- **Issue-to-PR Automation** - Converting well-defined issues into pull requests
- **Code Reviews** - Providing actionable feedback
- **Proactive Maintenance** - Dependency updates, linting, documentation
- **Memory System** - Modular context files for consistency

See [`.claude/agents/codebase-agent.md`](.claude/agents/codebase-agent.md) for patterns.

### Architecture Patterns

Reference implementations for:

- **Layered Architecture** - API, Service, Model, Core layers
- **Component Responsibilities** - Clear separation of concerns
- **Security Boundaries** - Validation at API boundaries only
- **Structured Logging** - JSON format for observability

### Testing Patterns

- **Unit Testing** - Service layer isolation patterns
- **Integration Testing** - Full request/response cycle patterns
- **E2E Testing** - CBA workflow automation patterns
- **Coverage Goals** - 80%+ enforcement strategies

### CI/CD Patterns

GitHub Actions patterns for:

- **Documentation Validation** - Markdown linting, Mermaid checking
- **Link Validation** - Broken link detection
- **Automated Updates** - Dependabot configuration
- **Quality Gates** - Blocking merges on validation failures

## Documentation

- **[Quickstart](docs/quickstart.md)** - 5-minute introduction to AI-assisted development
- **[Architecture](docs/architecture.md)** - Common architecture patterns
- **[Tutorial](docs/tutorial.md)** - Step-by-step implementation guide
- **[API Reference](docs/api-reference.md)** - API design patterns

## Using This Template

### For Documentation Projects

```bash
# 1. Use this template on GitHub
# 2. Clone your new repository
# 3. Install doc tooling
uv pip install -r requirements-dev.txt

# 4. Update documentation
# Edit files in docs/

# 5. Validate
markdownlint docs/**/*.md --fix
./scripts/validate-mermaid.sh

# 6. Commit and push
git add docs/
git commit -m "docs: Update patterns"
git push
```

### For Development Projects

Reference the patterns and adapt to your needs:

1. Copy `.claude/` for Codebase Agent setup
2. Reference architecture patterns in `docs/architecture.md`
3. Copy CI/CD workflows from `.github/workflows/`
4. Adapt testing patterns from context files
5. Customize for your tech stack

## Development

```bash
# Lint markdown files
markdownlint docs/**/*.md README.md CLAUDE.md --fix

# Validate Mermaid diagrams
./scripts/validate-mermaid.sh

# Lint any code examples
black docs/examples/
isort docs/examples/
ruff check docs/examples/
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT - See [LICENSE](LICENSE) for details.

---

**Use this template**: Click "Use this template" button to create your own repository with these patterns.

**Note**: This is a documentation-only reference repository. Patterns and examples are provided for reference and adaptation to your specific needs.
