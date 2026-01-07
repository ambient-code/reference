# Codebase Agent (CBA)

**Single source of truth for AI behavior in your codebase.**

---

## Quick Start

Create `.claude/agents/codebase-agent.md`:

```markdown
---
name: codebase-agent
description: Autonomous codebase operations for [your-project]
---

# Codebase Agent

## Quality Gates (run before presenting code)
1. Lint: `npm run lint`
2. Test: `npm test`
3. Fix failures before showing code

## Safety Rules
- NEVER commit directly to main
- ALWAYS create feature branches
- ASK before breaking changes
```

---

## Agent Structure

| Section | Purpose | Example |
|---------|---------|---------|
| **Capability Boundaries** | What agent can do autonomously | Formatting: auto. Architecture: human approval |
| **Workflow Definitions** | Step-by-step processes | Issue→PR, code review steps |
| **Quality Gates** | Tools to run, in order | `black . && isort . && pytest` |
| **Safety Guardrails** | When to stop and ask | >10 files changed, security code, DB schema |

---

## Autonomy Levels

| Level | Behavior | Use When |
|-------|----------|----------|
| **1: Conservative** | Create PRs only, wait for human approval | Starting out, high-risk projects |
| **2: Moderate** | Auto-merge docs/deps/lint fixes after CI passes | Established trust, good test coverage |
| **3: Aggressive** | Auto-deploy after tests pass | Mature codebase, comprehensive CI |

Start at Level 1. Graduate as you build trust.

---

## Memory System

Context files in `.claude/context/` provide persistent knowledge:

```text
.claude/
├── agents/
│   └── codebase-agent.md
└── context/
    ├── architecture.md      # Code structure patterns
    ├── security-standards.md
    └── testing-patterns.md
```

Reference in your agent: "Load `.claude/context/architecture.md` for code placement decisions."

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Agent ignores boundaries | Make rules explicit: "NEVER delete files without asking" |
| Agent too conservative | Define allowed autonomous actions explicitly |
| Agent invents conventions | Provide code examples in context files |

---

## Related Patterns

- [Self-Review Reflection](self-review-reflection.md)
- [Autonomous Quality Enforcement](autonomous-quality-enforcement.md)
