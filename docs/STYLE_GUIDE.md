# Documentation Style Guide

**Purpose**: Ensure consistency and quality across all documentation in the Ambient Code Reference Repository

**Applies To**: All documentation files in `docs/`, `README.md`, `CONTRIBUTING.md`, and `.claude/` directories

---

## Core Principles

### ZeroMQ-Style Documentation

Follow ZeroMQ's approach: **succinct, actionable, no fluff**

**Good Example**:
```markdown
## Setup

Clone the repository and run the setup script:
```bash
git clone <repo-url>
cd ambient-reference-repo
./scripts/setup.sh
```

Completes in under 10 minutes.
```

**Bad Example** (AI slop):
```markdown
## Getting Started on Your Amazing Journey!

We're absolutely thrilled that you've chosen to embark on this incredible adventure with our groundbreaking template! Let's dive into the exciting world of setup...
```

**Rules**:
- ❌ No superlatives ("amazing", "incredible", "groundbreaking")
- ❌ No excessive enthusiasm or filler
- ❌ No apologetic language ("just", "simply", "unfortunately")
- ✅ Direct, clear, technical language
- ✅ Action-oriented headings
- ✅ Code examples without excessive commentary

---

## Standard Documentation Style

**Audience**: Experienced developers familiar with the domain

**Tone**: Technical, concise, assumes background knowledge

**Structure**:
```markdown
# Topic Title

## Overview
[1-2 sentences: what and why]

## Prerequisites
- Tool/knowledge required (no explanation needed)

## Implementation
[Code examples with minimal commentary]

## Next Steps
- [Related topic](link)
```

**Characteristics**:
- Uses industry-standard terminology without definition
- Code examples assume familiarity with languages/tools
- Links to external documentation instead of explaining basics
- Focuses on "what" and "how", assumes reader knows "why"

**Example**:
```markdown
## CI/CD Integration

Add validation workflow to `.github/workflows/`:

```yaml
name: Validate
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/validate-mermaid.sh
```

Triggers on every push and PR. See [GitHub Actions docs](https://docs.github.com/actions) for advanced configuration.
```

---

## Terry Documentation Style

**Audience**: Non-technical stakeholders, developers new to the domain, or those seeking accessible explanations

**Tone**: Clear, friendly (not over-enthusiastic), educational

**Structure**:
```markdown
# Topic Title

## What You'll Need
[Prerequisites with brief explanations]

## What This Does
[Clear explanation of value and outcomes]

## Step-by-Step Guide

### Step 1: [Action]
[Clear instruction with context]

**What Just Happened?**
[Explanation of what occurred and why it matters]

### Step 2: [Action]
[Continue...]

## Troubleshooting
[Common issues with solutions]

## What's Next
[Links with brief descriptions]
```

**Characteristics**:
- Plain language, minimal jargon
- Acronyms spelled out on first use: "Continuous Integration/Continuous Deployment (CI/CD)"
- "What Just Happened?" sections explain technical concepts
- Analogies for complex ideas (used sparingly)
- Active voice, short sentences (15-20 words avg)
- Troubleshooting sections anticipate confusion

**Example**:
```markdown
## Setting Up Automated Checks

### What You'll Need
- GitHub repository access
- Basic understanding of version control (git commands like push, pull, commit)

### What This Does
Automated checks run every time you make changes, catching errors before they reach production. Think of it like spell-check for code.

### Step 1: Add the Workflow File
Create a new file at `.github/workflows/validate.yml` with this content:

```yaml
name: Validate
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/validate-mermaid.sh
```

**What Just Happened?**
You created a "workflow" - a set of automated instructions that GitHub will follow. The `on: [push, pull_request]` line tells GitHub "run these checks whenever code is pushed or a pull request is opened."

### Troubleshooting

**Problem**: "Workflow not running"
**Solution**: Check that the file is in `.github/workflows/` (note the plural "workflows") and has a `.yml` extension.
```

---

## Code Examples

### Formatting

**Always**:
- Specify language for syntax highlighting: ` ```python`, ` ```yaml`, ` ```bash`
- Include file paths in comments when relevant: `# File: .github/workflows/validate.yml`
- Keep examples focused (5-20 lines ideal, not full files)
- Show realistic examples, not toy code

**Example**:
```markdown
Create `scripts/setup.sh`:

```bash
#!/bin/bash
set -e

echo "Setting up Ambient Code Reference Repository..."

# Validate environment
if ! command -v git &> /dev/null; then
  echo "Error: git not found"
  exit 1
