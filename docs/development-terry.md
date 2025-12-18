# Development: Your Daily Workflow

How to work with this template day-to-day, including making changes, testing them, and saving your work.

## What You'll Need

- The template set up on your computer (you ran `./scripts/setup.sh`)
- A text editor you like (VS Code, Sublime Text, etc.)
- Optional tools installed (makes life easier but not required)

## Your Daily Routine

### Step 1: Start a New Feature

Every time you want to add something or fix something, create a "branch" - a separate workspace for your changes.

```bash
git checkout main
git pull origin main
git checkout -b feature/docs/my-topic
```

**What Just Happened?**
- `git checkout main` switched to the main branch
- `git pull origin main` downloaded latest changes from GitHub
- `git checkout -b feature/docs/my-topic` created a new branch and switched to it

**Branch Naming Pattern**:
- `feature/docs/topic-name` - Adding documentation
- `feature/cicd/workflow-name` - Adding automation
- `feature/agent/module-name` - Adding agent configuration
- `fix/issue-number-description` - Fixing a bug

### Step 2: Make Your Changes

Depending on what you're working on:

**Adding Documentation**:
1. Create `docs/my-topic.md` (technical version)
2. Create `docs/my-topic-terry.md` (accessible version)
3. Open `docs/comparison/index.html` and add a navigation button

**Adding a Diagram**:
1. Create `docs/diagrams/my-diagram.mmd`
2. Test it: `mmdc -i docs/diagrams/my-diagram.mmd -o /tmp/test.svg`

**Adding a Script**:
1. Create or edit `scripts/my-script.sh`
2. Make it executable: `chmod +x scripts/my-script.sh`
3. Test it: `./scripts/my-script.sh`

**Adding Automation**:
1. Create `.github/workflows/my-workflow.yml`
2. Push to your branch to test it

### Step 3: Check Your Work

Before saving, run these commands to catch errors:

```bash
# Check documentation pairs exist
./scripts/check-doc-pairs.sh

# Check diagrams are valid
./scripts/validate-mermaid.sh

# Check markdown formatting
markdownlint docs/*.md

# Check script quality
shellcheck scripts/*.sh
```

**What Just Happened?**
These scripts check for common mistakes:
- Missing Terry versions
- Diagram syntax errors
- Markdown formatting issues
- Script problems

**Why This Matters**:
GitHub runs the same checks automatically. Finding errors now means faster approval later.

### Step 4: Save Your Changes

First, see what changed:

```bash
git status
```

This shows all files you modified.

Then save your changes:

```bash
# Add all changes
git add -A

# Create a commit
git commit -m "feat(docs): add deployment guide

- Add standard version with container examples
- Add Terry version with explanations
- Update comparison page

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Commit Message Format**:
```
type(area): short description

Optional longer explanation

Optional issue reference
```

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation only
- `chore` - Maintenance (no functional changes)
- `ci` - CI/CD changes

**What Just Happened?**
`git commit` saved a snapshot of your changes with a description. You can always go back to this point if needed.

### Step 5: Share Your Work

Push your branch to GitHub:

```bash
git push -u origin feature/docs/my-topic
```

Create a pull request:

```bash
gh pr create \
  --title "feat(docs): add deployment guide" \
  --body "Adds deployment documentation with container examples"
```

**What Just Happened?**
- `git push` uploaded your branch to GitHub
- `gh pr create` created a pull request asking to merge your changes

## Validation Commands Explained

### Check Documentation Pairs

```bash
./scripts/check-doc-pairs.sh
```

**What It Checks**:
- Every `docs/{topic}.md` has a matching `docs/{topic}-terry.md`

**Example Output**:
```
Checking documentation pairs...

Checking deployment.md... ✓ (has Terry version)
Checking tutorial.md... ✗ MISSING
  Expected: docs/tutorial-terry.md
