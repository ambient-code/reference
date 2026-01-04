# Implementation Context for Ambient Code Reference Repository

**Version**: 1.0
**Date**: 2025-12-17
**Companion to**: `IMPLEMENTATION_PROMPT.md`

---

## Purpose

This file provides the contextual information needed to execute the implementation prompt effectively. Fill in the sections below before starting implementation.

---

## Reference Materials

### Available Source Files

**Codebase Agent Sources:**

- [ ] `ambient-code/platform/agents/amber.md` - Location: **NEED INPUT** (See question form)
- [ ] `ambient-code/agentready/.claude/agents/agentready-dev.md` - Location: **NEED INPUT** (See question form)
- [ ] `ambient-code/platform/agents/terry-technical_writer.md` - Location: **NEED INPUT** (See question form)

**Inventories:**

- [X] `AMBIENT_TECHNIQUES_INVENTORY.md` - Location: `/Users/jeder/repos/reference/AMBIENT_TECHNIQUES_INVENTORY.md` (exists in repo)
- [X] `FEATURES_INVENTORY.md` - Location: `/Users/jeder/repos/reference/FEATURES_INVENTORY.md` (exists in repo)

**Example Repositories:**

- [ ] Existing FastAPI service to reference: **NEED INPUT** (See question form - optional)
- [ ] Existing agent configuration to reference: **NEED INPUT** (See question form - optional)

---

## Strategic Context

### Primary Objective

Create the **Ambient Code Reference Repository** - a GitHub template demonstrating
AI-assisted development best practices for Python FastAPI services using the "standalone patterns approach"
where teams can adopt features independently without requiring full implementation.
This is pure "Ambient Code" documentation with NO Red Hat branding.

### Success Metrics

- **NEED INPUT** - See question form

### Timeline & Priorities

- **NEED INPUT** - See question form

---

## Technical Environment

### Repository Details

- **Location**: **NEED INPUT** - See question form
- **Ownership**: Ambient Code organization (assumed)
- **Visibility**: Public (template repository)

### Technology Stack Preferences

