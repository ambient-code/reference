# Tutorial: Building Your First Feature

Learn the development workflow by implementing a feature following template patterns.

## Prerequisites

- Template setup complete (`./scripts/setup.sh`)
- Git configured
- Text editor ready

## Scenario

Add a new documentation topic: "Testing Patterns"

This tutorial demonstrates:
- Creating dual documentation
- Following style guide
- Using validation scripts
- Git workflow

## Step 1: Create Feature Branch

```bash
git checkout -b feature/docs/testing-patterns
```

Pattern: `feature/{stream}/{task-id}-{description}`

## Step 2: Create Standard Documentation

Create `docs/testing-patterns.md`:

```markdown
# Testing Patterns

Best practices for testing in AI-assisted development environments.

## Unit Testing

Arrange-Act-Assert pattern:

```python
def test_validation():
    # Arrange
    validator = InputValidator()

    # Act
    result = validator.validate("test@example.com")

    # Assert
    assert result.is_valid == True
```

## Integration Testing

Test module interactions without external dependencies.

## Coverage Goals

Target 80%+ coverage:

```bash
pytest --cov=src --cov-report=html
```

## References

- [pytest documentation](https://docs.pytest.org/)
- [unittest documentation](https://docs.python.org/3/library/unittest.html)
```

Save file.

## Step 3: Create Terry Documentation

Create `docs/testing-patterns-terry.md`:

```markdown
# Testing Patterns

How to test your code to make sure it works correctly.

## What You'll Learn

- How to write tests that check your code
- Different types of tests
- How much testing is enough

## Unit Testing: Testing Small Pieces

Unit tests check individual functions in isolation.

### The Arrange-Act-Assert Pattern

```python
def test_validation():
    # Arrange: Set up what you need
    validator = InputValidator()

    # Act: Do the thing you're testing
    result = validator.validate("test@example.com")

    # Assert: Check it worked correctly
    assert result.is_valid == True
```

**What Just Happened?**
We broke the test into three parts: setup (Arrange), action (Act), and verification (Assert). This makes tests easy to read and understand.

## Coverage: How Much is Tested

"Coverage" means what percentage of your code is tested.

Goal: 80% or higher

Check coverage:
```bash
pytest --cov=src --cov-report=html
```

This creates a report showing which lines were tested.

## Troubleshooting

**Problem**: "ModuleNotFoundError: No module named 'pytest'"
**Solution**: Install pytest: `pip install pytest`

**Problem**: "Coverage is only 20%"
**Solution**: Add more tests for untested functions. The HTML report shows exactly which lines need tests.
```

Save file.

## Step 4: Validate Documentation Pair

```bash
./scripts/check-doc-pairs.sh
```

Expected output:
```
Checking documentation pairs...

Checking testing-patterns.md... ✓ (has Terry version)

✓ All documentation has Terry versions!
```

## Step 5: Run Markdownlint

```bash
markdownlint docs/testing-patterns*.md
```

Fix any formatting issues reported.

## Step 6: Add to Comparison Page

Edit `docs/comparison/index.html`:

Find the `<nav>` section and add:

```html
<button class="tab-btn" data-topic="testing-patterns">Testing Patterns</button>
```

## Step 7: Test Comparison Page

```bash
open docs/comparison/index.html  # macOS
# or
xdg-open docs/comparison/index.html  # Linux
```

Navigate to "Testing Patterns" tab. Verify both versions load.

## Step 8: Commit Changes

```bash
git add docs/testing-patterns*.md docs/comparison/index.html
git commit -m "feat(docs): add testing patterns documentation

- Add standard version with Arrange-Act-Assert pattern
- Add Terry version with explanations and troubleshooting
- Update comparison page navigation
- Verified with check-doc-pairs.sh

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Step 9: Push and Create PR

```bash
git push -u origin feature/docs/testing-patterns
```

Create pull request via GitHub UI or:

```bash
gh pr create \
  --title "feat(docs): add testing patterns documentation" \
  --body "Adds dual documentation for testing patterns with examples"
```

## Validation Checklist

Before merging, verify:

- [ ] Both standard and Terry versions exist
- [ ] `check-doc-pairs.sh` passes
- [ ] Markdownlint passes
- [ ] Comparison page displays both versions
- [ ] No Red Hat branding
- [ ] No "Amber" terminology
- [ ] Follows STYLE_GUIDE.md

## Common Patterns

### Creating Any Documentation

1. Write standard version
2. Write Terry version
3. Validate pair
4. Add to comparison page
5. Commit together

### Creating Diagrams

1. Create `.mmd` file in `docs/diagrams/`
2. Validate: `./scripts/validate-mermaid.sh`
3. Reference in documentation
4. Commit

### Recording Tutorials

1. Run: `./scripts/record-demo.sh <name>`
2. Follow on-screen instructions
3. Review: `asciinema play docs/tutorials/<name>.cast`
4. Commit `.cast` file

## Next Steps

- Add another documentation topic
- Create Mermaid diagram for testing workflow
- Record Asciinema tutorial demonstrating test execution
- Explore agent configuration in `.claude/`

## References

- [STYLE_GUIDE.md](STYLE_GUIDE.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md)
