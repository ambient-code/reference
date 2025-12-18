# Tutorial: Building Your First Feature

Learn how to add new content to this template by walking through a real example.

## What You'll Need

- The template set up on your computer (you ran `./scripts/setup.sh`)
- Git working
- A text editor (VS Code, Sublime Text, or any editor you like)

## What We're Building

We're going to add a new documentation topic called "Testing Patterns" to the template. This tutorial shows you the complete workflow from start to finish.

**You'll Learn**:
- How to create new documentation
- How to use the validation tools
- How to save your work with Git
- How to create a pull request

## Step 1: Create a Branch

First, let's create a "branch" - think of it as a copy where you can make changes safely without affecting the main version.

```bash
git checkout -b feature/docs/testing-patterns
```

**What Just Happened?**
`git checkout -b` created a new branch named `feature/docs/testing-patterns` and switched to it. Now any changes you make will be on this branch, not the main one.

**Branch Naming Pattern**: `feature/{area}/{description}`
- `feature/` = you're adding something new
- `docs/` = it's documentation
- `testing-patterns` = what you're adding

## Step 2: Write the Standard Version

Create a new file called `docs/testing-patterns.md` and add this content:

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

Save the file.

**What Just Happened?**
You created the "standard" version of the documentation. This version is written for developers who understand the technical terminology.

## Step 3: Write the Terry Version

Now create `docs/testing-patterns-terry.md` with this content:

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

Save the file.

**What Just Happened?**
You created the "Terry" version - the accessible version that explains concepts more and uses simpler language. Notice how it's the same content but written differently.

## Step 4: Check Both Files Exist

Run this command to verify you created both versions:

```bash
./scripts/check-doc-pairs.sh
```

You should see:
```
Checking documentation pairs...

Checking testing-patterns.md... ✓ (has Terry version)

✓ All documentation has Terry versions!
```

**What Just Happened?**
This script checked that for every standard `.md` file, there's a matching `-terry.md` file. This is required by the template - every topic needs both versions.

**If You See Errors**:
- Red X means a Terry version is missing
- Double-check the file name ends with `-terry.md`
- Make sure it's in the `docs/` folder

## Step 5: Check Formatting

Run this command to check if your markdown is formatted correctly:

```bash
markdownlint docs/testing-patterns*.md
```

If you see errors, the output will tell you what to fix (like "line too long" or "missing blank line").

**What Just Happened?**
`markdownlint` is a tool that checks if your markdown follows standard formatting rules. It's like a spell-checker but for code formatting.

## Step 6: Add to the Comparison Page

The comparison page lets people see both versions side-by-side. Let's add your new topic to it.

Open `docs/comparison/index.html` in your editor and find the `<nav>` section (around line 50). Add this line:

```html
<button class="tab-btn" data-topic="testing-patterns">Testing Patterns</button>
```

Add it after the other button tags.

Save the file.

**What Just Happened?**
You added a navigation button to the comparison webpage. When people click "Testing Patterns", the page will load both versions of your documentation.

## Step 7: Test the Comparison Page

Open the comparison page in your browser:

```bash
# macOS:
open docs/comparison/index.html

# Linux:
xdg-open docs/comparison/index.html

# Windows:
start docs/comparison/index.html
```

Click the "Testing Patterns" button you just added. You should see:
- Left side: Your standard version
- Right side: Your Terry version

**What Just Happened?**
The webpage loaded both markdown files and displayed them side-by-side. This helps people see the difference between the two writing styles.

**If Nothing Loads**:
- Check your browser's console for errors (F12 key)
- Verify the file names are exactly `testing-patterns.md` and `testing-patterns-terry.md`
- Make sure they're in the `docs/` folder

## Step 8: Save Your Work with Git

Now let's save your changes. First, check what changed:

```bash
git status
```

You should see:
- `docs/testing-patterns.md`
- `docs/testing-patterns-terry.md`
- `docs/comparison/index.html`

Add these files to git:

