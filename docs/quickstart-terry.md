# Quickstart Guide

Get started with the Ambient Code Reference Repository. This guide walks you through setup step-by-step.

## What You'll Need

**Required**:
- Git (version control software) - Download from [git-scm.com](https://git-scm.com/)
- GitHub account (free) - Sign up at [github.com](https://github.com/)
- Terminal or command prompt on your computer

**Optional but Helpful**:
- Node.js (JavaScript runtime) - Download from [nodejs.org](https://nodejs.org/)
- npm (package manager, comes with Node.js)

## Setup Steps

### Step 1: Create Your Repository

1. Go to the Ambient Code Reference Repository on GitHub
2. Click the green **"Use this template"** button (top right)
3. Choose a name for your repository
4. Click **"Create repository from template"**

**What Just Happened?**
GitHub copied all the files from this template into your new repository. You now have your own copy to work with.

### Step 2: Download to Your Computer

Open your terminal and run these commands (replace with your details):

```bash
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
cd YOUR_REPO_NAME
```

**What Just Happened?**
`git clone` downloaded your repository to your computer. The `cd` command moved you into that folder so you can work with the files.

### Step 3: Run the Setup Script

```bash
./scripts/setup.sh
```

The setup script will:
1. Check if you have the required software (Git, Node.js)
2. Verify all folders are in the right place
3. Ask if you want to install helpful tools
4. Run some quick tests
5. Tell you how long it took (goal: under 10 minutes!)

**During Setup**:
- If asked about installing tools, type `y` and press Enter to say yes
- If you don't have Node.js, you'll see warnings - that's okay for now
- Watch for any error messages (red text)

**What Just Happened?**
The setup script checked your environment and prepared everything you need. It's like an automated assistant that makes sure you have all the tools ready.

### Step 4: Install Extra Tools (Optional)

If you have Node.js but skipped tool installation, you can install them now:

```bash
npm install -g @mermaid-js/mermaid-cli markdownlint-cli
```

- `@mermaid-js/mermaid-cli` - Checks diagram syntax
- `markdownlint-cli` - Checks documentation formatting

**What Just Happened?**
`npm install -g` installed tools globally on your computer (the `-g` means "global"). These tools help catch errors in diagrams and documentation.

### Step 5: Test Everything Works

Run these commands to verify your setup:

```bash
# Check if documentation pairs exist
./scripts/check-doc-pairs.sh

# Check if diagrams are valid
./scripts/validate-mermaid.sh
```

You might see warnings like "No documentation files found yet" - that's normal! You'll create those files as you work.

**View the Comparison Page**:

```bash
# macOS:
open docs/comparison/index.html

# Linux:
xdg-open docs/comparison/index.html

# Windows:
start docs/comparison/index.html
```

**What Just Happened?**
These commands tested different parts of the template. The comparison page shows documentation side-by-side in different styles (we'll explain more about that later).

## What's Included in This Template

**Documentation System**:
- Every topic has two versions: standard (technical) and Terry (accessible)
- A comparison webpage to see both versions side-by-side
- Architecture diagrams that explain how things work visually

**AI Agent Setup**:
- Configuration for a "Codebase Agent" that can help automate tasks
- Knowledge modules that teach the agent about your project
- Custom commands you can use

**Automated Checks**:
- Validates your documentation formatting
- Checks diagram syntax
- Scans for security issues
- Rebuilds tutorial videos automatically

**Helper Scripts**:
- `setup.sh` - Sets up everything (what you just ran)
- `validate-mermaid.sh` - Checks if diagrams are correct
- `check-doc-pairs.sh` - Makes sure every document has both versions
- `record-demo.sh` - Records tutorial videos

## Quick Command Reference

**Before Saving Your Work**:
```bash
# Check diagrams are valid
./scripts/validate-mermaid.sh

# Check documentation pairs exist
./scripts/check-doc-pairs.sh
```

**Creating New Documentation**:
1. Create the technical version: `docs/my-topic.md`
2. Create the accessible version: `docs/my-topic-terry.md`
3. Check both exist: `./scripts/check-doc-pairs.sh`

**Adding a Diagram**:
1. Create diagram file: `docs/diagrams/my-diagram.mmd`
2. Test it works: `./scripts/validate-mermaid.sh`

## What to Explore Next

1. **[Architecture](architecture-terry.md)** - Understand how the template is organized
2. **[Tutorial](tutorial-terry.md)** - Build your first feature
3. **[Contributing](contributing-terry.md)** - Learn how to make changes
4. **[Development](development-terry.md)** - Daily workflow tips

## Troubleshooting

**Problem**: "Command not found: mmdc"
**Solution**: Install mermaid-cli:
```bash
npm install -g @mermaid-js/mermaid-cli
```

**Problem**: "Setup is taking forever!"
**Solution**:
- Check your internet connection (the script downloads tools)
- See how long it's taking: `time ./scripts/setup.sh`
- The goal is under 10 minutes, but slower connections might take longer

**Problem**: "Script says documentation pairs are missing"
**Solution**: This is normal when you first start! The template includes examples, but you'll create your own documentation files as you work. Each topic needs two files: `topic.md` and `topic-terry.md`.

**Problem**: "I don't understand what 'Terry documentation' means"
**Solution**: "Terry" is our name for accessible, jargon-free documentation. Think of it like this:
- **Standard** = Written for developers with experience
- **Terry** = Written for anyone to understand, with explanations

**Problem**: "The setup script found errors"
**Solution**:
- Red text shows errors that must be fixed
- Yellow text shows warnings (optional, but recommended)
- Read the error message - it usually explains what's wrong

## Getting Help

**For Questions**:
- [GitHub Discussions](../../discussions) - Ask questions, share ideas

**For Bugs**:
- [GitHub Issues](../../issues) - Report problems

**For Writing Documentation**:
- [STYLE_GUIDE.md](STYLE_GUIDE.md) - How to write both standard and Terry docs

**For Understanding the Workflow**:
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md) - How the team works

---

**You're Ready!** You've completed the quickstart setup. The template is installed and ready for you to customize for your project.
