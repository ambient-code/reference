# Your First Codebase Agent

**Create a CBA in 30 minutes.**

---

## Overview

!!! note "Section Summary"
    What you'll build: a `.claude/` directory with agent definition and context files customized for your project. By the end, AI will know your coding conventions.

---

## Step 1: Copy the Template

!!! note "Section Summary"
    Copy `.claude/` from reference repo to your project. Directory structure explanation. What each file does.

---

## Step 2: Customize the Agent Definition

!!! note "Section Summary"
    Edit `.claude/agents/codebase-agent.md`. Key sections to customize: capability boundaries (what can the agent do autonomously?), quality gates (your linting/testing commands), safety guardrails (when to stop and ask).

---

## Step 3: Create Context Files

### Architecture Context

!!! note "Section Summary"
    `.claude/context/architecture.md` - describe your layers, component responsibilities, data flow. Template provided. Examples for common stacks (FastAPI, Express, Django).

### Security Context

!!! note "Section Summary"
    `.claude/context/security-standards.md` - your validation rules, sanitization patterns, secrets management approach. What to validate, what to trust.

### Testing Context

!!! note "Section Summary"
    `.claude/context/testing-patterns.md` - your test pyramid, where tests live, mocking conventions, coverage targets.

---

## Step 4: Test Your CBA

!!! note "Section Summary"
    Interactive session: ask AI to perform a task in your codebase. Verify it follows conventions. Iterate on context files based on what it gets wrong.

---

## Step 5: Share with Your Team

!!! note "Section Summary"
    Commit `.claude/` to your repo. Team onboarding: everyone gets the same AI behavior. Updating context files: when and how.

---

## Memory System Deep Dive

!!! note "Section Summary"
    How modular context works. Loading context on-demand. Token efficiency. When to split vs combine context files.

---

## Troubleshooting

!!! note "Section Summary"
    Common issues: AI ignores context (file not loaded), AI makes up conventions (context too vague), AI over-engineers (context too broad). Solutions for each.

---

## Next Steps

- [Patterns Index](../patterns/index.md) - Explore all available patterns
- [Self-Review Reflection](../patterns/self-review-reflection.md) - Add quality gates to your CBA
