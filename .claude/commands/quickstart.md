# /quickstart

**Description**: Quick validation and setup verification for new template users

**Usage**: `/quickstart`

---

## What This Command Does

Runs a fast validation check to ensure the template is properly set up and ready to use.

This command:
1. Verifies directory structure
2. Checks required files exist
3. Validates documentation pairs
4. Tests script execution
5. Reports any issues found

---

## Execution Steps

### 1. Check Directory Structure

Verify all required directories exist:

```bash
for dir in .github .claude docs scripts; do
    if [ -d "$dir" ]; then
        echo "✓ $dir exists"
    else
        echo "✗ $dir MISSING"
    fi
done
```

### 2. Verify Core Files

Check that essential files are present:

```bash
required_files=(
    "README.md"
    "CONTRIBUTING.md"
    "LICENSE"
    "CLAUDE.md"
    ".gitignore"
    "docs/STYLE_GUIDE.md"
    ".claude/agents/codebase-agent.md"
    ".claude/context/architecture.md"
    ".claude/context/security-standards.md"
    ".claude/context/testing-patterns.md"
    "scripts/setup.sh"
    "scripts/validate-mermaid.sh"
    "scripts/check-doc-pairs.sh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file MISSING"
    fi
done
```

### 3. Validate Documentation Pairs

Run the doc pairs validation script:

```bash
if [ -x scripts/check-doc-pairs.sh ]; then
    echo "Running documentation pair check..."
    scripts/check-doc-pairs.sh
else
    echo "⚠ check-doc-pairs.sh not executable or missing"
fi
```

### 4. Test Script Functionality

Verify key scripts are executable:

```bash
for script in scripts/*.sh; do
    if [ -x "$script" ]; then
        echo "✓ $(basename "$script") is executable"
    else
        echo "✗ $(basename "$script") not executable - run: chmod +x $script"
    fi
done
```

### 5. Check Git Configuration

Verify repository is initialized:

```bash
if [ -d .git ]; then
    echo "✓ Git repository initialized"
    echo "  Current branch: $(git branch --show-current)"
    echo "  Recent commits: $(git log --oneline -3 2>/dev/null || echo 'No commits yet')"
else
    echo "✗ Not a git repository - run: git init"
fi
```

---

## Response Template

Format output as:

```markdown
## Quickstart Validation Results

### Directory Structure
- ✓ .github (GitHub automation)
- ✓ .claude (AI agent config)
- ✓ docs (documentation)
- ✓ scripts (automation scripts)

### Core Files
- ✓ README.md
- ✓ CONTRIBUTING.md
- ✓ LICENSE
- ✓ CLAUDE.md
... (all required files)

### Documentation Pairs
- ✓ All standard docs have Terry versions
- ✓ Total pairs: X

### Scripts
- ✓ setup.sh (executable)
- ✓ validate-mermaid.sh (executable)
- ✓ check-doc-pairs.sh (executable)
- ✓ record-demo.sh (executable)

### Git Configuration
- ✓ Repository initialized
- Current branch: main
- Recent commits:
  - abc1234 Phase 3 complete
  - def5678 Phase 2 infrastructure
  - ghi9012 Phase 1 foundation

---

## Summary

✅ Template is ready to use!

Next steps:
1. Review docs/quickstart.md for detailed setup
2. Run ./scripts/setup.sh for full environment setup
3. Read docs/tutorial.md to add your first feature

---

Issues found: 0
```

If issues are found:

```markdown
## Summary

⚠ Issues found: 3

Please fix:
1. scripts/setup.sh is not executable - run: chmod +x scripts/setup.sh
2. Missing file: .claude/context/testing-patterns.md
3. Documentation pair missing: docs/deployment.md has no Terry version

After fixing, run /quickstart again to verify.
```

---

## Exit Behavior

- If validation passes: Report success and suggest next steps
- If issues found: List specific problems with fix commands
- If critical errors: Explain what's wrong and how to resolve

---

## Related Commands

- `/setup` - Full environment setup (longer, more comprehensive)
- `/validate` - Run all validation scripts
- `/docs` - Open documentation comparison page

---

## Notes

- This command is designed for first-time template users
- Runs in <30 seconds (fast feedback)
- Does not modify any files (read-only validation)
- Safe to run multiple times
