---
name: spec-kit-auto
description: Use when the user provides a complete spec, requirements document, or feature description and wants fully autonomous end-to-end implementation without interactive brainstorming - chains specify, plan, tasks, analyze, implement, then lint/security/finish
---

# Spec-Kit Auto

Autonomous end-to-end orchestrator that chains spec-kit commands. Takes complete input, runs the full pipeline, with no human interaction between phases.

**Core principle:** The user's input is the spec. Enrich it, plan it, build it, verify it. Only stop for blocking ambiguity.

**This is a rigid skill. Follow it exactly.**

**Commit after each phase completes.**

## When to Use

- User provides a complete spec, requirements, or feature description
- User provides reference documents and expects autonomous execution
- Not for exploratory brainstorming or vague requirements

## The Pipeline

Specify -> Plan -> Tasks -> Analyze -> Implement -> Lint & Security -> Finish

## Ambiguity Resolution

Applies to all phases. Resolve by: (1) checking project docs — CLAUDE.md, memory, architecture files, existing patterns; (2) following existing codebase conventions; (3) choosing the simpler option (YAGNI); (4) documenting the decision in the spec or plan.

**Only escalate to the user when** two valid interpretations would produce fundamentally different architectures, the decision requires domain knowledge absent from all available documents, or getting it wrong would require a full rewrite.

## Phase 1: Specify

Invoke the Skill tool with `skill: "speckit.specify"` and pass the user's input as `args`.

Wait for it to complete. Commit the resulting spec.

## Phase 2: Plan

Invoke the Skill tool with `skill: "speckit.plan"`.

Wait for it to complete. Commit the resulting plan and design artifacts.

## Phase 3: Tasks

Invoke the Skill tool with `skill: "speckit.tasks"`.

Wait for it to complete. Commit the resulting tasks.md.

## Phase 4: Analyze

Invoke the Skill tool with `skill: "speckit.analyze"`.

This is a quality gate. If CRITICAL issues are found, fix them before proceeding. Re-run analyze after fixes until no CRITICAL issues remain.

## Phase 5: Implement

Invoke the Skill tool with `skill: "speckit.implement"`.

Wait for it to complete. All tasks in tasks.md should be marked `[X]`.

## Phase 6: Lint and Security

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

If not authenticated or not installed, skip this track and note it in the final report.

Fix all actionable findings. Skip false positives with a note.

### Track C: Inline Security Review

Dispatch a subagent to review all changed files (`git diff main...HEAD`). Also reference the project's `security-standards.md` context file if one exists. Review for:

1. **Secrets/credentials** — hardcoded tokens, API keys, passwords in source or logs
2. **Injection** — SQL, command, path traversal, XSS in any user-controlled input
3. **Auth/authz** — missing authentication or authorization checks on endpoints
4. **Data exposure** — sensitive data in API responses, logs, error messages
5. **Dependency risk** — known-vulnerable packages, unpinned versions
6. **Resource safety** — unbounded allocations, missing timeouts, missing cleanup

For each finding: file, line(s), severity (critical/high/medium), specific risk, fix. Fix all critical and high findings. Document medium findings for review.

### Ensure CI Linting

Check if a lint workflow using `wearerequired/lint-action@v2` exists in `.github/workflows/`. If missing, create `.github/workflows/lint.yml` with checkout, language-appropriate linter installation (use `uv pip install` for Python), and `auto_fix: false`. Adapt to match detected project languages. Check for existing lint workflows first to avoid duplication.

## Phase 7: Finish

1. Run the full test suite. Show the output. All tests must pass.
2. Run `git diff main...HEAD --stat` to summarize all changes.
3. Commit any remaining changes from Phase 6.
4. Present integration options to the user:
   - **Merge to main** — squash merge the feature branch
   - **Open a PR** — push and create a pull request
   - **Leave on branch** — keep the branch for manual review
5. Execute whichever option the user picks.

## Rationalizations to Reject

| Excuse | Reality |
|--------|---------|
| "Input is unclear, need to ask" | Enrich from project context. Only ask if blocking. |
| "Security review is overkill for this change" | Every change gets reviewed. No exceptions. |
| "Linter not installed, skip it" | Note it in the report. Don't silently skip. |
| "Tests pass, skip verification" | Verification means running them NOW and showing output. |
| "CodeRabbit isn't authenticated" | Skip with a note. Run the other two tracks. |
| "This is too simple for the full pipeline" | Simple changes are where skipped steps cause the most damage. |
| "I'll reorder phases for efficiency" | Follow the pipeline exactly. No reordering. |
| "Analyze found nothing critical, skip fixes" | Good. Move to the next phase. |
| "Design contradicts CLAUDE.md but seems better" | CLAUDE.md wins. Always. |

## Integration

**Spec-kit commands invoked (in order):**

| Phase | Slash command | Purpose |
|-------|--------------|---------|
| 1 | `/speckit.specify` | Create feature specification |
| 2 | `/speckit.plan` | Create implementation plan |
| 3 | `/speckit.tasks` | Generate actionable task list |
| 4 | `/speckit.analyze` | Cross-artifact consistency check |
| 5 | `/speckit.implement` | Execute all tasks |
| 6 | (inline) | Lint, CodeRabbit, security review |
| 7 | (inline) | Test, summarize, integrate |
