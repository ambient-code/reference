# Agent Workflow

Codebase Agent (CBA) capabilities and workflows for AI-assisted development.

## Overview

The Codebase Agent is an AI assistant configured to help with development workflows. Configuration is in `.claude/` directory.

**Capabilities**:
- Issue-to-PR automation
- Code review
- Documentation generation
- Pattern application

## Configuration

### Agent Personality

**File**: `.claude/agents/codebase-agent.md`

Defines:
- Agent name and role
- Core capabilities
- Operating principles (safety first, high signal/low noise)
- Autonomy levels (when to ask permission)

### Context Modules

**Location**: `.claude/context/`

Modular knowledge files:
- `architecture.md` - System design patterns
- `security-standards.md` - OWASP top 10, input validation
- `testing-patterns.md` - Arrange-Act-Assert, mocking, coverage goals

**Pattern**: Each module is standalone (buffet approach).

### Commands

**Location**: `.claude/commands/`

Slash commands for common tasks:
- `/quickstart` - Rapid setup instructions
- Custom commands for project-specific workflows

## Issue-to-PR Workflow

### 1. Create GitHub Issue

```markdown
Title: Add deployment documentation

Description:
Create dual documentation (standard + Terry) for containerized deployment.

Include:
- Podman build patterns
- Kubernetes deployment examples
- Environment variable management
- Health check configuration

Acceptance criteria:
- Both docs/deployment.md and docs/deployment-terry.md exist
- Comparison page updated
- check-doc-pairs.sh passes
```

### 2. Trigger Agent

**Via Label**:
Add label `cba:implement` to issue

**Via Comment**:
```
@codebase-agent please implement this issue
```

### 3. Agent Analysis

Agent:
1. Reads issue description
2. Reviews context modules (architecture, security, testing)
3. Identifies affected files
4. Creates implementation plan

**Plan Output**:
```markdown
## Implementation Plan

Files to create:
- docs/deployment.md (standard version)
- docs/deployment-terry.md (accessible version)
- Update docs/comparison/index.html navigation

Approach:
1. Research Podman/K8s best practices
2. Write standard version following STYLE_GUIDE.md
3. Create Terry version with "What Just Happened?" sections
4. Validate with check-doc-pairs.sh
5. Test comparison page loads both versions

Risks:
- None identified

Estimated complexity: Medium
```

### 4. Human Approval

Developer reviews plan and responds:
- ✅ "Approved, proceed"
- ❌ "Changes needed: also cover Docker Compose"

### 5. Agent Implementation

Agent:
1. Creates feature branch
2. Implements changes
3. Runs validation scripts
4. Creates commit following conventional commit format
5. Pushes branch
6. Creates pull request

**PR Description**:
```markdown
## Summary
Implements #123: Add deployment documentation

## Changes
- Created docs/deployment.md with Podman/K8s patterns
- Created docs/deployment-terry.md with accessible explanations
- Updated comparison page navigation

## Testing
- ✅ check-doc-pairs.sh passes
- ✅ markdownlint passes
- ✅ comparison page displays both versions

## Checklist
- [x] Dual documentation created
- [x] Follows STYLE_GUIDE.md
- [x] No Red Hat branding
- [x] No "Amber" terminology
```

### 6. Code Review

Agent can also review PRs:

**Trigger**:
```
@codebase-agent review this PR
```

**Review Output**:
```markdown
## Code Review

### Documentation Quality
✅ Both standard and Terry versions created
✅ Follows ZeroMQ-style (succinct, actionable)
✅ Terry version has "What Just Happened?" sections
⚠️ Consider adding troubleshooting section to Terry version

### Technical Accuracy
✅ Podman commands correct
✅ Kubernetes YAML valid
✅ Environment variable patterns secure

### Style Compliance
✅ No AI slop detected
✅ No Red Hat branding
✅ No "Amber" terminology

## Suggestions
1. Add troubleshooting section for common Podman errors
2. Consider adding diagram for K8s deployment architecture

## Approval
Approved with minor suggestions. Excellent work!
```

## Agent Context Usage

### Architecture Context

Agent references `architecture.md` when:
- Designing new features
- Reviewing code structure
- Validating pattern consistency

