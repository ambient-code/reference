# Contributing to Ambient Code Reference Repository

Thank you for contributing to the Ambient Code Reference Repository!

This template demonstrates AI-assisted development best practices. Contributions should maintain quality standards and support the buffet approach (independent feature adoption).

---

## Quick Start

### 1. Fork & Clone

```bash
# Fork this repository via GitHub
git clone https://github.com/YOUR_USERNAME/ambient-reference-repo.git
cd ambient-reference-repo
```

### 2. Create Branch

```bash
git checkout -b feature/your-feature-name
```

**Branch Naming**:
- `feature/docs/topic-name` - Documentation additions
- `feature/agent/module-name` - Agent configuration updates
- `feature/cicd/workflow-name` - CI/CD improvements
- `fix/issue-number-description` - Bug fixes

### 3. Make Changes

Follow guidelines below. Key requirements:
- Dual documentation (standard + Terry versions)
- Mermaid diagrams validated with `mmdc`
- No Red Hat branding, no "Amber" terminology
- Follow [STYLE_GUIDE.md](docs/STYLE_GUIDE.md)

### 4. Test Locally

```bash
# Validate Mermaid diagrams
./scripts/validate-mermaid.sh

# Check documentation pairs
./scripts/check-doc-pairs.sh

# Run linters
./scripts/lint-all.sh

# Test setup script
./scripts/setup.sh
```

### 5. Submit Pull Request

- Use pull request template (auto-populated)
- Reference related issues: "Fixes #123"
- Request review from maintainers

---

## Contribution Guidelines

### Documentation

**All documentation must exist in two versions**:
- **Standard** (`docs/{topic}.md`): Technical, developer-focused
- **Terry** (`docs/{topic}-terry.md`): Accessible, jargon-free

**Process**:
1. Write standard version first
2. Use Terry agent to generate Terry version (or convert manually)
3. Review Terry version for accessibility
4. Test in comparison webpage: `open docs/comparison/index.html`

**Style Requirements**:
- Follow [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md)
- No AI slop (excessive enthusiasm, superlatives, filler)
- ZeroMQ-style: succinct, actionable, clear
- Terry docs must have "What Just Happened?" sections

### Mermaid Diagrams

**All diagrams must validate before commit**:

```bash
# Validate single diagram
mmdc -i docs/diagrams/your-diagram.mmd -o /tmp/test.svg

# Validate all diagrams
./scripts/validate-mermaid.sh
```

**Common Issues**:
- Missing semicolons in flowcharts
- Incorrect syntax for arrows (`-->` not `->`)
- Unclosed quotes in labels
- Invalid node IDs (no spaces, special chars)

