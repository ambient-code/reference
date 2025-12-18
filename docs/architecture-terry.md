# Architecture: How This Template is Organized

This page explains how the Ambient Code Reference Repository is structured and why we organized it this way.

## What This Template Contains

Think of this template like a toolkit. It doesn't include a finished application - instead, it provides **patterns and configuration** you can use in your own projects.

```
This Template
├── Configuration (how to set things up)
├── Documentation (guides and examples)
├── Automation (scripts that help you work)
└── Quality Tools (check your work automatically)
```

## Visual Overview

See the architecture diagram at [docs/diagrams/architecture.mmd](diagrams/architecture.mmd) for a visual map of how everything connects.

## The Four Main Parts

### 1. Configuration Files

**Where**: `.github/` and `.claude/` folders

**GitHub Configuration** (`.github/`):
- Workflows that run automatically when you save code
- Templates for reporting bugs or requesting features
- Settings to keep dependencies up to date

**AI Agent Configuration** (`.claude/`):
- Instructions for an AI "Codebase Agent" that can help automate tasks
- Knowledge modules that teach the agent about your project
- Custom commands you can use

**What Just Happened?**
Configuration files tell tools (like GitHub or AI agents) how to work with your project. They're like instruction manuals that automation reads.

### 2. Documentation System

**Where**: `docs/` folder

**Two Versions of Everything**:
- **Standard** (`topic.md`) - Written for experienced developers
- **Terry** (`topic-terry.md`) - Written to be accessible to everyone

**Also Includes**:
- **Diagrams** - Visual explanations using Mermaid (a text-based diagram tool)
- **Tutorials** - Recorded terminal sessions showing workflows
- **Comparison Page** - See both versions side-by-side

**What Just Happened?**
We write every guide twice because different people need different levels of explanation. The "Terry" versions (like this page!) explain more and use simpler language.

### 3. Automation Scripts

**Where**: `scripts/` folder

**What They Do**:
- `setup.sh` - Sets up everything when you first start (goal: under 10 minutes!)
- `validate-mermaid.sh` - Checks if diagrams have syntax errors
- `check-doc-pairs.sh` - Makes sure every standard doc has a Terry version
- `record-demo.sh` - Records tutorial videos
- `lint-all.sh` - Runs all quality checks

**What Just Happened?**
These are small programs that automate boring or repetitive tasks. Instead of manually checking everything, run a script and it does the work for you.

### 4. Quality Standards

**Where**: Various files defining rules

**What's Included**:
- `docs/STYLE_GUIDE.md` - How to write documentation
- `.github/PROJECT_BOARD.md` - How teams should work together
- `CLAUDE.md` - Special instructions for AI agents

**Automated Checks**:
- Formatting (are docs formatted correctly?)
- Syntax (do diagrams work?)
- Security (are there any secrets accidentally committed?)
- Pairs (does every doc have both versions?)

**What Just Happened?**
Quality standards are like spell-check for code and documentation. They catch mistakes automatically before they become problems.

## Key Design Principles

### The "Buffet Approach"

**What It Means**: Pick what you want, leave the rest.

At a buffet restaurant, you choose what food you want - you don't have to take everything. This template works the same way.

**Example**:
- Just want the documentation system? Copy the `docs/` folder
- Just want the AI agent setup? Copy the `.claude/` folder
- Want everything? Use the whole template

**Why This Matters**:
You're not forced to adopt everything at once. Start small, add more features when you're ready.

### Dual Documentation

**What It Means**: Two versions of every guide.

**Standard Version** (like `architecture.md`):
- Uses technical terms
- Assumes you know the basics
- Shorter and more direct

**Terry Version** (like this file!):
- Explains technical terms
- Assumes less background knowledge
- Includes "What Just Happened?" sections
- Has troubleshooting tips

**Why This Matters**:
Not everyone on a team has the same background. Developers might prefer the standard version, while managers or new team members might prefer the Terry version.

### No Application Code

**What It Means**: This template doesn't include a working application.

**What IS Included**:
- Setup instructions
- Configuration examples
- Documentation patterns
- Helper scripts

**What is NOT Included**:
- Web applications (like FastAPI or Django apps)
- Database code
- Business logic
- Actual API endpoints

**Why This Matters**:
This keeps the template focused on **how to organize and document** your project, not what your specific application does. You bring your own application code.

**How We Enforce This**:
Our automated checks will reject any attempt to add application code like `src/` or `app/` folders. This keeps the template clean and focused.

## How Files Are Organized