```bash
git add docs/testing-patterns*.md docs/comparison/index.html
```

**What Just Happened?**
`git add` told git "I want to save these files." The `*` is a wildcard that matches both `testing-patterns.md` and `testing-patterns-terry.md`.

Now create a commit (a saved snapshot):

```bash
git commit -m "feat(docs): add testing patterns documentation

- Add standard version with Arrange-Act-Assert pattern
- Add Terry version with explanations and troubleshooting
- Update comparison page navigation
- Verified with check-doc-pairs.sh

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

**What Just Happened?**
`git commit` saved your changes with a message describing what you did. The message format:
- `feat(docs):` = feature in documentation area
- First line is a summary
- Bullet points describe details

## Step 9: Push to GitHub

Send your branch to GitHub:

```bash
git push -u origin feature/docs/testing-patterns
```

**What Just Happened?**
`git push` uploaded your branch to GitHub. The `-u origin feature/docs/testing-patterns` tells git where to send it (GitHub) and what to call it (same branch name).

## Step 10: Create a Pull Request

A pull request asks others to review your changes before merging them into the main version.

**Via GitHub Website**:
1. Go to your repository on GitHub
2. Click "Pull requests" tab
3. Click "New pull request"
4. Select your branch: `feature/docs/testing-patterns`
5. Click "Create pull request"
6. Add title: "feat(docs): add testing patterns documentation"
7. Add description explaining what you did
8. Click "Create pull request"

**Via Command Line** (if you have `gh` installed):
```bash
gh pr create \
  --title "feat(docs): add testing patterns documentation" \
  --body "Adds dual documentation for testing patterns with examples"
```

**What Just Happened?**
You created a request for someone to review and approve your changes. In a real project, team members would review your work before it's merged.

## Checklist: Did You Do Everything?

Before your pull request can be merged, check:

- [ ] Both `testing-patterns.md` and `testing-patterns-terry.md` exist
- [ ] `./scripts/check-doc-pairs.sh` passes (shows green checkmark)
- [ ] `markdownlint` passes (no errors)
- [ ] Comparison page shows both versions correctly
- [ ] Commit message follows format (feat/fix/docs)
- [ ] No Red Hat branding in your text
- [ ] No "Amber" terminology (use "Codebase Agent" instead)

## What You Just Learned

**Skills Practiced**:
1. Creating git branches
2. Writing dual documentation (standard + Terry)
3. Using validation scripts
4. Working with the comparison page
5. Git workflow (add, commit, push)
6. Creating pull requests

## Try These Next

Now that you've done this once, try:

1. **Add Another Topic**: Create documentation for "Security Patterns"
2. **Create a Diagram**: Make a Mermaid diagram showing the testing workflow
3. **Record a Tutorial**: Use `./scripts/record-demo.sh` to record a demo
4. **Explore Agent Config**: Look at files in `.claude/` to see how the AI agent is configured

## Common Problems and Solutions

**Problem**: "I can't find the file I just created"
**Solution**: Make sure you're in the right folder. Run `pwd` to see where you are. You should be in the template root folder.

**Problem**: "Git says 'permission denied'"
**Solution**: Make sure you've set up your GitHub credentials. Run `gh auth login` to authenticate.

**Problem**: "The comparison page shows an error"
**Solution**: Check the browser console (press F12). Common causes:
- File name typo (check spelling exactly)
- File not in `docs/` folder
- Missing `-terry.md` version

**Problem**: "I want to undo my changes"
**Solution**:
- Undo uncommitted changes: `git checkout -- <filename>`
- Delete the branch and start over: `git checkout main` then `git branch -D feature/docs/testing-patterns`

## More Resources

- [STYLE_GUIDE.md](STYLE_GUIDE.md) - How to write documentation
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Full contribution guidelines
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics) - Learn more about git
- [Markdown Guide](https://www.markdownguide.org/) - Markdown syntax reference

---

**Congratulations!** You just completed your first feature following the template workflow. You're ready to contribute to real projects!