**Example**:
```
Agent: "Based on architecture.md buffet approach pattern,
I'll ensure this new documentation module is independently usable."
```

### Security Context

Agent references `security-standards.md` when:
- Reviewing code for vulnerabilities
- Validating input handling
- Checking secret management

**Example**:
```
Agent: "Per security-standards.md, environment variables should be
used for secrets. I'll update the documentation to reflect this."
```

### Testing Context

Agent references `testing-patterns.md` when:
- Writing tests
- Reviewing test coverage
- Suggesting test improvements

**Example**:
```
Agent: "Following testing-patterns.md Arrange-Act-Assert pattern,
I'll structure the tests with clear separation."
```

## Custom Commands

### Creating a Command

**File**: `.claude/commands/deployment-check.md`

```markdown
# /deployment-check command

Verify deployment configuration is production-ready.

## Checklist

1. Environment variables:
   - [ ] No secrets in code
   - [ ] All required vars documented
   - [ ] Default values reasonable

2. Container configuration:
   - [ ] Non-root user
   - [ ] Health checks defined
   - [ ] Resource limits set

3. Security:
   - [ ] Image scanning enabled
   - [ ] No exposed secrets
   - [ ] TLS configured

4. Monitoring:
   - [ ] Logging configured
   - [ ] Metrics exported
   - [ ] Alerts defined

## Response Template

Run through checklist above and report status of each item.
```

**Usage**:
```
/deployment-check
```

**Agent Response**:
```markdown
## Deployment Configuration Review

### Environment Variables ✅
- ✅ No secrets in code (using Kubernetes Secrets)
- ✅ All required vars documented in README.md
- ✅ Default values set for non-sensitive vars

### Container Configuration ⚠️
- ✅ Non-root user configured (USER appuser)
- ✅ Health checks defined (liveness + readiness)
- ⚠️ Resource limits not set in deployment.yaml

... (continues through checklist)

## Recommendations
1. Add resource limits to deployment.yaml:
   ```yaml
   resources:
     limits:
       cpu: "1"
       memory: "512Mi"
     requests:
       cpu: "100m"
       memory: "128Mi"
   ```
```

## Autonomy Levels

### High Autonomy (No Approval Needed)

- Documentation typo fixes
- Formatting corrections
- Adding comments
- Running validation scripts

### Medium Autonomy (Ask First)

- Implementing new features
- Refactoring code structure
- Changing APIs
- Modifying workflows

### Low Autonomy (Detailed Approval)

- Security-sensitive changes
- Breaking changes
- Major architectural decisions
- Production deployments

**Configuration** (in `.claude/agents/codebase-agent.md`):
```markdown
## Autonomy Levels

### Automatically Proceed
- Typo fixes
- Documentation improvements
- Test additions

### Request Approval
- Feature implementations
- Code refactoring
- Configuration changes

### Require Detailed Review
- Security changes
- Breaking changes
- Architecture modifications
```

## Best Practices

### Issue Writing

**Good Issue** (clear, actionable):
```markdown
Title: Add health check endpoint

Description:
Implement /health endpoint for Kubernetes liveness probe.

Requirements:
- Return 200 if service is healthy
- Check database connection
- Check cache connection
- Return 503 if any dependency fails

Acceptance:
- Endpoint responds at /health
- Tests cover success and failure cases
- Documentation updated
```

**Bad Issue** (vague):
```markdown
Title: Fix health checks

Description:
Health checks not working. Fix them.
```

### Agent Interaction

**Clear Communication**:
```
@codebase-agent implement this following architecture.md buffet pattern
```

**Provide Context**:
```
@codebase-agent review for security issues, pay special attention to input validation per security-standards.md
```

**Specific Requests**:
```
@codebase-agent create Terry version of this documentation with troubleshooting section
```

## Limitations

**Agent Cannot**:
- Access external systems directly
- Execute code in production
- Make git commits without review (requires approval)
- Override security constraints

**Agent Can**:
- Read all repository files
- Create/modify files locally
- Run validation scripts
- Suggest changes
- Create PRs (with approval)

## References

- [.claude/agents/codebase-agent.md](../.claude/agents/codebase-agent.md)
- [.claude/context/](../.claude/context/)
- [Claude Code Documentation](https://claude.ai/code)
