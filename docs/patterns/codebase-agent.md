# Codebase Agent (CBA)

**Single source of truth for AI behavior in your codebase.**

---

## Overview

!!! note "Section Summary"
    What a CBA is: a markdown file that defines how AI works in your project. Problem it solves: inconsistent AI behavior across developers. Key benefit: every AI interaction follows the same process.

---

## Quick Start

!!! note "Section Summary"
    Copy-paste the CBA definition from `.claude/agents/codebase-agent.md`. Minimal customization: your linting commands, your test commands. Done in 15 minutes.

---

## Agent Definition Structure

### Capability Boundaries

!!! note "Section Summary"
    What the agent can do autonomously vs what requires human approval. Examples: formatting changes (auto), architecture changes (human approval). How to define your own boundaries.

### Workflow Definitions

!!! note "Section Summary"
    Step-by-step processes for common tasks: issue-to-PR, code review, refactoring. Template workflows provided. How to customize for your process.

### Quality Gates

!!! note "Section Summary"
    Linting, testing, and review requirements. Which tools to run, in what order. What constitutes a passing gate. Error handling.

### Safety Guardrails

!!! note "Section Summary"
    When to stop and ask for human input. Risk categories: low/medium/high. Examples of each. How to configure alert thresholds.

---

## Autonomy Levels

!!! note "Section Summary"
    Level 1 (Conservative): PR creation only, wait for human approval. Level 2 (Moderate): Auto-merge for low-risk changes. Level 3 (Aggressive): Auto-deploy after tests pass. How to graduate between levels.

---

## Memory System Integration

!!! note "Section Summary"
    How CBA uses context files from `.claude/context/`. Loading context on-demand. When to reference which context file.

---

## Real-World Examples

!!! note "Section Summary"
    CBA configurations for different stacks: Python/FastAPI, TypeScript/Express, Go. What's different, what's the same.

---

## Troubleshooting

!!! note "Section Summary"
    Common issues: agent ignores boundaries, agent is too conservative, agent makes up conventions. Solutions for each.

---

## Related Patterns

- [Self-Review Reflection](self-review-reflection.md) - Add quality gates to CBA output
- [Memory System](../getting-started/first-cba.md) - Persistent context across sessions
