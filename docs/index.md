# Ambient Code Reference

AI-assisted development patterns for engineering teams.

---

## Patterns

### Agent Behavior

| Pattern | What It Does |
|---------|--------------|
| [Codebase Agent](patterns/codebase-agent.md) | Define AI behavior and guardrails |
| [Self-Review Reflection](patterns/self-review-reflection.md) | Agent reviews own work before presenting |
| [Autonomous Quality](patterns/autonomous-quality-enforcement.md) | Run linters/tests automatically |
| [Multi-Agent Review](patterns/multi-agent-code-review.md) | Parallel specialized reviews |

### GHA Automation

| Pattern | Trigger |
|---------|---------|
| [Issue-to-PR](patterns/issue-to-pr.md) | Issue labeled `cba` |
| [PR Auto-Review](patterns/pr-auto-review.md) | Pull request opened |
| [Dependabot Auto-Merge](patterns/dependabot-auto-merge.md) | Dependabot PR |
| [Stale Issues](patterns/stale-issues.md) | Weekly schedule |

### Foundation

| Pattern | What It Does |
|---------|--------------|
| [Security Patterns](patterns/security-patterns.md) | Validate at boundaries |
| [Testing Patterns](patterns/testing-patterns.md) | Unit, integration, E2E pyramid |

---

## Links

- **Quickstart**: [quickstart.md](quickstart.md)
- **Demo App**: [demo-fastapi](https://github.com/ambient-code/demo-fastapi)
- **Presentation**: [PRESENTATION-ambient-code-reference.md](https://github.com/ambient-code/reference/blob/main/PRESENTATION-ambient-code-reference.md)
