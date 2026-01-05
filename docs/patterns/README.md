# Patterns

AI-assisted development patterns. Pick what you need - each works independently.

## Agent Behavior Patterns

How AI agents work during development.

| Pattern | Description |
|---------|-------------|
| [Autonomous Quality Enforcement](autonomous-quality-enforcement.md) | Validate code before presenting to users |
| [Self-Review Reflection](self-review-reflection.md) | Agent reviews own work before delivery |

## GitHub Actions Patterns

CI/CD automations for AI-assisted workflows.

| Pattern | Trigger | Description |
|---------|---------|-------------|
| [Issue-to-PR Automation](gha-automation-patterns.md#issue-to-pr-automation) | `issues.opened` | Auto-create draft PRs from issues |
| [PR Auto-Review](gha-automation-patterns.md#pr-auto-review) | `pull_request` | AI code review on PRs |
| [Dependabot Auto-Merge](gha-automation-patterns.md#dependabot-auto-merge) | `pull_request` | Safe auto-merge for dependencies |
| [Stale Issue Management](gha-automation-patterns.md#stale-issue-management) | `schedule` | Cleanup inactive issues |
