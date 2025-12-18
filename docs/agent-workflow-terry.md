# Agent Workflow: Working with the AI Assistant

Learn how the Codebase Agent (CBA) can help automate development tasks.

## What is the Codebase Agent?

The Codebase Agent is an AI assistant configured specifically for this repository. Think of it as a helpful team member who:
- Knows the project structure and standards
- Can write code and documentation
- Reviews your work
- Automates repetitive tasks

**Key Point**: The agent follows rules defined in `.claude/` directory files.

## How the Agent Helps

### What It Can Do

**Documentation**:
- Write both standard and Terry versions
- Fix typos and improve clarity
- Ensure style guide compliance

**Code**:
- Implement features from issues
- Write tests
- Refactor code

**Review**:
- Check for security issues
- Verify style compliance
- Suggest improvements

**Automation**:
- Run validation scripts
- Create pull requests
- Update diagrams

### What It Can't Do

**For Safety**:
- Can't directly access production systems
- Can't execute code without your approval
- Can't override security rules
- Can't push code without review

## The Complete Workflow

### Step 1: Create an Issue

Write a clear GitHub issue describing what you want:

```markdown
Title: Add deployment documentation

Description:
Create documentation explaining how to deploy using containers.

What to include:
- How to build a container
- How to run the container locally
- How to deploy to Kubernetes
- Common troubleshooting tips

Acceptance criteria:
- Both standard and Terry versions created
- Comparison page updated
- All validation scripts pass
```

