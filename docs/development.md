# Development

Local development workflow and validation for the Ambient Code Reference Repository.

## Prerequisites

- Setup complete (`./scripts/setup.sh`)
- Text editor configured
- Optional tools installed (mermaid-cli, markdownlint-cli, shellcheck)

## Daily Workflow

### 1. Create Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/{stream}/{description}
```

Pattern: `feature/docs/topic-name`, `feature/cicd/workflow-name`, `feature/agent/module-name`

### 2. Make Changes

**Documentation**:
1. Create `docs/{topic}.md` (standard)
2. Create `docs/{topic}-terry.md` (accessible)
3. Update `docs/comparison/index.html` navigation

**Diagrams**:
1. Create `docs/diagrams/{name}.mmd`
2. Test: `mmdc -i docs/diagrams/{name}.mmd -o /tmp/test.svg`

**Scripts**:
1. Edit `scripts/{name}.sh`
2. Test locally
3. Validate: `shellcheck scripts/{name}.sh`

**Workflows**:
1. Create `.github/workflows/{name}.yml`
2. Test on feature branch (push and verify)

### 3. Local Validation

Run before committing:

```bash
# All checks
./scripts/check-doc-pairs.sh
./scripts/validate-mermaid.sh
markdownlint docs/*.md
shellcheck scripts/*.sh

# Or if lint-all.sh exists (Phase 2+)
./scripts/lint-all.sh
```

### 4. Commit Changes

```bash
git add -A
git commit -m "type(scope): description

Detailed explanation (optional)

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Commit Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `chore` - Maintenance
- `ci` - CI/CD changes

### 5. Push and Create PR

```bash
git push -u origin feature/{stream}/{description}
gh pr create --title "type(scope): description" --body "Details"
```

## Validation Commands

### Documentation

**Check Pairs**:
```bash
./scripts/check-doc-pairs.sh
```

**Lint Markdown**:
```bash
markdownlint docs/**/*.md
```

**Preview Comparison**:
```bash
open docs/comparison/index.html  # macOS
xdg-open docs/comparison/index.html  # Linux
```

### Diagrams

**Validate Single Diagram**:
```bash
mmdc -i docs/diagrams/{name}.mmd -o /tmp/test.svg
```

**Validate All**:
```bash
./scripts/validate-mermaid.sh
```

**Preview in Browser**:
- GitHub renders `.mmd` files natively
- Or use [Mermaid Live Editor](https://mermaid.live/)

### Scripts

**Shellcheck**:
```bash
shellcheck scripts/*.sh
```

**Test Execution**:
```bash
./scripts/{name}.sh
```

### CI/CD Workflows

**Trigger Manually**:
```bash
gh workflow run {workflow-name}.yml
```

**View Run Status**:
```bash
gh run list
gh run view {run-id}
```

## Testing Changes

### Documentation Changes

1. Create both standard and Terry versions
2. Verify pair: `./scripts/check-doc-pairs.sh`
3. Test comparison page loads both versions
4. Check for:
   - No AI slop (superlatives, excessive enthusiasm)
   - ZeroMQ-style (succinct, actionable)
   - Terry version has "What Just Happened?" sections
   - No Red Hat branding
   - No "Amber" terminology

### Diagram Changes

1. Validate syntax: `./scripts/validate-mermaid.sh`
2. Preview rendering
3. Check for:
   - Clear, descriptive labels
   - Logical flow
   - No syntax errors

### Script Changes

1. Test locally with various inputs
2. Pass shellcheck
3. Check for:
   - Proper error handling (`set -e`)
   - Clear error messages
   - Executable permissions (`chmod +x`)

### Workflow Changes

1. Push to feature branch
2. Verify workflow triggers
3. Check logs for errors
4. Confirm workflow completes successfully

## Common Tasks

### Adding Documentation Topic

```bash
# Create files
touch docs/{topic}.md docs/{topic}-terry.md

# Write content (follow STYLE_GUIDE.md)

# Add to comparison page
# Edit docs/comparison/index.html, add:
# <button class="tab-btn" data-topic="{topic}">{Topic Name}</button>

# Validate
./scripts/check-doc-pairs.sh

# Commit
git add docs/{topic}*.md docs/comparison/index.html
git commit -m "feat(docs): add {topic} documentation"
```

### Adding Mermaid Diagram

```bash
# Create diagram
cat > docs/diagrams/{name}.mmd <<EOF
graph TB
    A[Start] --> B[End]
EOF

# Validate
./scripts/validate-mermaid.sh

# Reference in docs
echo "See [diagram](diagrams/{name}.mmd)" >> docs/{topic}.md

# Commit
git add docs/diagrams/{name}.mmd docs/{topic}.md
git commit -m "feat(docs): add {name} diagram"
```

### Adding CI/CD Workflow

```bash
# Create workflow
cat > .github/workflows/{name}.yml <<EOF
name: {Name}

on:
  push:
    branches: [main]

jobs:
  {job-name}:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run check
        run: echo "TODO"
EOF

# Test on branch
git add .github/workflows/{name}.yml
git commit -m "ci: add {name} workflow"
git push

# Verify in GitHub Actions UI
gh run list

# If works, create PR
gh pr create
```

## Troubleshooting

### "Doc pairs check fails"

Missing Terry version:
```bash
# Find missing pairs
./scripts/check-doc-pairs.sh

# Create missing files
touch docs/{topic}-terry.md

# Write accessible version
```

### "Mermaid validation fails"

Common syntax errors:
```bash
# Run with verbose output
mmdc -i docs/diagrams/{name}.mmd -o /tmp/test.svg

# Common fixes:
# - Add missing semicolons in flowcharts
# - Fix arrow syntax (use --> not ->)
# - Remove spaces from node IDs
# - Close all quotes in labels
```

### "Shellcheck errors"

Common issues:
```bash
# Quote variables
VAR="value"
echo "$VAR"  # Good
echo $VAR    # Bad (shellcheck warning)

# Check command exists
if command -v git &> /dev/null; then
    echo "git found"
fi

# Use [[ ]] for conditions
if [[ -f "file.txt" ]]; then
    echo "file exists"
fi
```

### "CI/CD workflow fails"

Debug workflow:
```bash
# View logs
gh run view {run-id} --log

# Download logs
gh run download {run-id}

# Re-run failed jobs
gh run rerun {run-id} --failed
```

## Style Guide Compliance

### Documentation

**Standard Version**:
- Technical terminology
- Assumes expertise
- Code-focused
- Minimal explanation

**Terry Version**:
- Plain language
- "What Just Happened?" after complex steps
- Troubleshooting section
- No assumptions about background

### Code Examples

**Good**:
```bash
#!/bin/bash
set -e  # Exit on error

find docs/diagrams -name "*.mmd" | while read -r file; do
  mmdc -i "$file" -o /tmp/test.svg || exit 1
done
```

**Bad** (no error handling):
```bash
#!/bin/bash
find docs/diagrams -name "*.mmd" | while read file; do
  mmdc -i $file -o /tmp/test.svg
done
```

## Git Best Practices

### Commit Messages

```
feat(docs): add deployment patterns

- Add standard version with container examples
- Add Terry version with accessibility improvements
- Update comparison page navigation

Fixes #123
```

### Branch Management

**Create from latest main**:
```bash
git checkout main
git pull origin main
git checkout -b feature/my-change
```

**Keep branch updated**:
```bash
git checkout main
git pull origin main
git checkout feature/my-change
git merge main
```

**Clean up after merge**:
```bash
git checkout main
git pull origin main
git branch -d feature/my-change
```

## References

- [STYLE_GUIDE.md](STYLE_GUIDE.md) - Writing standards
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md) - Team workflow
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit format
- [Shellcheck](https://www.shellcheck.net/) - Script validation
