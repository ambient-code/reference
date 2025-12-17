# Ambient Code Reference Repository

A GitHub template demonstrating AI-assisted development best practices using a **buffet approach** - adopt features independently, no forced linear path.

## What's Included

This template provides **pure infrastructure and patterns** (NO application code). Bring your own application and apply these practices:

### 🎯 Core Features (Independently Adoptable)

- **[Dual Documentation System](docs/adoption/dual-documentation.md)**: Every topic in standard (developer-focused) + Terry (accessible) versions with side-by-side comparison
- **[Codebase Agent Configuration](docs/adoption/agent-config.md)**: AI agent setup for issue-to-PR automation, code reviews, maintenance workflows
- **[CI/CD Patterns](docs/adoption/ci-cd-patterns.md)**: GitHub Actions workflows for linting, testing, security scanning, documentation validation
- **[Mermaid Diagram Validation](docs/development.md#diagram-validation)**: Automated syntax checking prevents broken architecture diagrams
- **[Asciinema Tutorials](docs/tutorials/)**: Auto-rebuilt workflow demonstrations (setup, first feature, agent workflow)

### 📚 Documentation & Guides

- **[Quickstart](docs/quickstart.md)**: 10-minute setup guide ([Terry version](docs/quickstart-terry.md))
- **[Architecture](docs/architecture.md)**: Template structure and design patterns ([Terry version](docs/architecture-terry.md))
- **[Tutorial](docs/tutorial.md)**: Build your first feature ([Terry version](docs/tutorial-terry.md))
- **[Development Workflow](docs/development.md)**: Local testing and validation ([Terry version](docs/development-terry.md))
- **[Deployment](docs/deployment.md)**: Containerization patterns ([Terry version](docs/deployment-terry.md))
- **[Contributing](CONTRIBUTING.md)**: How to contribute ([Terry version](docs/contributing-terry.md))

### 🤖 Agent Configuration

- **[Codebase Agent](docs/agent-workflow.md)**: Issue-to-PR automation, code review ([Terry version](docs/agent-workflow-terry.md))
- **[Context Modules](.claude/context/)**: Modular knowledge (architecture, security, testing)
- **[Commands](.claude/commands/)**: Slash commands for common workflows

### 🔧 Scripts & Automation

- `scripts/setup.sh` - One-command template setup (<10 minutes)
- `scripts/validate-mermaid.sh` - Diagram syntax validation
- `scripts/check-doc-pairs.sh` - Verify Terry versions exist
- `scripts/lint-all.sh` - Run all linters (markdown, shell scripts)

---

## Quick Start

### 1. Use This Template

Click the **"Use this template"** button above to create your repository.

### 2. Clone & Setup

```bash
git clone <your-repo-url>
cd <your-repo-name>
./scripts/setup.sh
```

Completes in under 10 minutes.

### 3. Verify Installation

```bash
# Check documentation pairs exist
./scripts/check-doc-pairs.sh

# Validate diagrams
./scripts/validate-mermaid.sh

# View comparison webpage
open docs/comparison/index.html  # macOS
# or
xdg-open docs/comparison/index.html  # Linux
```

### 4. Explore Features

- **Documentation**: See [docs/](docs/) for all guides
- **Agent Config**: See [.claude/](.claude/) for AI assistant setup
- **Tutorials**: See [docs/tutorials/](docs/tutorials/) for workflow demos
- **Adoption Guides**: See [docs/adoption/](docs/adoption/) for independent feature usage

---

## Buffet Approach: Pick What You Need

You **don't need to adopt everything**. Each feature works independently:

**Just want better documentation?**
→ [Dual Documentation Guide](docs/adoption/dual-documentation.md)

**Just want AI agent automation?**
→ [Agent Configuration Guide](docs/adoption/agent-config.md)

**Just want CI/CD patterns?**
→ [CI/CD Patterns Guide](docs/adoption/ci-cd-patterns.md)

**Want to understand the full approach?**
→ [Architecture Overview](docs/architecture.md)

---

## Documentation Comparison

See the difference between standard and Terry documentation:

```bash
open docs/comparison/index.html
```

Side-by-side view of:
- **Standard**: Technical, concise, assumes domain knowledge
- **Terry**: Accessible, explanatory, jargon-free

---

## Key Principles

### 1. Infrastructure Only (No App Code)

This repository contains **zero application code**. It's a template of patterns and configurations for AI-assisted development.

**What's included**: Workflows, documentation, agent config, scripts
**What's NOT included**: FastAPI apps, databases, business logic

### 2. Dual Documentation (Standard + Terry)

Every documentation topic exists in two versions:
- **Standard** (`docs/{topic}.md`): For experienced developers
- **Terry** (`docs/{topic}-terry.md`): For broader audiences, plain language

### 3. Buffet Approach (Independent Adoption)

Features are modular. Adopt one without requiring others:
- Copy `.claude/` to existing project → Agent config works standalone
- Copy `docs/*-terry.md` pattern → Dual docs work standalone
- Copy `.github/workflows/validate-docs.yml` → CI/CD works standalone

### 4. Automated Quality

CI/CD prevents common errors:
- Mermaid diagrams validate before merge (no syntax errors)
- Documentation pairs checked (no missing Terry versions)
- Security scans prevent secrets and application code creep
- Asciinema demos auto-rebuild (always current)

---

## Project Structure

```
.
├── .github/
│   ├── workflows/          # CI/CD automation
│   └── ISSUE_TEMPLATE/     # Issue templates
├── .claude/
│   ├── agents/             # Agent personality definitions
│   ├── context/            # Modular knowledge modules
│   └── commands/           # Slash command definitions
├── docs/
│   ├── *.md               # Standard documentation
│   ├── *-terry.md         # Terry (accessible) versions
│   ├── diagrams/          # Mermaid architecture diagrams
│   ├── tutorials/         # Asciinema workflow demos
│   ├── comparison/        # Side-by-side doc viewer
│   ├── adoption/          # Independent feature guides
│   └── adr/               # Architecture decision records (template)
├── scripts/
│   ├── setup.sh           # One-command setup
│   ├── validate-mermaid.sh # Diagram validation
│   ├── check-doc-pairs.sh  # Doc pair verification
│   └── lint-all.sh         # Linting suite
├── README.md              # This file
├── CONTRIBUTING.md        # Contribution guidelines
└── LICENSE                # MIT License
```

---

## Requirements

**Minimal**:
- Git 2.30+
- Bash (for scripts)

**For Full Experience**:
- Node.js 18+ (for mermaid-cli, markdownlint)
- GitHub account (for template usage)

**Optional**:
- Asciinema (for re-recording tutorials)
- Podman/Docker (for containerization examples)

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Key Points**:
- All documentation requires standard + Terry versions
- Mermaid diagrams must validate with `mmdc` before commit
- Follow [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md) for writing style
- No Red Hat branding, no "Amber" terminology (use "Codebase Agent" or "CBA")

---

## License

[MIT License](LICENSE) - Use freely in your projects.

---

## Terminology

**Codebase Agent (CBA)**: AI assistant configured for development workflows
**Terry Documentation**: Accessible, jargon-free documentation style
**Buffet Approach**: Independent feature adoption without forced dependencies

---

## Support & Feedback

- **Issues**: Use [GitHub Issues](../../issues) for bugs and questions
- **Discussions**: Use [GitHub Discussions](../../discussions) for ideas
- **Pull Requests**: See [CONTRIBUTING.md](CONTRIBUTING.md) for process

---

## Acknowledgments

- **ZeroMQ Project**: Inspiration for succinct documentation style
- **Anthropic Claude**: AI-assisted development patterns
- **Community Contributors**: See [Contributors](../../graphs/contributors)

---

**Quick Links**:
- [Documentation Style Guide](docs/STYLE_GUIDE.md)
- [Project Board & Workflow](.github/PROJECT_BOARD.md)
- [Architecture Overview](docs/architecture.md)
- [Agent Workflow](docs/agent-workflow.md)
- [Comparison Page](docs/comparison/index.html)