fi

echo "✓ Setup complete!"
```
```

---

## Markdown Structure

### Headings

**Hierarchy**:
- `# H1`: Document title (one per file)
- `## H2`: Major sections
- `### H3`: Subsections
- `#### H4`: Rarely needed (consider restructuring if you need H4)

**Naming**:
- ✅ Action-oriented: "Configure GitHub Template", "Run Validation"
- ❌ Vague: "Configuration", "Validation"
- ✅ Specific: "Create .github/workflows/validate-docs.yml"
- ❌ Generic: "Create Files"

### Lists

**Unordered** (bullet points):
- Use for collections without specific order
- Start with dash `-` (not asterisk `*`)
- Capitalize first word, no period if single sentence
- Use period if multiple sentences

**Ordered** (numbered):
- Use for sequential steps
- Use for priority/ranking
- Restart numbering at 1 for each list

**Example**:
```markdown
## Prerequisites
- Git 2.30+
- Node.js 18+ (for CLI tools)
- GitHub account with repository access

## Setup Steps
1. Clone repository: `git clone <url>`
2. Run setup script: `./scripts/setup.sh`
3. Verify installation: `./scripts/validate-mermaid.sh`
```

### Links

**Internal Links** (within repository):
```markdown
See [Architecture](./architecture.md) for system design.
See [spec.md](../specs/001-ambient-reference-repo/spec.md) for requirements.
```

**External Links** (with context):
```markdown
Read the [ZeroMQ Guide](https://zeromq.org/get-started/) for documentation style examples.
```

**Anchor Links** (within same file):
```markdown
Jump to [Terry Documentation Style](#terry-documentation-style)
```

---

## File Naming

### Documentation Files

**Pattern**: `docs/{topic-name}.md` and `docs/{topic-name}-terry.md`

**Rules**:
- All lowercase
- Hyphens for spaces: `api-reference.md`, not `api_reference.md` or `API-Reference.md`
- Descriptive: `contributing.md`, not `contrib.md`
- Standard/Terry pairs: `quickstart.md` + `quickstart-terry.md`

### Diagrams

**Pattern**: `docs/diagrams/{diagram-name}.mmd`

**Examples**:
- `architecture.mmd`
- `agent-workflow.mmd`
- `ci-cd-pipeline.mmd`

### Tutorials

**Pattern**: `docs/tutorials/{tutorial-name}.cast`

**Examples**:
- `setup.cast`
- `first-feature.cast`
- `agent-workflow.cast`

---

## Language & Grammar

### Active Voice

**Preferred**:
- "The script validates diagrams" (active)
- "Run the setup script" (imperative, active)

**Avoid**:
- "Diagrams are validated by the script" (passive)

### Present Tense

**Preferred**:
- "The workflow runs on every push"
- "Click the template button"

**Avoid**:
- "The workflow will run on every push" (future tense unnecessary for facts)

### Sentence Length

**Standard Documentation**:
- Average: 15-25 words
- Maximum: 30 words
- Use semicolons or split long sentences

**Terry Documentation**:
- Average: 12-18 words
- Maximum: 25 words
- Shorter sentences for clarity

### Paragraph Length

**Both Styles**:
- Ideal: 2-4 sentences
- Maximum: 6 sentences
- Use headings to break up long content

---

## Special Elements

### "What Just Happened?" Sections (Terry Only)

**Purpose**: Explain technical concepts after procedural steps

**Placement**: After every major step or code example that introduces new concepts

**Structure**:
```markdown
**What Just Happened?**
[1-3 sentences explaining the technical concept in plain language]
```

**Example**:
```markdown
### Step 3: Commit Your Changes

Run:
```bash
git add .
git commit -m "Add dual documentation system"
```

**What Just Happened?**
`git add .` staged all your changes (marked them ready for commit), and `git commit` saved those changes to your local repository with a descriptive message. Your changes aren't on GitHub yet - that happens in the next step with `git push`.
```

### Troubleshooting Sections (Terry Only)

**Format**:
```markdown
## Troubleshooting

**Problem**: [Clear description of what went wrong]
**Solution**: [Step-by-step fix]

**Problem**: [Another issue]
**Solution**: [Fix]
```

### Code Comments

**Standard Documentation**: Minimal comments, code should be self-explanatory

**Terry Documentation**: More explanatory comments

**Example**:

