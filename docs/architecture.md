# Architecture

High-level structure and design patterns for the Ambient Code Reference Repository.

## Overview

This template follows a **layered architecture** with clear separation of concerns. No application code included - pure infrastructure and documentation patterns.

```
Template Repository (Infrastructure Only)
├── Configuration Layer (.github/, .claude/)
├── Documentation Layer (docs/)
├── Automation Layer (scripts/)
└── Quality Layer (validation, standards)
```

## System Diagram

See [docs/diagrams/architecture.mmd](diagrams/architecture.mmd) for visual representation.

## Layer Breakdown

### Configuration Layer

**GitHub Configuration** (`.github/`):
- `workflows/` - CI/CD automation (validation, security, demo rebuild)
- `ISSUE_TEMPLATE/` - Structured bug reports and feature requests
- `dependabot.yml` - Weekly dependency updates

**Agent Configuration** (`.claude/`):
- `agents/` - Codebase Agent personality and capabilities
- `context/` - Modular knowledge modules (architecture, security, testing)
- `commands/` - Slash command definitions

**Purpose**: Provide reusable configuration patterns teams can adopt.

### Documentation Layer

**Dual Documentation System** (`docs/`):
- Standard versions: `{topic}.md` - Technical, concise, assumes expertise
- Terry versions: `{topic}-terry.md` - Accessible, educational, jargon-free
- Comparison viewer: `comparison/index.html` - Side-by-side display

**Diagrams** (`docs/diagrams/`):
- Mermaid format (`.mmd` files)
- Validated with `mmdc` in CI
- Architecture, workflows, patterns

**Tutorials** (`docs/tutorials/`):
- Asciinema recordings (`.cast` files)
- Auto-rebuilt via GitHub Actions
- Setup, feature development, agent workflows

**Adoption Guides** (`docs/adoption/`):
- Per-feature extraction instructions
- Support buffet approach (independent adoption)

**Purpose**: Demonstrate documentation best practices for AI-assisted development.

### Automation Layer

**Scripts** (`scripts/`):
- `setup.sh` - One-command environment setup (<10 min goal)
- `validate-mermaid.sh` - Diagram syntax validation (mmdc)
- `check-doc-pairs.sh` - Verify Terry versions exist
- `record-demo.sh` - Tutorial recording helper
- `lint-all.sh` - Run all quality checks

**Purpose**: Automate repetitive tasks and enforce quality gates.

### Quality Layer

**Standards**:
- `docs/STYLE_GUIDE.md` - ZeroMQ-style documentation guidelines
- `.github/PROJECT_BOARD.md` - Team workflow and structure
- `CLAUDE.md` - Project-specific agent standards

**Validation**:
- markdownlint (documentation formatting)
- mmdc (Mermaid syntax)
- shellcheck (script quality)
- Custom checks (doc pairs, security)

**Purpose**: Maintain consistent quality across all artifacts.

## Design Patterns

### Buffet Approach

**Principle**: Features are independently adoptable.

**Implementation**:
- No hard dependencies between modules
- Each `.claude/context/*.md` file is standalone
- Documentation can be copied per-topic
- CI/CD workflows are self-contained

**Validation**:
- Extract feature to clean project
- Verify it works without other components
- Document any unavoidable dependencies

### Dual Documentation

**Principle**: Support multiple audiences with same content.

**Standard Version**:
- Technical terminology
- Assumes domain knowledge
- Code-focused examples
- Minimal explanation

**Terry Version**:
- Plain language
- "What Just Happened?" sections
- Troubleshooting included
- No assumptions about background

**Enforcement**:
- `check-doc-pairs.sh` validates pairs exist
- CI blocks merge if Terry version missing
- Comparison page demonstrates value

### Infrastructure-Only

**Principle**: Template contains zero application code.

**Included**:
- Configuration files (`.github/`, `.claude/`)
- Documentation patterns
- Automation scripts
- Diagrams and examples

**Excluded**:
- Web frameworks (FastAPI, Flask, Django)
- Database schemas
- Business logic
- API implementations

**Enforcement**:
- Security workflow checks for `src/`, `app/`, `lib/` directories
- Blocks merge if application code detected

## Technology Decisions

### Why Mermaid for Diagrams

**Alternatives Considered**: PlantUML, draw.io, Graphviz

**Decision**: Mermaid

**Rationale**:
- Text-based (git-friendly)
- GitHub native rendering
- CLI validation available (`mmdc`)
- Simpler syntax than PlantUML

