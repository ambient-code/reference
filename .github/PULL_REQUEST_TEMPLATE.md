## Summary

<!-- Provide a brief description of what this PR does -->

Closes #<!-- issue number -->

## Changes

<!-- List the specific changes made -->

- [ ] Documentation updates
- [ ] Script modifications
- [ ] Workflow changes
- [ ] Agent configuration updates
- [ ] Diagram additions/updates
- [ ] Other: <!-- describe -->

## Type of Change

<!-- Mark with [x] -->

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that would break existing usage)
- [ ] Documentation update
- [ ] Refactoring (no functional changes)

## Testing Done

<!-- Describe the testing you performed -->

- [ ] Ran `./scripts/setup.sh` successfully
- [ ] Ran `./scripts/check-doc-pairs.sh` - all pairs exist
- [ ] Ran `./scripts/validate-mermaid.sh` - diagrams valid
- [ ] Tested documentation in comparison page
- [ ] Manual testing performed: <!-- describe -->

## Documentation Checklist

<!-- For PRs that include documentation -->

- [ ] Both standard and Terry versions created
- [ ] Follows `docs/STYLE_GUIDE.md` guidelines
- [ ] ZeroMQ-style writing (succinct, no AI slop)
- [ ] "What Just Happened?" sections in Terry version
- [ ] Added to comparison page navigation (if new topic)
- [ ] No Red Hat branding
- [ ] No "Amber" terminology (use "Codebase Agent" or "CBA")

## Infrastructure Validation

<!-- Ensure template remains infrastructure-only -->

- [ ] No application code added (`src/`, `app/`, `lib/` directories)
- [ ] No framework imports (FastAPI, Django, Flask, etc.)
- [ ] No database schemas or business logic
- [ ] Patterns remain technology-agnostic

## Security Checklist

<!-- Verify no security issues introduced -->

- [ ] No secrets committed (API keys, passwords, tokens)
- [ ] No hardcoded credentials
- [ ] `.gitignore` updated if new file types added
- [ ] Security best practices followed (if applicable)

## Buffet Approach Validation

<!-- Ensure feature can be adopted independently -->

- [ ] Feature can be extracted and used standalone
- [ ] Dependencies clearly documented (if any)
- [ ] No forced coupling with other features
- [ ] Works without requiring full template adoption

## CI/CD Checks

<!-- These run automatically, but verify locally first -->

- [ ] Security checks pass (no secrets, app code, branding)
- [ ] Documentation validation passes (lint, pairs, syntax)
- [ ] All scripts are executable (`chmod +x`)
- [ ] Shellcheck passes (for script changes)

## Screenshots / Examples

<!-- If applicable, add screenshots or examples showing the changes -->

```
<!-- Paste examples here -->
```

## Additional Context

<!-- Any other information reviewers should know -->

---

## Reviewer Guidance

**For Reviewers**: Please verify:

1. **Documentation Quality**: ZeroMQ-style, no excessive enthusiasm, both versions present
2. **Infrastructure-Only**: No application code, stays focused on patterns/config
3. **Buffet Approach**: Feature is independently adoptable
4. **Security**: No secrets, follows security standards
5. **Testing**: Changes are validated and tested

**Agent Reviews**: If requesting `@codebase-agent` review, specify focus area:
- `@codebase-agent review for security` - Security-focused review
- `@codebase-agent review for style` - Style guide compliance
- `@codebase-agent review for patterns` - Architectural pattern validation
