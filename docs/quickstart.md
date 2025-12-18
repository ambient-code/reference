# Quickstart Guide

Set up the Ambient Code Reference Repository in under 10 minutes.

## Prerequisites

- Git 2.30+
- GitHub account
- Terminal/command line access

**Optional** (recommended):
- Node.js 18+
- npm (comes with Node.js)

## Setup

### 1. Use Template

Click **"Use this template"** button on GitHub to create your repository.

### 2. Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

### 3. Run Setup

```bash
./scripts/setup.sh
```

The setup script will:
- Validate your environment (Git, Node.js)
- Check directory structure
- Offer to install optional tools (mermaid-cli, markdownlint-cli)
- Run validation checks
- Report completion time

Target: **Under 10 minutes**

### 4. Install Optional Tools

If you skipped tool installation during setup:

```bash
npm install -g @mermaid-js/mermaid-cli markdownlint-cli
```

### 5. Verify Installation

```bash
# Check documentation pairs
./scripts/check-doc-pairs.sh

# Validate diagrams
./scripts/validate-mermaid.sh

# View comparison page
open docs/comparison/index.html  # macOS
# or
xdg-open docs/comparison/index.html  # Linux
```

## What's Included

**Documentation**:
- Standard + Terry versions (dual documentation)
- Side-by-side comparison viewer
- Mermaid architecture diagrams

**Agent Configuration**:
- Codebase Agent (CBA) personality
- Modular context files
- Slash commands

**CI/CD**:
- Documentation validation
- Diagram syntax checking
- Security scans
- Auto-rebuild demos

**Scripts**:
- `setup.sh` - One-command setup
- `validate-mermaid.sh` - Diagram validation
- `check-doc-pairs.sh` - Terry version verification
- `record-demo.sh` - Tutorial recording

## Quick Reference

**Validate before committing**:
```bash
./scripts/validate-mermaid.sh
./scripts/check-doc-pairs.sh
```

**Create documentation**:
1. Write `docs/{topic}.md`
2. Write `docs/{topic}-terry.md`
3. Validate: `./scripts/check-doc-pairs.sh`

**Add diagram**:
1. Create `docs/diagrams/{name}.mmd`
2. Validate: `./scripts/validate-mermaid.sh`

## Next Steps

- Read [Architecture](architecture.md) for system overview
- See [Tutorial](tutorial.md) for building first feature
- Review [Contributing](../CONTRIBUTING.md) for guidelines
- Check [Development](development.md) for local workflow

## Troubleshooting

**"Command not found: mmdc"**
- Install: `npm install -g @mermaid-js/mermaid-cli`

**"Setup takes longer than 10 minutes"**
- Check network connection (npm installs)
- Run with `time ./scripts/setup.sh` to identify slow steps

**"Documentation pairs missing"**
- Expected during initial setup
- Create Terry versions: `docs/{topic}-terry.md`

## Support

- [GitHub Issues](../../issues) - Bug reports
- [GitHub Discussions](../../discussions) - Questions
- [STYLE_GUIDE.md](STYLE_GUIDE.md) - Writing standards
