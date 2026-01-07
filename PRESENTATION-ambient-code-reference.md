# AI-assisted Development Reference Repository

## A Practical Guide for Engineers Evaluating AI-Assisted Development

---

## The Problem We're Solving

Engineers face a difficult question: "My team wants to use Claude/AI coding assistants. How do we do this without creating chaos?"

Current approaches often fail:

- **Ad-hoc adoption**: Every engineer uses AI differently, inconsistent results
- **Heavy-handed policies**: Ban it or over-regulate, lose competitive advantage
- **Vendor lock-in fears**: What if we invest in patterns that don't transfer?

This reference repository provides useful patterns you can review / adopt incrementally:

- Patterns extracted from production use
- Copy-paste ready configurations
- Reference documentation for teams to adapt

---

## Feature 1: Codebase Agent (CBA)

### What Is It?

A pre-configured AI agent definition that knows how to work with your codebase safely and consistently.
The idea behind a CBA is to use an agent to eventually proxy 100% of the interaction with a codebase through this agent.

(cba = codebase system prompt)

### The Problem It Solves

Without guidance, AI assistants:

- Don't behave like a co-worker
- Make inconsistent style choices
- Don't know your testing conventions
- Miss security requirements
- Create PRs that fail CI

### How CBA Works

The agent definition lives in `.claude/agents/codebase-agent.md` and includes:

1. **Capability boundaries** - What the agent can and cannot do autonomously
2. **Workflow definitions** - Step-by-step processes for common tasks
3. **Quality gates** - Linting, testing, and review requirements
4. **Safety guardrails** - When to stop and ask for human input

### CBA Workflow Example

