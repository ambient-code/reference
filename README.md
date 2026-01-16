# Ambient Code Reference

AI-assisted development patterns. Each pattern is standalone - adopt what you need.

## Patterns

| Problem | Pattern |
|---------|---------|
| AI context windows fill up fast | [Repomap](docs/patterns/repomap.md) |
| AI gives inconsistent answers | [Codebase Agent](docs/patterns/codebase-agent.md) |
| AI misses obvious bugs | [Self-Review Reflection](docs/patterns/self-review-reflection.md) |
| PRs take forever to create | [Issue-to-PR Automation](docs/patterns/issue-to-pr.md) |
| Code reviews are bottleneck | [PR Auto-Review](docs/patterns/pr-auto-review.md) |
| Dependency updates pile up | [Dependabot Auto-Merge](docs/patterns/dependabot-auto-merge.md) |
| Stale issues accumulate | [Stale Issue Management](docs/patterns/stale-issues.md) |
| Security feels ad-hoc | [Security Patterns](docs/patterns/security-patterns.md) |
| Tests are disorganized | [Testing Patterns](docs/patterns/testing-patterns.md) |

## Getting Started

See [Quickstart](docs/README.md) for pattern overview and adoption guidance.

## Development Setup

```bash
git clone https://github.com/ambient-code/reference.git
cd reference

# Install dependencies
pip install -r requirements.txt      # Repomap dependencies
pip install -r requirements-dev.txt  # Doc tooling

# Install pre-commit hooks (includes repomap auto-update)
pre-commit install
```

**Prerequisites**: Python 3.11+, Node.js (for markdownlint and mermaid-cli)

```bash
npm install -g markdownlint-cli @mermaid-js/mermaid-cli
```

## Repository Contents

```text
reference/
├── docs/
│   ├── README.md              # Quickstart guide
│   └── patterns/              # Individual pattern docs
├── .claude/                   # Example CBA configuration
├── PRESENTATION-ambient-code-reference.md  # 9-feature overview
└── CLAUDE.md                  # Agent instructions for this repo
```

## Links

- **Working Demo**: [demo-fastapi](https://github.com/ambient-code/demo-fastapi)
- **Presentation**: [PRESENTATION-ambient-code-reference.md](PRESENTATION-ambient-code-reference.md)

## License

MIT - See [LICENSE](LICENSE)