```

**What Just Happened?**
The script found that `tutorial.md` exists but `tutorial-terry.md` doesn't. You need to create the Terry version.

### Validate Diagrams

```bash
./scripts/validate-mermaid.sh
```

**What It Checks**:
- All `.mmd` files in `docs/diagrams/` have valid syntax

**Example Output**:
```
Found 3 diagram(s) to validate...

Checking architecture.mmd... ✓
Checking workflow.mmd... ✗ FAILED
  Syntax error in docs/diagrams/workflow.mmd
```

**What Just Happened?**
The script tried to convert each diagram to an image. If conversion fails, there's a syntax error.

**How to Fix**:
Open the file and check for:
- Missing semicolons
- Unclosed quotes
- Invalid arrow syntax (use `-->` not `->`)

### Check Markdown Formatting

```bash
markdownlint docs/*.md
```

**What It Checks**:
- Proper heading hierarchy (don't skip levels)
- Consistent list formatting
- Blank lines around headings
- Other markdown best practices

**Example Output**:
```
docs/tutorial.md:45 MD012/no-multiple-blanks Multiple consecutive blank lines
```

**What Just Happened?**
Line 45 of `tutorial.md` has multiple blank lines in a row. Delete the extra blank lines.

### Check Scripts

```bash
shellcheck scripts/*.sh
```

**What It Checks**:
- Missing quotes around variables
- Using undefined variables
- Incorrect command syntax
- Other bash best practices

**Example Output**:
```
In scripts/validate.sh line 10:
echo $FILE
     ^---^ SC2086: Double quote to prevent globbing and word splitting.
```

**What Just Happened?**
Shellcheck found that `$FILE` should be `"$FILE"` (with quotes). This prevents errors when the filename has spaces.

## Common Tasks Step-by-Step

### Adding a New Documentation Topic

**Goal**: Add documentation about "Testing Patterns"

**Steps**:

1. Create the standard version:
```bash
cat > docs/testing-patterns.md <<'EOF'
# Testing Patterns

Best practices for testing.

## Unit Testing

Test individual functions in isolation.

## Integration Testing

Test how components work together.
EOF
```

2. Create the Terry version:
```bash
cat > docs/testing-patterns-terry.md <<'EOF'
# Testing Patterns: Making Sure Your Code Works

Learn how to test your application.

## Unit Testing: Testing Small Pieces

A unit test checks one function at a time.

**What Just Happened?**
We isolated the function from the rest of the system to test it independently.

## Integration Testing: Testing How Things Work Together

Integration tests check if different parts of your application work together correctly.

## Troubleshooting

**Problem**: Tests fail unexpectedly
**Solution**: Check if you have all dependencies installed
EOF
```

3. Add to comparison page:
```bash
# Edit docs/comparison/index.html
# Add this line in the <nav> section:
# <button class="tab-btn" data-topic="testing-patterns">Testing Patterns</button>
```

4. Validate:
```bash
./scripts/check-doc-pairs.sh
# Should show: Checking testing-patterns.md... ✓
```

5. Save:
```bash
git add docs/testing-patterns*.md docs/comparison/index.html
git commit -m "feat(docs): add testing patterns documentation"
```

**What Just Happened?**
You created a complete documentation pair, added it to the comparison page, validated it, and saved it.

### Adding a Diagram

**Goal**: Create an architecture diagram

```bash
# 1. Create diagram file
cat > docs/diagrams/testing-workflow.mmd <<'EOF'
graph TB
    A[Write Code] --> B[Write Tests]
    B --> C[Run Tests]
    C --> D{Tests Pass?}
    D -->|Yes| E[Commit]
    D -->|No| F[Fix Code]
    F --> C
EOF

# 2. Validate
./scripts/validate-mermaid.sh

# 3. Reference in documentation
echo "See [testing workflow](diagrams/testing-workflow.mmd)" >> docs/testing-patterns.md

# 4. Save
git add docs/diagrams/testing-workflow.mmd docs/testing-patterns.md
git commit -m "feat(docs): add testing workflow diagram"
```

**What Just Happened?**
You created a diagram showing the testing workflow, validated it has no syntax errors, linked it from your documentation, and saved everything.

### Testing a Script Change

**Goal**: Improve the validate-mermaid.sh script

```bash
# 1. Edit the script
# (make your changes in your editor)

# 2. Test it
./scripts/validate-mermaid.sh
# Check output looks correct

# 3. Check for common mistakes
shellcheck scripts/validate-mermaid.sh

# 4. If shellcheck suggests changes, make them

# 5. Test again
./scripts/validate-mermaid.sh

# 6. Save
git add scripts/validate-mermaid.sh
git commit -m "fix(scripts): improve error messages in mermaid validator"
```

**What Just Happened?**
You modified a script, tested it works, validated it follows best practices with shellcheck, and saved your changes.

## Troubleshooting Common Problems

### "Check-doc-pairs fails but I created both files"

**Possible Causes**:
1. Filename typo (check spelling exactly)
2. Wrong location (must be in `docs/` folder)
3. Extension wrong (must be `.md`, not `.txt` or `.markdown`)

**How to Check**:
```bash
ls -la docs/testing-patterns*.md
# Should show both files
```

### "Mermaid validation fails but diagram looks fine"

**Common Syntax Errors**:

Wrong:
```mermaid
graph LR
    A->B  # Wrong arrow syntax
```

Right:
```mermaid
graph LR
    A-->B  # Correct arrow syntax
```

Wrong:
```mermaid
graph TB
    A[Start] --> B[End  # Missing closing bracket
```

Right:
```mermaid
graph TB
    A[Start] --> B[End]  # Closing bracket added
```

### "Shellcheck complains about my script"

**Common Fixes**:

**Quote Variables**:
```bash
# Wrong
echo $FILE

# Right
echo "$FILE"
```

**Check Commands Exist**:
```bash
# Add at start of script
if ! command -v mmdc &> /dev/null; then
    echo "Error: mmdc not found"
    exit 1
fi
```

**Use set -e**:
```bash
#!/bin/bash
set -e  # Exit immediately if any command fails
```

### "Git says there are conflicts"

**What Happened**: Someone else changed the same file you did.

**How to Fix**:
```bash
# 1. Update your main branch
git checkout main
git pull origin main

# 2. Go back to your branch
git checkout feature/my-changes

# 3. Merge main into your branch
git merge main
# Git will tell you which files have conflicts

# 4. Open the conflicting files
# Look for markers like <<<<<<< and >>>>>>>
# Edit the file to keep what you want

# 5. Save the fixed files
git add -A
git commit -m "merge: resolve conflicts with main"
```

**What Just Happened?**
Git merged the latest changes from main into your branch. Where there were conflicts (you both changed the same lines), it marked them for you to resolve manually.

## Best Practices

### Before Committing

Always run:
```bash
./scripts/check-doc-pairs.sh
./scripts/validate-mermaid.sh
markdownlint docs/*.md
shellcheck scripts/*.sh
```

**Why**: Catches errors before they reach GitHub.

### Commit Often

**Good**: Small, focused commits
```
feat(docs): add quickstart guide
fix(scripts): handle missing mmdc gracefully
docs: fix typo in README
```

**Bad**: Giant commits
```
feat: add all documentation, fix scripts, update workflows, and refactor everything
```

**Why**: Small commits are easier to review and easier to undo if something breaks.

### Test Locally

Don't rely on CI/CD to find errors:
1. Run validation scripts locally
2. Test your changes work
3. Then commit and push

**Why**: Faster feedback loop and you don't waste CI/CD minutes.

## More Resources

- [STYLE_GUIDE.md](STYLE_GUIDE.md) - How to write documentation
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Full contribution guide
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md) - Team workflow
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- [Shellcheck Tutorial](https://github.com/koalaman/shellcheck/wiki)

---

**Next**: Learn about the [Agent Workflow](agent-workflow-terry.md) to see how the AI assistant can help automate tasks.