**What Makes a Good Issue**:
- Clear title
- Detailed description
- Specific requirements
- Acceptance criteria (how you know it's done)

**What Just Happened?**
You described the work needed in a format the agent can understand. The more specific you are, the better the result.

### Step 2: Ask the Agent to Help

Add a label to the issue: `cba:implement`

Or comment on the issue:
```
@codebase-agent please implement this issue
```

**What Just Happened?**
You triggered the agent to start working. It will read the issue and create a plan.

### Step 3: Review the Plan

The agent responds with a plan:

```markdown
## Implementation Plan

I'll create:
1. docs/deployment.md (technical version)
2. docs/deployment-terry.md (accessible version)
3. Update docs/comparison/index.html

Approach:
- Research best practices for Podman and Kubernetes
- Write standard version following the style guide
- Create Terry version with explanations
- Add "What Just Happened?" sections
- Include troubleshooting

Estimated time: 30 minutes
Complexity: Medium

Any concerns or changes needed?
```

**What Just Happened?**
The agent analyzed your issue, checked the project standards (from `.claude/` files), and created a step-by-step plan.

**Your Options**:
- ✅ "Looks good, proceed"
- ❌ "Add Docker Compose examples too"
- ⏸️ "Wait, let me clarify the requirements"

### Step 4: Agent Does the Work

Once approved, the agent:

1. Creates a new branch: `feature/docs/deployment`
2. Writes the documentation files
3. Updates the comparison page
4. Runs validation scripts
5. Creates a git commit
6. Pushes the branch
7. Creates a pull request

**What Just Happened?**
The agent did all the mechanical work - creating files, following standards, testing - just like a developer would.

### Step 5: Review the Pull Request

The agent's pull request includes:

```markdown
## Summary
Implements #123: Add deployment documentation

## Changes
- ✅ Created docs/deployment.md
- ✅ Created docs/deployment-terry.md
- ✅ Updated comparison page navigation

## Testing Done
- Ran check-doc-pairs.sh ✓
- Ran markdownlint ✓
- Tested comparison page ✓

## Checklist
- [x] Both versions created
- [x] Follows STYLE_GUIDE.md
- [x] No Red Hat branding
- [x] No "Amber" terminology
- [x] CI checks passing
```

**What Just Happened?**
The agent created a complete pull request with all the documentation you requested, already tested and validated.

**What You Do**:
- Review the content
- Request changes if needed
- Approve and merge when satisfied

## How the Agent Knows What to Do

### Configuration Files

The agent reads these files to understand the project:

**Agent Personality** (`.claude/agents/codebase-agent.md`):
- How the agent should behave
- What it's allowed to do
- When to ask for permission

**Knowledge Modules** (`.claude/context/`):
- `architecture.md` - How the project is organized
- `security-standards.md` - Security best practices
- `testing-patterns.md` - How to write tests

**Commands** (`.claude/commands/`):
- Shortcuts for common tasks
- Custom workflows

**What Just Happened?**
Instead of you explaining the project every time, the agent reads these files to learn the rules.

### Example: Security Check

When the agent writes code involving user input, it references `security-standards.md`:

```markdown
Agent: "I see this code accepts user input. According to
security-standards.md, I should validate and sanitize it.
Adding input validation..."
```

**What Just Happened?**
The agent automatically applies security best practices because it's configured to check `security-standards.md`.

## Using Custom Commands

### What are Commands?

Commands are shortcuts that trigger specific agent behaviors.

**Example Command**: `/deployment-check`

**What It Does**: Checks if your deployment configuration is production-ready.

**How to Use**:
```
/deployment-check
```

**Agent Response**:
```markdown
## Deployment Configuration Review

Checking environment variables... ✅
- No secrets in code
- All required vars documented

Checking container config... ⚠️
- Health checks configured
- Resource limits MISSING

Recommendation:
Add resource limits to deployment.yaml:
```yaml
resources:
  limits:
    memory: "512Mi"
    cpu: "1"
```

Would you like me to add these?
```

**What Just Happened?**
The command triggered a checklist the agent follows automatically. It's like having a senior developer review your deployment config.

### Creating Your Own Commands

Create `.claude/commands/my-command.md`:

```markdown
# /my-command

Description of what this command does.

## Steps

1. First thing to check
2. Second thing to check
3. What to output

## Response Template

Format the response like this...
```

**What Just Happened?**
You created a reusable workflow the agent can follow every time someone types `/my-command`.

## Agent Review Process

The agent can also review pull requests created by humans.

**How to Request**:
Comment on a PR:
```
@codebase-agent review this PR
```

**What the Agent Checks**:

1. **Style Compliance**
   - Follows STYLE_GUIDE.md?
   - ZeroMQ-style writing (no fluff)?
   - Both doc versions exist?

2. **Technical Accuracy**
   - Code examples work?
   - Commands are correct?
   - Configurations are valid?

3. **Security**
   - No hardcoded secrets?
   - Input validation present?
   - Following security-standards.md?

4. **Project Standards**
   - No Red Hat branding?
   - No "Amber" terminology?
   - Buffet approach maintained?

**Sample Review**:
```markdown
## Code Review

### Style ✅
- Both standard and Terry versions created
- ZeroMQ-style maintained
- No AI slop detected

### Technical ✅
- Commands tested and work
- Examples are realistic

### Suggestions
1. Add troubleshooting section to Terry version
2. Consider adding diagram for complex workflow

Overall: Excellent work! Approved with minor suggestions.
```

**What Just Happened?**
The agent did a thorough review checking all project standards, just like a senior developer would.

## When the Agent Asks Permission

The agent is programmed with different levels of autonomy:

### Go Ahead (No Permission Needed)
- Fixing typos
- Formatting code
- Adding comments
- Running validation scripts

**Example**:
```
Agent: "Found typo in README.md, fixing automatically."
```

### Ask First (Needs Approval)
- Implementing new features
- Changing code structure
- Modifying configuration
- Creating pull requests

**Example**:
```
Agent: "I can implement this feature. Here's my plan:
[detailed plan]

Approve to proceed?"
```

### Detailed Review Required
- Security-related changes
- Breaking changes
- Major architecture decisions
- Production deployments

**Example**:
```
Agent: "This change affects authentication (security-sensitive).
I need detailed review before proceeding.

Proposed changes:
[very detailed explanation]

Please review carefully before approving."
```

**What Just Happened?**
The agent knows when something is risky and asks for more careful review. This keeps you in control.

## Best Practices

### Writing Good Issues for the Agent

**Good** (specific and clear):
```markdown
Title: Add health check endpoint

Requirements:
- Endpoint at /health
- Returns 200 when healthy
- Returns 503 when database unreachable
- Includes tests

Acceptance:
- curl http://localhost/health returns 200
- Tests pass
- Documentation updated
```

**Bad** (vague):
```markdown
Title: Fix health

We need health checks. Make it work.
```

**Why It Matters**:
Clear issues get better results. The agent works best with specific requirements.

### Communicating with the Agent

**Be Specific**:
```
@codebase-agent implement this following the buffet approach pattern from architecture.md
```

**Provide Context**:
```
@codebase-agent review for security, focusing on input validation
```

**Ask Questions**:
```
@codebase-agent what's the best way to structure this following our architecture patterns?
```

## Common Questions

**Q: Will the agent replace developers?**
**A**: No. The agent is a tool that handles repetitive tasks and provides a second opinion. Developers still make decisions, review code, and own the architecture.

**Q: What if the agent makes a mistake?**
**A**: Everything goes through pull requests and code review. Humans always have final approval before code is merged.

**Q: Can I trust the agent's suggestions?**
**A**: The agent follows configured rules and best practices, but you should always review its work. Think of it as a knowledgeable colleague, not an oracle.

**Q: How does the agent learn about my project?**
**A**: By reading the configuration files in `.claude/`. Keep those files updated with your project's patterns and standards.

**Q: Can the agent access production systems?**
**A**: No. It can read code and create pull requests, but cannot directly access databases, servers, or production environments.

## Troubleshooting

**Problem**: Agent doesn't understand the issue
**Solution**: Make the issue more specific. Include:
- What you want (requirements)
- Why you want it (context)
- How you'll know it's done (acceptance criteria)

**Problem**: Agent creates code that doesn't match project style
**Solution**: Update `.claude/` configuration files with examples of the correct style. The agent learns from these files.

**Problem**: Agent asks too many questions
**Solution**: Be more specific in your initial request. Include all necessary details upfront.

**Problem**: Agent suggestions don't seem relevant
**Solution**: Check if `.claude/context/` files are up to date with current project patterns.

## Learn More

- [Agent Configuration](../.claude/agents/codebase-agent.md) - How the agent is set up
- [Context Modules](../.claude/context/) - What the agent knows
- [Claude Code Docs](https://claude.ai/code) - Official documentation

---

**Next**: You now understand how to work with the Codebase Agent! Try creating an issue and asking the agent to implement it.