```
.
├── .github/                 # GitHub automation
│   ├── workflows/           # Automated checks
│   └── ISSUE_TEMPLATE/      # Bug report templates
│
├── .claude/                 # AI agent setup
│   ├── agents/              # Agent personality
│   ├── context/             # What the agent knows
│   └── commands/            # Custom commands
│
├── docs/                    # All documentation
│   ├── *.md                 # Standard versions
│   ├── *-terry.md           # Accessible versions
│   ├── diagrams/            # Visual explanations
│   ├── tutorials/           # Video demos
│   └── comparison/          # Side-by-side viewer
│
├── scripts/                 # Helper scripts
│   ├── setup.sh             # Initial setup
│   ├── validate-mermaid.sh  # Check diagrams
│   └── check-doc-pairs.sh   # Verify doc pairs
│
└── README.md                # Main introduction
```

## How Things Flow

### When You First Set Up

```
1. You run setup.sh
   ↓
2. Script checks if you have Git, Node.js
   ↓
3. Script verifies folders exist
   ↓
4. Script offers to install helpful tools
   ↓
5. Script runs tests
   ↓
6. Script reports how long it took (goal: under 10 minutes!)
```

### When You Save Code (Push to GitHub)

```
1. You push code to GitHub
   ↓
2. Security checks run (looking for secrets, app code)
   ↓
3. Documentation checks run (formatting, Terry pairs)
   ↓
4. Diagram checks run (syntax validation)
   ↓
5. Script checks run (quality validation)
   ↓
6. If everything passes, your code can be merged
```

### When You Write Documentation

```
1. Write the standard version (topic.md)
   ↓
2. Write the Terry version (topic-terry.md)
   ↓
3. Run check-doc-pairs.sh to verify both exist
   ↓
4. Add the topic to the comparison page
   ↓
5. Save both files together
```

## Common Questions

**Q: Why are there two versions of every doc?**
**A**: Different people need different levels of detail. Developers often prefer concise technical docs, while others benefit from more explanation. Both versions cover the same content, just written differently.

**Q: What's a "Mermaid diagram"?**
**A**: Mermaid is a way to create diagrams using text instead of a drawing tool. For example, you can type `A --> B` and it draws an arrow from A to B. Benefits: works in git, easy to update, GitHub renders it automatically.

**Q: Why not include an example application?**
**A**: That would limit the template to one type of application (like a web API). By keeping it infrastructure-only, you can use these patterns with **any** type of application.

**Q: What's the "Codebase Agent"?**
**A**: It's an AI assistant configured to help with your project. The `.claude/` folder contains instructions that teach the agent about your specific project's architecture, security standards, and testing patterns.

**Q: Can I delete parts I don't need?**
**A**: Yes! That's the buffet approach. If you don't need the AI agent setup, delete `.claude/`. If you don't need tutorials, delete `docs/tutorials/`. Pick what's useful for you.

## How to Extend This Template

### Adding a New Documentation Topic

1. Create the standard version: `docs/my-topic.md`
2. Create the Terry version: `docs/my-topic-terry.md`
3. Open `docs/comparison/index.html` and add your topic to the navigation
4. Run `./scripts/check-doc-pairs.sh` to verify both files exist

### Adding a New Diagram

1. Create the diagram file: `docs/diagrams/my-diagram.mmd`
2. Write the Mermaid syntax (see [Mermaid docs](https://mermaid.js.org/))
3. Test it: `./scripts/validate-mermaid.sh`
4. Reference it in documentation: `![Diagram](diagrams/my-diagram.mmd)`

### Adding AI Agent Knowledge

1. Create a knowledge file: `.claude/context/my-topic.md`
2. Write patterns and examples (keep it technology-agnostic)
3. Make sure it works standalone (no dependencies on other files)
4. Optionally reference it from `.claude/agents/codebase-agent.md`

## Security Features

**What We Check For**:
- **Secrets** - API keys, passwords, tokens (these should never be in git!)
- **Application Code** - Keeps template focused on infrastructure
- **Branding** - Ensures template stays vendor-neutral

**How It Works**:
Automated workflows scan every code change for these issues. If found, the merge is blocked and you'll see an error explaining what was detected.

**What Just Happened?**
Security checks are like airport security for your code. They catch dangerous items (secrets) before they can cause problems.

## Performance Goals

These are targets we aim for:

- **Setup**: Complete in under 10 minutes
- **CI/CD Checks**: Run in under 5 minutes
- **Diagram Validation**: Check all diagrams in under 30 seconds
- **Documentation Checks**: Validate all docs in under 1 minute

**Why This Matters**:
Fast automation means quick feedback. If a check takes too long, people skip it. By keeping everything fast, we encourage everyone to run the checks.

## Learn More

- [STYLE_GUIDE.md](STYLE_GUIDE.md) - How to write good documentation
- [PROJECT_BOARD.md](../.github/PROJECT_BOARD.md) - How teams work together
- [Mermaid Syntax Guide](https://mermaid.js.org/) - How to create diagrams
- [ZeroMQ Guide](https://zeromq.org/get-started/) - Inspiration for our writing style

---

**Next Steps**: Now that you understand how everything is organized, check out the [Tutorial](tutorial-terry.md) to start building your first feature!