**Resources**:
- [Mermaid Documentation](https://mermaid.js.org/)
- [Live Editor](https://mermaid.live/) - Test syntax interactively

### Agent Configuration

**Context modules must be independently usable**:
- No hard dependencies between modules
- Technology-agnostic patterns
- Clear separation of concerns

**File Structure**:
```
.claude/
├── agents/
│   └── codebase-agent.md     # Agent personality
├── context/
│   ├── architecture.md       # Independent module
│   ├── security-standards.md # Independent module
│   └── testing-patterns.md   # Independent module
└── commands/
    └── quickstart.md         # Slash command definition
```

**Terminology**:
- ✅ Use: "Codebase Agent" or "CBA"
- ❌ Don't use: "Amber" (old internal name)

### CI/CD Workflows

**Workflows must**:
- Run on `push` and `pull_request` events
- Fail fast (exit 1 on first error)
- Provide clear error messages
- Complete in reasonable time (<5 minutes ideal)

**Testing**:
- Test workflows on feature branch before PR
- Verify failure cases (intentionally break something, confirm workflow catches it)
- Check workflow logs for clarity

### Scripts

**All scripts must**:
- Include shebang: `#!/bin/bash`
- Use `set -e` for error handling
- Be executable: `chmod +x scripts/your-script.sh`
- Pass shellcheck: `shellcheck scripts/your-script.sh`
- Include comments for non-obvious logic

**Example**:
```bash
#!/bin/bash
set -e  # Exit on any error

echo "Validating Mermaid diagrams..."

# Find all .mmd files and validate
find docs/diagrams -name "*.mmd" | while read -r file; do
  echo "Checking $file..."
  mmdc -i "$file" -o /tmp/test.svg || exit 1
done

echo "✓ All diagrams valid"
```

---

## Pull Request Checklist

Use this checklist (auto-populated in PR template):

- [ ] Dual documentation pairs created (if applicable)
- [ ] Mermaid diagrams validated with `mmdc` (if applicable)
- [ ] Terry version reviewed for accessibility (if applicable)
- [ ] No Red Hat branding
- [ ] No "Amber" terminology (use "Codebase Agent" or "CBA")
- [ ] CI checks passing
- [ ] Follows [STYLE_GUIDE.md](docs/STYLE_GUIDE.md) (for documentation)
- [ ] Scripts pass shellcheck (if applicable)
- [ ] Tested locally with validation scripts

---

## Code Review Process

### What Reviewers Check

**Documentation**:
- Style consistency with STYLE_GUIDE.md
- Terry version accessibility (no jargon without explanation)
- Code examples are realistic and complete
- Links resolve correctly

**Agent Configuration**:
- Modules are independently usable
- No "Amber" terminology
- Patterns are technology-agnostic
- Clear separation of concerns

**CI/CD**:
- Workflows run successfully
- Error messages are clear
- No security issues (secrets, hardcoded values)

**Scripts**:
- Shellcheck passes
- Error handling robust (`set -e`, exit codes)
- Comments explain non-obvious logic

### Review Timeline

- **Initial Review**: Within 2 business days
- **Follow-up**: Within 1 business day after changes
- **Merge**: After approval from 1+ maintainer

---

## Common Contribution Types

### Adding Documentation

**Example: Add "Monitoring" topic**

1. Create `docs/monitoring.md` (standard version)
2. Create `docs/monitoring-terry.md` (accessible version)
3. Add to comparison webpage tab navigation in `docs/comparison/index.html`
4. Validate pair exists: `./scripts/check-doc-pairs.sh`
5. Submit PR

### Adding Agent Context Module

**Example: Add "Deployment" context**

1. Create `.claude/context/deployment.md`
2. Ensure module is independently usable (no hard dependencies)
3. Reference from `.claude/agents/codebase-agent.md` if relevant
4. Test by copying module alone to test project
5. Submit PR

### Adding CI/CD Workflow

**Example: Add "Performance Testing" workflow**

1. Create `.github/workflows/performance-tests.yml`
2. Test on feature branch
3. Verify failure cases
4. Create diagram `docs/diagrams/performance-pipeline.mmd` if complex
5. Document in `docs/development.md`
6. Submit PR

### Adding Script

**Example: Add "Check Dependencies" script**

1. Create `scripts/check-dependencies.sh`
2. Make executable: `chmod +x scripts/check-dependencies.sh`
3. Pass shellcheck: `shellcheck scripts/check-dependencies.sh`
4. Test locally
5. Document in `docs/development.md`
6. Submit PR

---

## Buffet Approach Validation

**Every new feature must be independently adoptable**.

**Test**:
1. Create clean test project (outside this repository)
2. Copy ONLY the new feature files
3. Verify feature works without other template components
4. Document any unavoidable dependencies

**Example**:
```bash
# Test dual documentation adoption
mkdir /tmp/test-project
cp docs/monitoring.md /tmp/test-project/
cp docs/monitoring-terry.md /tmp/test-project/
# Verify docs are readable and useful standalone
```

---

## Release Process

**Maintainers only. Contributors: submit PRs, maintainers handle releases.**

### Version Tagging

```bash
# Tag release
git tag -a v1.0.0 -m "Release 1.0.0: Initial template"
git push origin v1.0.0
```

### Asciinema Tutorials

Auto-rebuilt via GitHub Actions on main branch push. Manual recording:

```bash
# Record new tutorial
./scripts/record-demo.sh <tutorial-name>

# Example
./scripts/record-demo.sh setup
```

### Documentation Updates

Update version references in:
- `README.md`
- `docs/quickstart.md` and `docs/quickstart-terry.md`
- `.github/ISSUE_TEMPLATE/` (if templates reference versions)

---

## Questions & Support

- **Questions**: Use [GitHub Discussions](../../discussions)
- **Bugs**: Use [GitHub Issues](../../issues) with bug report template
- **Features**: Use [GitHub Issues](../../issues) with feature request template
- **Real-time Help**: (Add Slack/Discord link if available)

---

## Recognition

Contributors are recognized in:
- [GitHub Contributors Graph](../../graphs/contributors)
- Release notes
- Project acknowledgments (README.md)

---

## Code of Conduct

Be respectful, collaborative, and constructive.

**Expected Behavior**:
- Constructive feedback in reviews
- Clear, professional communication
- Respect for different skill levels and backgrounds

**Unacceptable Behavior**:
- Personal attacks or insults
- Harassment or discrimination
- Sharing others' private information

**Enforcement**:
- Violations reported to maintainers
- Maintainers may warn, temporarily ban, or permanently ban violators

---

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).

---

**Ready to contribute?** Fork the repository and submit your first PR!

See [docs/development.md](docs/development.md) for detailed development workflow.
