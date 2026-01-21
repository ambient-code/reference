# GitHub Actions Workflows

This directory contains GitHub Actions workflows demonstrating modern CI/CD patterns for AI-assisted development. All workflows follow best practices for security, performance, and maintainability.

## Overview

**Total Workflows**: 11 (10 functional + 1 demonstration)

All workflows implement:
- ✅ Concurrency controls (prevent queue backlog, save CI minutes)
- ✅ GitHub step summaries (enhanced UX in Actions UI)
- ✅ Minimal necessary permissions (security best practice)
- ✅ Clear naming and documentation

---

## Core Validation Workflows

### [ci.yml](ci.yml)

**Purpose**: Documentation structure validation and repomap currency checks

**Triggers**:
- Push to `main` branch
- Pull requests to `main`
- Manual workflow dispatch

**Jobs**:
1. **documentation-structure** - Verifies required docs exist
2. **repomap-validation** - Ensures `.repomap.txt` is current

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)

**Why it exists**: Ensures codebase structure remains consistent and context maps are up-to-date for AI-assisted development.

---

### [validate.yml](validate.yml)

**Purpose**: Autonomous Quality Enforcement (AQE) checks

**Triggers**:
- Push to `main` or `validation/*` branches
- Pull requests to `main`
- Manual workflow dispatch

**Jobs**:
1. **aqe-validation** - Quality checks via `.github/scripts/check.sh`
2. **documentation-structure** - Documentation existence checks
3. **validation-summary** - GitHub step summary of results

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)

**Why it exists**: Enforces quality gates before human review, demonstrates AQE pattern.

---

### [docs-validation.yml](docs-validation.yml)

**Purpose**: Documentation quality validation

**Triggers**:
- Push to `main` with doc changes (`docs/**`, `**/*.md`)
- Pull requests to `main` with doc changes
- Runs only when documentation files change

**Jobs**:
1. **validate-mermaid** - Validates Mermaid diagram syntax
2. **lint-markdown** - Lints markdown files with markdownlint-cli2
3. **validation-summary** - Summary with pass/fail status

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)

**Why it exists**: User noted "Mermaid diagrams always have errors" - this catches them in CI.

---

## Security Workflows

### [security.yml](security.yml)

**Purpose**: Security scanning and vulnerability detection

**Triggers**:
- Push to `main`
- Pull requests to `main`
- Weekly schedule (Sunday midnight UTC)

**Jobs**:
1. **codeql** - Multi-language static analysis (Python, JavaScript)
   - Matrix strategy for parallel execution
   - Integrates with GitHub Security tab
   - Uses `security-extended` query pack
2. **security-scan** - Pattern-based security checks
   - Secrets in documentation detection
   - Hardcoded URL credentials detection
   - `.env` file commit prevention
3. **security-summary** - Consolidated results with GitHub step summary

**Permissions**:
- `contents: read` (checkout code)
- `security-events: write` (upload CodeQL results)
- `actions: read` (access workflow metadata)

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)

**Why it exists**: Demonstrates industry-standard security scanning, finds real issues in doc examples and workflows.

---

## Testing Workflows

### [e2e-pattern-tests.yml](e2e-pattern-tests.yml)

**Purpose**: End-to-end validation of all 11 pattern implementations

**Triggers**:
- Push to `main` (when patterns, workflows, or E2E test scripts change)
- Pull requests to `main` (same path filters)
- Manual workflow dispatch

**Path Filters**: Optimized to run only when relevant files change:
- Pattern documentation (`docs/patterns/**`)
- Workflow files (`.github/workflows/**`) - patterns reference actual workflows
- E2E test scripts (`.github/scripts/e2e-tests/**`)

⚠️ **Path Filter Limitation**: If test logic changes in ways not covered by these paths (e.g., updating test expectations in untracked files), tests won't auto-trigger. Use `workflow_dispatch` (manual trigger) for comprehensive validation in these cases.

**Jobs**:
- **pattern-1-aqe** through **pattern-11-testing** (parallel execution)
- **summary** - Consolidated results table with pass/fail status

**Test Patterns**:
1. AQE (Autonomous Quality Enforcement)
2. CBA (Codebase Agent)
3. Dependabot
4. GitHub Actions
5. Issue-to-PR
6. Multi-Agent
7. PR Review
8. Security
9. Self-Review
10. Stale Management
11. Testing

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)

**Why it exists**: Ensures all pattern documentation is accurate and examples work correctly.

---

## Automation Workflows

### [issue-to-pr.yml](issue-to-pr.yml)

