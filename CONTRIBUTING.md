# Contributing to Ambient Code Reference Repository

Thank you for your interest in contributing!

## Development Setup

1. Fork and clone the repository
2. Run setup: `./scripts/setup.sh`
3. Activate virtual environment: `source .venv/bin/activate`
4. Install dev dependencies: `uv pip install -r requirements-dev.txt`

## Code Quality Standards

### Before Committing

Run all linters:

```bash
black app/ tests/
isort app/ tests/
ruff check app/ tests/
```text

Run tests:

```bash
pytest
```text

All linters and tests must pass before submitting a PR.

### Python Standards

- **Black**: Code formatting (no line length enforcement)
- **isort**: Import sorting
- **ruff**: Style guide enforcement
- **80%+ coverage**: Test coverage requirement

### Security

- Never commit secrets (`.env` files in `.gitignore`)
- Validate all external input
- Use Pydantic models at API boundaries
- Run `bandit` and `safety` before committing

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Run linters and tests
4. Commit with clear, succinct messages
5. Push and create PR
6. Ensure CI passes

## PR Requirements

- [ ] All linters pass (black, isort, ruff)
- [ ] All tests pass (80%+ coverage)
- [ ] Security scans pass (bandit, safety)
- [ ] Mermaid diagrams validated (if applicable)
- [ ] Documentation updated (if applicable)

## Commit Message Style

Follow existing repository patterns:

```text
Add feature for X

- Implement Y
- Update Z
```text

Focus on "why" rather than "what".

## Architecture Decision Records (ADRs)

For significant architectural changes, add an ADR to `docs/adr/`:

```text
docs/adr/YYYYMMDD-title.md
```text

See `docs/adr/template.md` for format.

## Questions?

Open an issue for discussion before starting large changes.
