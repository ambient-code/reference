---
name: spec-kit-auto
description: Use when the user provides a complete spec, requirements document, or feature description and wants fully autonomous end-to-end implementation without interactive brainstorming - covers specify, plan, implement, simplify, lint, security review, and branch finishing
---

# Spec-Kit Auto

Autonomous end-to-end orchestrator for the superpowers workflow chain. Takes complete input, runs specify through implement through quality gates, with no human interaction between phases.

**Core principle:** The user's input is the spec. Enrich it, plan it, build it, verify it. Only stop for blocking ambiguity.

**This is a rigid skill. Follow it exactly.**

**Commit after each phase completes.**

## When to Use

- User provides a complete spec, requirements, or feature description
- User provides reference documents and expects autonomous execution
- Not for exploratory brainstorming or vague requirements — use `superpowers:brainstorming` instead

## The Pipeline

Specify → Plan → Implement → Simplify → Lint & Security → Finish

## Ambiguity Resolution

Applies to all phases. Resolve by: (1) checking project docs — CLAUDE.md, memory, architecture files, existing patterns; (2) following existing codebase conventions; (3) choosing the simpler option (YAGNI); (4) documenting the decision in the spec or plan.

**Only escalate to the user when** two valid interpretations would produce fundamentally different architectures, the decision requires domain knowledge absent from all available documents, or getting it wrong would require a full rewrite.

## Phase 1: Specify

**Goal:** Transform user input into a formal spec document.

The user's input IS the spec. Do not brainstorm. Do not ask clarifying questions unless the ambiguity is blocking (would be wrong >50% of the time if guessed).

1. Read the user's input and any referenced documents
2. Load project context: CLAUDE.md, architecture docs, memory files, existing code patterns
3. Enrich the input into a structured spec document:
   - **Goal** (1 sentence)
   - **Architecture** (how it fits into the existing codebase)
   - **Components** (what gets built, with boundaries)
   - **Data flow** (inputs, outputs, interfaces)
   - **Error handling** (failure modes and recovery)
   - **Testing strategy** (what to test, how)
4. Write to `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`
5. Self-review: placeholder scan, internal consistency, scope check, ambiguity check (pick one interpretation, make it explicit)

## Phase 2: Plan

**REQUIRED SUB-SKILL:** Use `superpowers:writing-plans`

1. Invoke writing-plans against the spec from Phase 1
2. Plan is written with bite-sized TDD tasks, exact file paths, complete code
3. Plan self-review runs automatically (spec coverage, placeholder scan, type consistency)
4. Save to `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`

## Phase 3: Implement

**REQUIRED SUB-SKILL:** Use `superpowers:using-git-worktrees` for workspace isolation
**REQUIRED SUB-SKILL:** Use `superpowers:subagent-driven-development`

1. Set up isolated worktree
2. Execute the plan via subagent-driven development:
   - Fresh subagent per task
   - Two-stage review after each task (spec compliance, then code quality)
   - TDD discipline enforced per `superpowers:test-driven-development`
3. All tasks complete with passing reviews

**Fallback:** If subagent support is unavailable, use `superpowers:executing-plans`.

## Phase 4: Simplify

**REQUIRED SKILL:** Use `simplify`

1. Run `simplify` against all changed files
2. Three parallel review agents check code reuse, code quality, and efficiency
3. Fix all valid findings

## Phase 5: Lint and Security

Run linting, security scanning, and code review. Three parallel tracks:

### Track A: Auto-Detect and Run Local Linters

Detect project linters from config files and run them:

| Config File | Linter | Command |
|-------------|--------|---------|
| `pyproject.toml` / `ruff.toml` | ruff | `ruff check --fix .` |
| `pyproject.toml` [tool.black] | black | `black .` |
| `.eslintrc*` / `eslint.config.*` | eslint | `npx eslint --fix .` |
| `Cargo.toml` | clippy + rustfmt | `cargo clippy && cargo fmt` |
| `.golangci.yml` | golangci-lint | `golangci-lint run` |
| `Makefile` | checkmake | `checkmake Makefile` |
| `Dockerfile*` | hadolint | `hadolint Dockerfile` |
| `.github/workflows/*.yml` | actionlint | `actionlint` |
| `*.sh` | shellcheck | `shellcheck *.sh` |
| `docs/**/*.md` | markdownlint | `markdownlint docs/**/*.md --fix` |