**Purpose**: Converts labeled issues to draft PRs automatically

**Triggers**:
- Issue labeled with `ready-for-pr`

**Workflow**:
1. Analyzes issue for clarity (acceptance criteria, requirements)
2. If vague: Requests clarification via comment
3. If clear: Creates feature branch and draft PR

**Permissions**:
- `contents: write` (create branches)
- `pull-requests: write` (create PRs)
- `issues: write` (post comments)

**Concurrency**: Does NOT cancel in-progress (`cancel-in-progress: false`)
- Rationale: Don't interrupt PR creation mid-process

**Why it exists**: Demonstrates Issue-to-PR automation pattern.

---

### [pr-review.yml](pr-review.yml)

**Purpose**: Automated PR security and quality reviews

**Triggers**:
- PR opened, synchronized, or marked ready for review
- Skips draft PRs and PRs with `skip-review` label

**Checks**:
1. **Security Review**:
   - Hardcoded secrets detection
   - `.env` file additions
   - TODOs in security-sensitive code
2. **Code Quality Review**:
   - Large file changes (>100 lines)
   - Missing test coverage

**Permissions**:
- `contents: read` (read code)
- `pull-requests: write` (post comments)

**Concurrency**: Cancels outdated runs (`cancel-in-progress: true`)
- Rationale: Re-review on each push, cancel old reviews

**Why it exists**: Provides fast automated feedback before human review.

---

### [dependabot-auto-merge.yml](dependabot-auto-merge.yml)

**Purpose**: Automatically merges Dependabot patch updates

**Triggers**:
- Pull request opened, synchronized, reopened, or labeled
- Only processes PRs from `dependabot[bot]`

**Strategy**:
- **Auto-merge**: `semver-patch` updates (e.g., 1.2.3 → 1.2.4)
- **Comment only**: `semver-minor` and `semver-major` updates (requires human review)

**Permissions**:
- `contents: write` (merge PRs)
- `pull-requests: write` (post comments)

**Concurrency**: Does NOT cancel in-progress (`cancel-in-progress: false`)
- Rationale: Don't interrupt merge operations

**Why it exists**: Reduces maintenance burden for low-risk dependency updates.

---

### [stale.yml](stale.yml)

**Purpose**: Automated stale issue and PR management

**Triggers**:
- Daily at midnight UTC
- Manual workflow dispatch

**Configuration**:
- **Issues**: 30 days inactive → stale, 7 days stale → close
- **PRs**: 14 days inactive → stale, 7 days stale → close
- **Exemptions**: Issues/PRs with `pinned`, `security`, `bug`, `help-wanted` labels
- **Assignees**: Never mark as stale if assigned

**Permissions**:
- `issues: write` (label/close issues)
- `pull-requests: write` (label/close PRs)

**Concurrency**: Does NOT cancel in-progress (`cancel-in-progress: false`)
- Rationale: Scheduled jobs should complete, not race with each other

**Why it exists**: Keeps issue tracker clean without manual triage.

---

## Deployment Workflows

### [deploy-docs.yml](deploy-docs.yml)

**Purpose**: Deploys documentation to GitHub Pages

**Triggers**:
- Push to `main` with doc changes (`docs/**`, `mkdocs.yml`, workflow file)
- Manual workflow dispatch

**Jobs**:
1. **build** - Builds MkDocs site with Material theme
2. **deploy** - Deploys to GitHub Pages

**Permissions**:
- `contents: read` (read documentation)
- `pages: write` (deploy to GitHub Pages)
- `id-token: write` (OIDC for deployment)

**Concurrency**:
- Group: `pages`
- Does NOT cancel in-progress (`cancel-in-progress: false`)
- Rationale: Complete deployment before starting new one

**Why it exists**: Automatically publishes documentation changes to public site.

---

## Demonstration Workflows

### [coverage-comment.yml](coverage-comment.yml) ⚠️ DEMONSTRATION ONLY

**Purpose**: Demonstrates fork PR coverage comment pattern

**Status**: **NOT FUNCTIONAL** - Requires coverage collection to be added to test workflows

**Triggers**:
- After `E2E Pattern Tests` workflow completes

**Pattern Demonstrated**:
1. **Fork PR Support**: Uses `workflow_run` trigger for write permissions
2. **Security Validation**: Validates PR number to prevent cross-PR injection
3. **Update-or-Create**: Updates existing comment or creates new one
4. **Graceful Degradation**: Skips comment if no coverage data available

**Why it exists**: Shows template users how to implement coverage comments that work with fork PRs.