When CBA receives an issue to fix (e.g. a github comment "@cba fix this":

1. Read issue description and acceptance criteria
2. Review relevant code in context files
3. Create implementation plan
4. Show plan to user for approval
5. Implement changes following project standards
6. Run any other pre-flight checks, such as linters
7. Run tests (pytest)
8. Create commit with clear message
9. Push and create PR with detailed description

### Autonomy Levels

**Level 1 (Default)**: Create PR, wait for human approval
**Level 2 (Optional)**: Auto-merge low-risk changes (docs, deps, linting)

Most teams start at Level 1 and graduate to Level 2 after building trust.

### Why This Matters

- **Consistency**: Every AI-assisted change follows the same process
- **Auditability**: Clear trail of what the agent did and why
- **Safety**: Human review gates prevent runaway automation
- **Scalability**: Junior engineers get senior-level AI assistance with guardrails

---

## Feature 2: Memory System (Modular Context)

### Memory System Overview

A structured way to give AI assistants project-specific knowledge without overwhelming context windows.

### The Context Window Problem

AI assistants have limited context. If you dump your entire codebase into the prompt, you get:

- Slow responses
- High token costs
- Confused outputs (too much irrelevant info)

### How The Memory System Works

Context is organized into focused modules in `.claude/context/`:

**architecture.md** - Layered architecture patterns, component responsibilities, data flow
**security-standards.md** - Input validation, sanitization, secrets management
**testing-patterns.md** - Unit, integration, E2E test structures and conventions

Codebase owners generate these files programmatically. Things like ADRs or hand-tuned context could be used here.
What's important is that your team has collected and agrees upon the context since the idea is it will be shared.

### Loading Context On-Demand

Instead of loading everything, you load what's relevant.

"Load the security-standards context and help me review this authentication PR"

"Load the architecture context and help me add a new endpoint"

For relation between elements, load these files into e.g. the local Anthropic Memory MCP server

"load .claude/context into my local mcp server and add this instruction to claude.md"

### Memory System Benefits

- **Token efficiency**: Only load relevant context
- **Maintainability**: Update one context file, all sessions benefit
- **Knowledge capture**: Document tribal knowledge in machine-readable format
- **Onboarding**: New engineers (and AI) get up to speed faster

---

## Feature 3: Issue-to-PR Automation

### Issue-to-PR Overview

A pattern where well-defined GitHub issues can be automatically converted into pull requests by the CBA.
Example: <https://github.com/ambient-code/agentready/pull/242>

### Routine Fix Overhead

Routine fixes (linting, formatting, simple bugs) take disproportionate time:

- Context switch to fix
- Remember to run linters
- Write commit message
- Create PR
- Wait for CI

For a 2-minute fix, the overhead is 10+ minutes.

### How It Works

1. Create issue with clear requirements:

   ```markdown
   ## Problem
   ESLint violation in src/utils/format.js
   
   ## Files
   File: src/utils/format.js
   
   ## Instructions
   Fix the unused variable warning on line 45
   
   ## Success Criteria
   - ESLint passes
   - Tests pass
   ```

2. Add label: `cba:auto-fix` or tag @cba on a comment (not the initial comment - github app restriction)

3. CBA picks up the issue, self-review and reflection occurs, then creates a PR

4. Human reviews and merges

### Risk Categories

**Low Risk (auto-fix eligible)**:

- Code formatting
- Linting violations
- Unused import removal
- Documentation formatting

**Medium Risk (PR only, requires review)**:

- Refactoring
- Test coverage additions
- Minor feature changes

**High Risk (report only)**:

- Breaking changes
- Security-sensitive code
- Architecture changes

### Issue-to-PR Benefits

- **Automation** for routine tasks helps engineers scale
- **Democratized automation**: Team members without Claude access can trigger fixes
- **Consistent quality**: Every auto-fix follows the same process with self-review and reflection.
- **Audit trail**: Every change is tracked via GitHub

**Note**: Issue-to-PR is one of four GHA automation patterns. See Feature 9 for the complete set including PR Auto-Review, Dependabot Auto-Merge, and Stale Issue Management.

---

## Feature 4: Layered Architecture Patterns

### Architecture Patterns Overview

Reference implementations for organizing code in a way that AI assistants can reason about effectively.

See [AgentReady](https://github.com/ambient-code/agentready) for tooling to check and validate your codebase's readiness for agentic development.

### The Spaghetti Code Problem

AI assistants struggle with:

- Spaghetti code (no clear structure)
- Mixed concerns (business logic in HTTP handlers)
- Implicit dependencies (global state everywhere)

### The Four-Layer Pattern - used in the [FastAPI]([https://github.com/jeremyeder/fastapi-demo](https://github.com/jeremyeder/demo-fastapi) example

**API Layer** (app/api/)

- FastAPI route handlers
- Request/response models
- HTTP status codes
- OpenAPI documentation

**Service Layer** (app/services/)

- Business logic
- CRUD operations
- No HTTP concerns

**Model Layer** (app/models/)

- Pydantic models
- Field validation
- Sanitization

**Core Layer** (app/core/)

- Configuration
- Security utilities
- Logging

### Dependency Rule

Higher layers depend on lower layers, never the reverse:
API -> Service -> Model -> Core

### Architecture Benefits

- **Predictable AI outputs**: When structure is clear, AI makes better decisions
- **Easier testing**: Each layer is testable in isolation
- **Safer refactoring**: Changes are localized to appropriate layers
- **Transferable skills**: Pattern works for any language/framework

---

## Feature 5: Security Patterns (Light Touch - not comprehensive)

### Security Patterns Overview

Practical security patterns that prevent common vulnerabilities without over-engineering.

### The Philosophy

"Validate at boundaries, trust internal code"

Most security bugs come from:

1. Unvalidated user input
2. Hardcoded secrets
3. SQL/command injection

### Key Patterns

**Input Validation**:

- Pydantic models validate all request payloads
- Sanitization happens in model validators
- Internal code trusts validated data

**Sanitization Functions**:

- `sanitize_string()` - Remove control characters, trim whitespace
- `validate_slug()` - Ensure URL-safe identifiers

**Secrets Management**:

- Environment variables only
- `.env` files never committed
- Pydantic Settings for config

### What We DON'T Do

- No security theater (excessive validation everywhere)
- No complex encryption for non-sensitive data
- No authentication framework in the reference (separate concern)

### Security Benefits

- **Practical security**: Focus on actual attack vectors
- **Maintainable**: Simple patterns are followed consistently
- **AI-friendly**: Clear rules the agent can follow

---

## Feature 6: Testing Patterns

### Testing Patterns Overview

A test pyramid approach with clear responsibilities for each level.

### The Three Levels

**Unit Tests** (Many, Fast)

- Test service layer in isolation
- Mock external dependencies
- Arrange-Act-Assert pattern
- Location: `tests/unit/`

**Integration Tests** (Some, Medium)

- Test API endpoints with TestClient
- Real request/response cycle
- Database fixtures if applicable
- Location: `tests/integration/`

**E2E Tests** (Few, Slow)

- Test complete workflows
- CBA automation scenarios (outline only)
- Location: `tests/e2e/`

### Coverage Philosophy

- Target 80%+ coverage
- Focus on critical paths
- Don't chase 100% (diminishing returns)

### Testing Benefits

- **Fast feedback**: Unit tests run in seconds
- **Confidence**: Integration tests catch API contract issues
- **Regression prevention**: E2E tests verify key workflows
- **AI-compatible**: Clear test structure helps AI write tests correctly

---

## Feature 7: CI/CD for Documentation

### Documentation CI Overview

GitHub Actions workflows that validate documentation quality automatically. Not an AI specific capability - but it leverages AI now.

### Why Documentation CI?

Documentation is code. Bad docs:

- Confuse users
- Increase support burden
- Become stale quickly

### Validation Workflows

**Markdown Linting**:

- Consistent formatting
- No broken syntax
- Clear structure

**Mermaid Diagram Validation**:

- Diagrams must render correctly
- No syntax errors in flowcharts/sequences
- CI blocks merge if diagrams are broken

**Link Checking**:

- No broken internal links
- No dead external references

### Documentation CI Benefits

- **Docs stay current**: CI catches drift
- **Quality floor**: No more "works on my machine" diagrams
- **Automated enforcement**: Humans don't have to review formatting

---

## Feature 8: Self-Review Reflection

### Self-Review Overview

A pattern where AI agents review their own work before presenting it to humans.

### The Sloppy First Draft Problem

Without self-review, AI assistants often present work with obvious issues:

- Missing edge cases
- Security gaps (no input validation)
- Incomplete error handling
- Assumptions that should be stated

Users waste time catching problems the agent should have caught itself.

### How Self-Review Works

Before presenting any significant work, the agent:

1. Re-reads output as if it were a code reviewer
2. Checks against specific criteria (security, edge cases, completeness)
3. Fixes any issues found
4. Only then presents the polished result to the user

### The Reflection Loop

Agent Does Work → Self-Review Check → Issues Found?
→ Yes: Fix Issues, Re-check
→ No: Present to User

### What Gets Checked

**For code-related work**:

- Edge cases handled?
- Input validation present?
- Error handling complete?
- Security issues (OWASP Top 10)?
- Tests cover the changes?

**For analysis/planning work**:

- Reasoning complete?
- Assumptions stated?
- Alternatives considered?
- Risks identified?

### Implementation Example

Add this to any agent prompt:

```markdown
## Self-Review Protocol

Before presenting your work:

1. Re-read your output as if you're a code reviewer
2. Check for:
   - Missing edge cases
   - Security issues (injection, validation, secrets)
   - Incomplete reasoning
   - Assumptions that should be stated
3. Fix any issues found
4. Only then present to user

If you found and fixed issues, briefly note: "Self-review: Fixed [issue]"
```

### When to Use Self-Review

| Situation | Self-Review? | Why |
|-----------|--------------|-----|
| Code generation | ✅ Yes | Catches bugs before user sees them |
| Issue analysis | ✅ Yes | Ensures thorough reasoning |
| PR creation | ✅ Yes | Polishes before human review |
| Simple lookups | ❌ No | Overhead not worth it |
| Exploratory chat | ❌ No | Low stakes, fast iteration preferred |

**Note**: Self-review has a monetary cost associated with it. Use your judgement. This is a common pattern though.

### Self-Review Benefits

- **Higher quality first attempts**: Users rarely say "you missed X"
- **Reduced iteration cycles**: First submission is usually accepted
- **Visible quality process**: Agent notes what it caught
- **Scalable quality**: Works the same whether junior or senior uses it

---

## Feature 9: Proactive GHA Workflows

### GHA Automation Overview

GitHub Actions workflows that proactively handle routine development tasks without human intervention.

### The Manual Toil Problem

Development teams spend significant time on repetitive tasks:

- Reviewing every PR manually (even trivial ones)
- Converting issues to PRs by hand
- Remembering to merge dependency updates
- Cleaning up stale issues

These tasks are necessary but don't require human judgment for every instance.

### Four Automation Patterns

#### Issue-to-PR Automation

When a well-defined issue is created:

- AI analyzes if requirements are clear
- If actionable, creates a draft PR automatically
- Links PR back to the issue
- Human reviews the draft, not the initial work

#### PR Auto-Review

When any PR is opened or updated:

- AI reviews the code automatically
- Posts structured feedback (🔴 CRITICAL, 🟡 WARNING, ✅ GOOD)
- Human reviewers see AI analysis before their own review
- Catches obvious issues before human time is spent

#### Dependabot Auto-Merge

When Dependabot creates a PR:

- Workflow checks if it's a patch version update
- If all CI passes, auto-merges with squash
- Human reviews only minor/major version bumps
- Keeps dependencies current without manual effort

#### Stale Issue Management

On a weekly schedule:

- Finds issues inactive for 30+ days
- Adds "stale" label with warning comment
- Closes after 7 more days of inactivity
- Exempt labels prevent closure (pinned, security, bug)

### Safety Conditions

Each pattern has explicit safety gates:

| Pattern | Safety Gate |
|---------|-------------|
| Issue-to-PR | Draft PR only, requires human merge |
| PR Auto-Review | Comment only, no blocking |
| Dependabot Auto-Merge | Patch versions only, CI must pass |
| Stale Issues | Exempt labels, 7-day warning period |

### GHA Workflow Benefits

- **Reduced toil**: Routine work happens automatically
- **Consistent process**: Every PR gets the same review treatment
- **Faster updates**: Dependencies stay current without overhead
- **Clean backlog**: Stale issues don't accumulate indefinitely
- **Human focus**: Engineers spend time on judgment-required work

### Quick Start

See `docs/patterns/gha-automation-patterns.md` for copy-paste workflow YAML files.

---

## How to Adopt (Buffet Style)

### Pick What You Need

| Pattern | Effort | Impact | Start Here If... |
|---------|--------|--------|------------------|
| CBA Agent | Medium | High | You want consistent AI assistance |
| Memory System | Low | Medium | AI keeps forgetting your conventions |
| Issue-to-PR | High | Very High | You have many routine fixes |
| Architecture | Low | Medium | Starting a new project |
| Security | Low | Medium | You handle user input |
| Testing | Medium | High | You want AI to write tests |
| CI/CD | Low | Medium | You have documentation |
| Self-Review | Low | High | AI outputs need polish before delivery |
| GHA Workflows | Medium | High | You want proactive automation |

### Adoption Path Examples

**Minimal (1 day)**:

1. Copy `.claude/` folder
2. Customize `codebase-agent.md` for your stack
3. Done - you have consistent AI assistance

**Standard (1 week)**:

1. Minimal setup
2. Add context files for your architecture
3. Set up documentation CI
4. Train team on the patterns

**Full (1 month)**:

1. Standard setup
2. Implement issue-to-PR automation
3. Add security patterns to context
4. Build test pyramid
5. Measure and iterate

---

## Common Objections and Responses

### "This is too much ceremony"

Start with just the CBA agent definition. That's one file. Add more as you feel the pain.

### "What if Claude changes / we switch tools?"

The patterns are tool-agnostic. The architecture, testing, and security patterns work with any AI assistant or none at all.

### "My team will just ignore this"

CI enforcement helps. If linting fails, merge fails. The CBA agent follows the rules even when humans forget.

### "How do I know the AI won't break production?"

Autonomy Level 1 requires human approval for every PR. The agent creates, humans merge. Graduate to Level 2 only when you have confidence.

### "We don't use Python/FastAPI"

The code examples use Python, but the patterns transfer. Layered architecture, input validation, test pyramids - these work in any language.

---

## Getting Started Today

```bash
# Clone the reference
git clone https://github.com/jeremyeder/reference.git
cd reference

# Explore the patterns
cat .claude/agents/codebase-agent.md
cat .claude/context/architecture.md
cat docs/quickstart.md

# Copy to your project
#commented out on purpose cp -r .claude /path/to/your/project/
cd /path/to/your/project/.claude/agents/
# Edit codebase-agent.md for your stack
```

### See It In Action

Working FastAPI demo: <https://github.com/jeremyeder/demo-fastapi>

---

## Summary

The Ambient Code Reference Repository provides:

1. **CBA Agent**: Consistent, safe AI assistance with clear boundaries
2. **Memory System**: Efficient context loading for project knowledge
3. **Issue-to-PR**: 10x productivity for routine tasks
4. **Architecture Patterns**: Clear structure AI can reason about
5. **Security Patterns**: Practical protection without over-engineering
6. **Testing Patterns**: Pyramid approach with clear responsibilities
7. **CI/CD**: Automated quality enforcement for documentation
8. **Self-Review Reflection**: Agent quality gate before delivery
9. **Proactive GHA Workflows**: Automated PR review, dependency merging, issue cleanup

**Start small, adopt incrementally, measure results.**

---

## Resources

- Reference Repository: <https://github.com/jeremyeder/reference>
- Working Demo: <https://github.com/jeremyeder/demo-fastapi>
- Claude Documentation: <https://docs.anthropic.com/claude/docs>