Run all detected linters. Fix auto-fixable issues. Report unfixable issues.

### Track B: CodeRabbit CLI Review

Run the CodeRabbit CLI for code review aligned with team standards.

**Auth check:** Before running, verify authentication:

```bash
command -v coderabbit >/dev/null 2>&1 || { echo "coderabbit CLI not installed, skipping Track B"; }
coderabbit auth status 2>&1 | grep -q "Logged in" || { echo "Not authenticated. Run: coderabbit auth login"; }
```

Note: `coderabbit auth status` emits ANSI codes and spinners, so `2>&1` is required. If not authenticated, skip this track and note it in the final report.

**Team review standards** (from `.coderabbit.yaml`):

- Flag only errors, security risks, or functionality-breaking problems
- Limit to 3-5 comments max; group similar issues
- No style, formatting, or refactoring suggestions
- Performance: flag O(n^2)+, N+1 patterns, unbounded growth, missing pagination
- Security: flag hardcoded secrets, missing auth, injection vulnerabilities, leaked sensitive data

Fix all actionable findings. Skip false positives with a note.

### Track C: Inline Security Review

Dispatch a general-purpose subagent to review all changed files (`git diff main...HEAD`). The subagent should also reference the project's `security-standards.md` context file if one exists. Review for:

1. **Secrets/credentials** — hardcoded tokens, API keys, passwords in source or logs
2. **Injection** — SQL, command, path traversal, XSS in any user-controlled input
3. **Auth/authz** — missing authentication or authorization checks on endpoints
4. **Data exposure** — sensitive data in API responses, logs, error messages
5. **Dependency risk** — known-vulnerable packages, unpinned versions
6. **Resource safety** — unbounded allocations, missing timeouts, missing cleanup

For each finding: file, line(s), severity (critical/high/medium), specific risk, fix. Fix all critical and high findings. Document medium findings for review.

### Ensure CI Linting

Check if a lint workflow using `wearerequired/lint-action@v2` exists in `.github/workflows/`. If missing, create `.github/workflows/lint.yml` with checkout, language-appropriate linter installation (use `uv pip install` for Python), and `auto_fix: false`. Adapt to match detected project languages. Check for existing lint workflows first to avoid duplication.

## Phase 6: Finish

**REQUIRED SUB-SKILL:** Use `superpowers:verification-before-completion`
**REQUIRED SUB-SKILL:** Use `superpowers:finishing-a-development-branch`

1. Run verification-before-completion: execute test suite, confirm all pass with evidence
2. Run finishing-a-development-branch: present integration options, execute choice

## Rationalizations to Reject

| Excuse | Reality |
|--------|---------|
| "Input is unclear, need to ask" | Enrich from project context. Only ask if blocking. |
| "Simplify found nothing" | Run it anyway. Evidence before claims. |
| "Security review is overkill for this change" | Every change gets reviewed. No exceptions. |
| "Linter not installed, skip it" | Note it in the report. Don't silently skip. |
| "Tests pass, skip verification" | Verification means running them NOW and showing output. |
| "CodeRabbit isn't authenticated" | Skip with a note. Run the other two tracks. |
| "This is too simple for the full pipeline" | Simple changes are where skipped steps cause the most damage. |
| "Code looks clean enough, skip simplify" | Run it. Let the agents decide. |
| "I'll reorder phases for efficiency" | Follow the pipeline exactly. No reordering. |
| "Design contradicts CLAUDE.md but seems better" | CLAUDE.md wins. Always. |

## Integration

**Skills invoked (in order):**

| Phase | Skill | Purpose |
|-------|-------|---------|
| 2 | `superpowers:writing-plans` | Create implementation plan |
| 3 | `superpowers:using-git-worktrees` | Workspace isolation |
| 3 | `superpowers:subagent-driven-development` | Execute plan with subagents |
| 3 | `superpowers:test-driven-development` | Implementation discipline |
| 4 | `simplify` | Code quality review |
| 6 | `superpowers:verification-before-completion` | Evidence before claims |
| 6 | `superpowers:finishing-a-development-branch` | Branch integration |

**Fallback:** `superpowers:executing-plans` if subagent support unavailable