**To enable**:
1. Add coverage collection to test workflows (pytest --cov, jest --coverage)
2. Upload coverage data as artifacts with pattern `coverage-data-*`
3. Include JSON fields: `pr_number`, `component`, `pr_coverage`, `main_coverage`, `diff`

See workflow file header for detailed implementation instructions.

---

## Pattern Highlights

### 1. Concurrency Control Pattern

All workflows use concurrency controls to prevent queue backlog and save CI minutes:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true  # or false, depending on workflow type
```

**When to cancel**:
- ✅ Validation/test workflows (ci.yml, validate.yml, e2e-pattern-tests.yml)
- ✅ Review workflows (pr-review.yml)
- ❌ Creation workflows (issue-to-pr.yml, dependabot-auto-merge.yml)
- ❌ Scheduled workflows (stale.yml)
- ❌ Deployment workflows (deploy-docs.yml)

### 2. GitHub Step Summary Pattern

Key workflows generate rich summaries visible in the Actions UI:

```yaml
- name: Generate summary
  if: always()
  run: |
    {
      echo "## 🎯 Workflow Results"
      echo ""
      echo "| Check | Status |"
      echo "|-------|--------|"
      echo "| Job 1 | ${{ needs.job1.result == 'success' && '✅ Passed' || '❌ Failed' }} |"
    } >> "$GITHUB_STEP_SUMMARY"
```

**Workflows with summaries**:
- e2e-pattern-tests.yml (11-pattern table)
- validate.yml (AQE validation results)
- docs-validation.yml (Mermaid + markdown lint results)
- security.yml (CodeQL + security scan results)

### 3. Fork PR Support Pattern

**Problem**: Fork PRs have limited permissions (can't write comments/statuses)

**Solution**: Use `workflow_run` trigger (demonstrated in coverage-comment.yml)

```yaml
on:
  workflow_run:
    workflows: ["Tests"]
    types: [completed]

jobs:
  post-comment:
    if: >
      github.event.workflow_run.event == 'pull_request' &&
      github.event.workflow_run.conclusion == 'success'
```

**Security**: Always validate PR number from artifact matches trusted PR number.

### 4. Matrix Strategy Pattern

Multi-language/version testing with parallel execution:

```yaml
strategy:
  fail-fast: false
  matrix:
    language: ['python', 'javascript']
```

Used in: security.yml (CodeQL for Python and JavaScript)

---

## Best Practices Demonstrated

1. **Minimal Permissions**: Each workflow requests only necessary permissions
2. **Concurrency Controls**: Prevent queue backlog, save CI minutes
3. **Clear Naming**: Job and step names clearly describe what they do
4. **GitHub Step Summaries**: Enhanced UX in Actions UI
5. **Security Validation**: Input sanitization, credential detection
6. **Graceful Degradation**: Workflows handle missing files/data gracefully
7. **Documentation**: Inline comments explain complex logic
8. **Semantic Triggers**: Workflows trigger only when relevant files change

---

## Maintenance Guidelines

### When to Update Workflows

1. **Adding new patterns**: Add test job to e2e-pattern-tests.yml
2. **Changing documentation structure**: Update ci.yml and validate.yml checks
3. **Adding new languages**: Update security.yml CodeQL matrix
4. **Modifying permissions**: Review security implications carefully

### Testing Workflow Changes

1. **Syntax validation**: Use `actionlint` (recommended)
2. **Test in PR**: All workflows run on PRs, verify they work
3. **Check step summaries**: Ensure summaries render correctly
4. **Review permissions**: Ensure minimal necessary permissions

### Common Issues

- **"Resource not accessible by integration"**: Insufficient permissions
- **"Concurrency group conflicts"**: Multiple workflows with same group
- **"Required status checks not found"**: Branch protection referencing old job names
- **"Mermaid syntax errors"**: Run `./scripts/validate-mermaid.sh` locally
- **"Permission denied" when running scripts**: Ensure scripts are committed with executable permissions (`git add --chmod=+x script.sh` or `chmod +x script.sh && git add script.sh`). Workflows no longer use `chmod +x` inline, relying on git-tracked executable bits.

---

## Reference Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow syntax reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Security hardening for Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [CodeQL documentation](https://codeql.github.com/docs/)
- [actionlint - Workflow linter](https://github.com/rhysd/actionlint)

---

## Questions or Issues?

- Review workflow file headers for detailed implementation notes
- Check [CLAUDE.md](../../CLAUDE.md) for repository standards
- See [docs/patterns/](../../docs/patterns/) for pattern documentation
- Open an issue for workflow-specific questions