- **Python Version**: 3.11 minimum, 3.12 supported (per Jeremy's N and N-1 policy)
- **Container Runtime**: Podman (required) / Docker (acceptable fallback)
- **CI/CD Platforms**:
  - Primary: GitHub Actions
  - Secondary: GitLab CI (examples only)
  - Other: None

### Existing Patterns to Follow

- **Error Handling**: Follow FastAPI best practices (HTTPException, proper status codes)
- **Logging Format**: JSON structured logging (Python logging with json formatter)
- **Security Scanning**: Bandit + Safety (confirmed in prompt)

---

## Style & Quality References

### Documentation Examples

**Good Documentation (What to Emulate):**

- **NEED INPUT** - See question form (examples of good docs in your ecosystem)

**AI Slop (What to Avoid):**

- Characteristics: Verbose, repetitive, generic, non-specific, overly enthusiastic
- Phrases like "let's dive in", "it's important to note", "simply", "just"
- Unnecessary pleasantries and filler
- Examples: **NEED INPUT** - See question form

### Terry vs. Standard Writing

**Terry Style Characteristics:**

- Clear, accessible, jargon-free
- Explains technical concepts in plain language
- "What Just Happened?" sections after complex steps
- Troubleshooting tips included
- Assumes less prior knowledge
- Uses analogies and examples

**Standard Style Characteristics:**

- Technical depth assumed
- Concise, reference-oriented
- Code-focused with minimal explanation
- Assumes familiarity with patterns
- Jeremy's style: "Succinct, quickstart-focused"

**Example Comparison:**

- **NEED INPUT** - See question form (existing Terry vs Standard documentation pair if available)

---

## Agent Execution Preferences

### Autonomy Level

- [X] **Semi-Autonomous** - Show plan for each major section, proceed after approval
  - Rationale: Jeremy prefers proactive agents but wants visibility into major changes
  - Per Jeremy's CLAUDE.md: "Think like a seasoned strategic consultant"

### Phase Approval Points

Required approval before:

- [X] Creating repository structure (Week 1)
- [X] Implementing FastAPI application (Week 2)
- [X] Writing CBA agent definition (Week 3)
- [X] Generating Terry documentation versions (Week 4)
- [X] Creating CI/CD workflows (Week 5)
- [ ] Generating Mermaid diagrams (can proceed, but validate rigorously)
- [X] Final validation and testing (Week 6)

### Error Handling Strategy

- [X] **Fix automatically** - Attempt to resolve errors autonomously
  - Rationale: Jeremy's CLAUDE.md emphasizes "complete tasks fully", "unlimited context"
  - Exception: Stop for security issues or architectural decisions

---

## Integration Points

### Existing CLAUDE.md Configurations

- **Global CLAUDE.md**: `/Users/jeder/.claude/CLAUDE.md` (Jeremy's personal config)
- **Project CLAUDE.md**: `/Users/jeder/CLAUDE.md` (Jeremy's project config)
- **New Project CLAUDE.md**: Will be created by this implementation (~400 lines)
- **Conflicts to Avoid**: None anticipated - this is a new standalone repository

### Observability & Monitoring

- **Current Platform**: None
- **Requirements**: **Research only** (per prompt - document in `docs/observability-research.md`)
- **Explicitly state**: "This is RESEARCH ONLY, not implemented in the reference repository"

### Existing CI/CD Configurations

- **GitHub Actions**: No org-level workflows to integrate (standalone template)
- **GitLab CI**: No shared templates - discrete implementation (not mirror)
- **Security Scanning**: Standard Bandit + Safety (no org-specific requirements)

---

## Constraints & Anti-Requirements

### Must NOT Include

- [X] Red Hat branding (confirmed in prompt)
- [X] "Amber" terminology (use "Codebase Agent" / "CBA" only)
- [X] Sequenced adoption path (standalone patterns approach only)
- [X] VictoriaMetrics (per Jeremy's CLAUDE.md)
- [X] Time estimates (per Jeremy's CLAUDE.md: "never include time estimates unless explicitly asked")
- [X] AI slop phrases ("let's dive in", "simply", "just", etc.)
- [X] Line length enforcement (per Jeremy's CLAUDE.md: "never enforce line length limits")
- [X] Actual ADR content (scaffolding/template only)
- [X] Implemented observability (research document only)
- [X] Mermaid syntax errors (must validate before commit)
- [X] Security overrotation (light touch only)

### Budget Constraints

- **Agent Execution**: No specific concerns - use appropriate models
- **CI/CD Minutes**: Standard GitHub free tier limits (2000 min/month)
- **Third-party Services**: Use free tiers (Codecov free tier, Safety free tier)

---

## Validation Expectations

### Pre-Submission Checklist

Before considering implementation complete, verify:

**Technical:**

- [ ] `./scripts/setup.sh` completes in < 10 minutes
- [ ] `uvicorn app.main:app --reload` starts successfully
- [ ] All CRUD endpoints work via curl/Postman
- [ ] `pytest` achieves 80%+ coverage
- [ ] Container builds and runs successfully

**Code Quality:**

- [ ] All linters pass (black, isort, ruff)
- [ ] All GitHub Actions workflows pass
- [ ] Security scans complete successfully
- [ ] Mermaid diagrams validate successfully

**Documentation:**

- [ ] All 8 documentation files exist (4 pairs)
- [ ] Comparison webpage displays correctly
- [ ] No AI slop detected (human review)
- [ ] Terry versions clearly more accessible than standard

**Standalone Patterns:**

- [ ] Features are independent (can adopt individually)
- [ ] No prescribed sequence of adoption
- [ ] Clear "what's included" section in README

---

## Open Questions

*These questions will be answered via the question form:*

1. **CBA Naming**: "Codebase Agent" is verbose - is "CBA" acceptable in all contexts?
2. **Mermaid Validation**: Install `mermaid-cli` globally or in dev dependencies?
3. **E2E Tests**: Should E2E test outline include mock GitHub API, or document manual testing only?
4. **Asciinema**: Required for v1.0 or optional for later enhancement?
5. **GitLab CI Detail Level**: How detailed should the discrete implementation be vs. minimal example?
6. **Repository Location**: Where should the new repository be created? (GitHub URL or local path)
7. **Timeline/Deadlines**: Are there specific deadlines or priority phases?
8. **Success Metrics**: How will we measure success of this reference repository?

---

## Implementation Notes

*Agent should update this section during implementation with key decisions:*

### Decisions Made

- [DATE] [DECISION]: [Rationale]

### Blockers Encountered

- [DATE] [BLOCKER]: [Resolution or workaround]

### Deviations from Prompt

- [DATE] [DEVIATION]: [Why necessary]

---

## End of Implementation Context

Fill in the sections above, then provide both `IMPLEMENTATION_PROMPT.md` and this context file to the implementing agent.