*Standard*:
```bash
#!/bin/bash
set -e
find docs/diagrams -name "*.mmd" | while read file; do
  mmdc -i "$file" -o /tmp/test.svg
done
```

*Terry*:
```bash
#!/bin/bash
set -e  # Exit immediately if any command fails

# Find all Mermaid diagram files
find docs/diagrams -name "*.mmd" | while read file; do
  # Validate each diagram by trying to convert to SVG
  mmdc -i "$file" -o /tmp/test.svg
done
```

---

## Validation Checklist

Before committing documentation:

### All Documentation
- [ ] No AI slop (superlatives, excessive enthusiasm, filler)
- [ ] Code blocks have language specified
- [ ] Links are relative (internal) or include context (external)
- [ ] Headings are action-oriented
- [ ] Sentences are concise (see length guidelines)
- [ ] Active voice throughout

### Standard Documentation
- [ ] Assumes technical audience
- [ ] Uses industry terminology without over-explanation
- [ ] Code examples are realistic
- [ ] Links to external docs instead of explaining basics

### Terry Documentation
- [ ] "What Just Happened?" sections after complex steps
- [ ] Acronyms spelled out on first use
- [ ] Plain language, minimal jargon
- [ ] Troubleshooting section present
- [ ] No assumptions about prior knowledge

### File Pairs
- [ ] Both standard and Terry versions exist
- [ ] File names follow convention: `{topic}.md` and `{topic}-terry.md`
- [ ] Content covers same topics (different style/depth)

---

## Style Enforcement

### Automated Checks (CI)
- `markdownlint` catches formatting issues
- `check-doc-pairs.sh` verifies Terry versions exist
- Link checking validates references

### Manual Review
- Peer review for AI slop detection
- Terry agent review for accessibility
- Technical accuracy review for standard docs

---

## Examples

### Excellent Documentation (Standard)

From ZeroMQ Guide:

> ## Request-Reply Pattern
>
> The request-reply pattern connects a set of clients to a set of services. This is a remote procedure call and task distribution pattern.
>
> ```python
> import zmq
> context = zmq.Context()
> socket = context.socket(zmq.REP)
> socket.bind("tcp://*:5555")
> ```

**Why it's good**:
- Concise definition (1 sentence)
- Immediate code example
- No fluff or apologies

### Excellent Documentation (Terry)

> ## Making Your First Code Change
>
> ### What You'll Need
> - A code editor (VS Code, Sublime, or any text editor)
> - Your cloned repository open
>
> ### Step 1: Edit the README
> Open `README.md` in your editor and add a sentence describing your project.
>
> **What Just Happened?**
> You modified a markdown file, which is like a text document with special formatting. When GitHub displays this file, it will show your new description.
>
> ### Troubleshooting
> **Problem**: "Can't find README.md"
> **Solution**: Make sure you're in the repository's root directory (the folder you cloned). Run `ls` to list files - you should see README.md.

**Why it's good**:
- Explains prerequisites with context
- "What Just Happened?" explains markdown concept
- Troubleshooting anticipates confusion
- No jargon without explanation

---

## Anti-Patterns

### AI Slop Indicators

❌ **Over-enthusiasm**:
> "Let's embark on an exciting journey into the amazing world of CI/CD!"

✅ **Professional**:
> "This section covers CI/CD pipeline configuration."

❌ **Apologetic**:
> "Unfortunately, you'll need to install Node.js. Sorry for the inconvenience!"

✅ **Matter-of-fact**:
> "Install Node.js 18+ before proceeding."

❌ **Hedging**:
> "You might want to consider maybe possibly running the tests..."

✅ **Direct**:
> "Run tests before committing: `pytest tests/`"

❌ **Unnecessary praise**:
> "Great job! You've successfully created an amazing documentation system that will revolutionize how teams collaborate!"

✅ **Factual**:
> "Documentation pairs created. Run `./scripts/check-doc-pairs.sh` to verify."

---

## Reference Materials

**Excellent Style Examples**:
- [ZeroMQ Guide](https://zeromq.org/get-started/) - Succinct technical writing
- [Stripe API Docs](https://stripe.com/docs/api) - Clear, actionable API documentation
- [Django Tutorial](https://docs.djangoproject.com/en/stable/intro/tutorial01/) - Good balance of explanation and code

**Avoid**:
- Marketing copy style
- Academic paper style (overly formal)
- Blog post style (conversational but unfocused)

---

**Last Updated**: 2025-12-17
**Maintained By**: Documentation team (see CONTRIBUTING.md for changes)