### Why Asciinema for Tutorials

**Alternatives Considered**: Screen recording videos, animated GIFs

**Decision**: Asciinema

**Rationale**:
- Text-based recordings (small file size)
- Copy-paste from recordings
- Easy to automate regeneration
- Terminal-focused (developer audience)

### Why Client-Side Comparison Page

**Alternatives Considered**: Build-time static generation, separate doc sites

**Decision**: Single HTML with JavaScript rendering

**Rationale**:
- No build step required
- Works with `file://` protocol
- Instant updates (refresh browser)
- Minimal dependencies (marked.js, highlight.js from CDN)

## File Organization

```
.
├── .github/
│   ├── workflows/           # CI/CD pipelines
│   │   ├── validate-docs.yml
│   │   ├── security-checks.yml
│   │   └── rebuild-demos.yml
│   ├── ISSUE_TEMPLATE/
│   └── dependabot.yml
│
├── .claude/
│   ├── agents/
│   │   └── codebase-agent.md
│   ├── context/             # Modular knowledge
│   │   ├── architecture.md
│   │   ├── security-standards.md
│   │   └── testing-patterns.md
│   ├── commands/
│   └── settings.local.json
│
├── docs/
│   ├── *.md                 # Standard documentation
│   ├── *-terry.md           # Accessible versions
│   ├── diagrams/            # Mermaid .mmd files
│   ├── tutorials/           # Asciinema .cast files
│   ├── comparison/          # Side-by-side viewer
│   ├── adoption/            # Feature extraction guides
│   └── adr/                 # Architecture decisions
│
├── scripts/
│   ├── setup.sh
│   ├── validate-mermaid.sh
│   ├── check-doc-pairs.sh
│   └── record-demo.sh
│
├── README.md
├── CONTRIBUTING.md
├── LICENSE
└── CLAUDE.md
```

## Data Flow

### Setup Flow

```
User runs setup.sh
  ↓
Validate environment (Git, Node.js)
  ↓
Check directory structure
  ↓
Offer tool installation
  ↓
Run validation scripts
  ↓
Report completion (<10 min goal)
```

### CI/CD Flow

```
Push to branch
  ↓
Security checks (secrets, app code, branding)
  ↓
Documentation validation (markdownlint, doc pairs)
  ↓
Diagram validation (mmdc)
  ↓
Script validation (shellcheck)
  ↓
Merge allowed if all pass
```

### Documentation Creation Flow

```
Write standard version (topic.md)
  ↓
Write Terry version (topic-terry.md)
  ↓
Run check-doc-pairs.sh
  ↓
Add to comparison page navigation
  ↓
Commit both files together
```

## Extension Points

### Adding New Documentation Topic

1. Create `docs/{topic}.md`
2. Create `docs/{topic}-terry.md`
3. Update `docs/comparison/index.html` navigation
4. Validate with `check-doc-pairs.sh`

### Adding New Agent Context Module

1. Create `.claude/context/{topic}.md`
2. Ensure module is standalone (no hard dependencies)
3. Use technology-agnostic patterns
4. Reference from `.claude/agents/codebase-agent.md` if relevant

### Adding New CI/CD Workflow

1. Create `.github/workflows/{name}.yml`
2. Test on feature branch
3. Create diagram if complex: `docs/diagrams/{name}-pipeline.mmd`
4. Document in `docs/development.md`

## Security Considerations

**Secret Detection**:
- Scan for AWS keys (AKIA pattern)
- Scan for GitHub tokens (ghp_ pattern)
- Scan for generic secret keywords
- Block merge if detected

**Application Code Prevention**:
- Check for `src/`, `app/`, `lib/` directories
- Warn on `main.py`, `app.py`, `__init__.py` files
- Enforce infrastructure-only constraint

**Branding Control**:
- Block Red Hat branding
- Block "Amber" terminology (use "Codebase Agent")
- Maintain vendor-neutral positioning

## Performance Goals

- **Setup Time**: Under 10 minutes (measured by `setup.sh`)
- **CI/CD Runtime**: Under 5 minutes per workflow
- **Diagram Validation**: Under 30 seconds (all diagrams)
- **Documentation Validation**: Under 1 minute (all docs)

## References

- [STYLE_GUIDE.md](STYLE_GUIDE.md) - Documentation standards
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md) - Team workflow
- [Mermaid Syntax](https://mermaid.js.org/) - Diagram reference
- [ZeroMQ Guide](https://zeromq.org/get-started/) - Style inspiration
