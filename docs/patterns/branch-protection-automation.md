# Branch Protection Automation

**Pattern**: Automatically configure branch protection rules to enforce code quality standards and prevent broken code from reaching main.

**Problem**: Setting up branch protection manually through the GitHub UI is tedious, error-prone, and inconsistent across repositories. Teams forget required settings, leading to broken code in main branch. Manual setup doesn't scale to dozens or hundreds of repositories.

**Solution**: Automate branch protection setup using GitHub API or CLI. Define protection rules as code, apply consistently across all repositories, and ensure required status checks always gate merges.

---

## Quick Start (5 Minutes)

Set up branch protection for your repository.

### Prerequisites

```bash
# Install GitHub CLI
# macOS: brew install gh
# Linux: https://github.com/cli/cli#installation
# Windows: winget install GitHub.cli

# Authenticate
gh auth login
```

### Method 1: Using gh CLI (Simplest)

```bash
# Basic protection with required status checks
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field enforce_admins=false \
  --field required_pull_request_reviews[required_approving_review_count]=0 \
  --field restrictions=null

# Verify it worked
gh api repos/:owner/:repo/branches/main/protection | jq '.required_status_checks'
```

### Method 2: Using Rulesets (Free Tier Friendly)

For repositories without GitHub Pro:

```bash
# Create ruleset for main branch
gh api repos/:owner/:repo/rulesets \
  --method POST \
  --field name="Protect main branch" \
  --field enforcement="active" \
  --field target="branch" \
  --field conditions[ref_name][include][]=refs/heads/main \
  --field rules[0][type]="pull_request" \
  --field rules[1][type]="required_status_checks" \
  --field rules[1][parameters][required_status_checks][0][context]="ci"
```

**Done!** Your main branch is now protected and requires CI to pass before merging.

---

## Real-World Example: Reporters Repository

The reporters repository needs branch protection to work with auto-merge:

### Required Setup

For dependabot auto-merge to work safely, the reporters repo needs:

1. **Status checks required**: CI pipeline must pass
2. **Up-to-date branches**: PRs must be current with main
3. **No admin bypass**: Even admins follow the rules
4. **No force pushes**: Protect git history

### Why This Matters

From `.github/workflows/README.md`:

```markdown
### 2. Branch Protection Rules

For auto-merge to work safely, configure branch protection on `main`:

1. Go to Settings > Branches > Add rule
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
4. Select required status checks:
   - `ci` (from ci-pipeline.yml)
```

Without this, dependabot could auto-merge broken updates that haven't passed CI.

### Manual vs Automated

**Manual Setup (5 minutes per repo):**
- Navigate to Settings > Branches
- Click "Add rule"
- Enter branch name pattern
- Check 10+ boxes
- Select status checks from dropdown
- Save (hope you didn't miss anything)
- Repeat for every repository

**Automated Setup (5 seconds per repo):**
```bash
./scripts/setup-branch-protection.sh ambient-code reporters
```

---

## Automation Scripts

### Full-Featured Setup Script

Create `scripts/setup-branch-protection.sh`:

```bash
#!/bin/bash
# Setup branch protection for a repository
#
# Usage: ./scripts/setup-branch-protection.sh OWNER REPO [BRANCH]
#
# Example: ./scripts/setup-branch-protection.sh ambient-code reporters main

set -e

OWNER="${1:-}"
REPO="${2:-}"
BRANCH="${3:-main}"

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
  echo "Usage: $0 OWNER REPO [BRANCH]"
  echo "Example: $0 ambient-code reporters main"
  exit 1
fi

echo "Setting up branch protection for $OWNER/$REPO (branch: $BRANCH)"

# Check if repo exists and we have access
if ! gh api "repos/$OWNER/$REPO" >/dev/null 2>&1; then
  echo "Error: Cannot access repository $OWNER/$REPO"
  echo "Check that:"
  echo "  1. Repository exists"
  echo "  2. You have admin access"
  echo "  3. You're authenticated: gh auth status"
  exit 1
fi

# Get repository visibility
VISIBILITY=$(gh api "repos/$OWNER/$REPO" --jq '.visibility')
IS_PRIVATE=$(gh api "repos/$OWNER/$REPO" --jq '.private')

echo "Repository visibility: $VISIBILITY (private: $IS_PRIVATE)"

# Try to set up traditional branch protection (requires GitHub Pro for private repos)
echo "Attempting to set up branch protection rules..."

if gh api "repos/$OWNER/$REPO/branches/$BRANCH/protection" \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field enforce_admins=false \
  --field required_pull_request_reviews[required_approving_review_count]=0 \
  --field required_pull_request_reviews[dismiss_stale_reviews]=false \
  --field required_pull_request_reviews[require_code_owner_reviews]=false \
  --field restrictions=null \
  --field required_linear_history=false \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  >/dev/null 2>&1; then

  echo "✅ Branch protection rules set successfully!"

  # Verify the setup
  echo ""
  echo "Verification:"
  gh api "repos/$OWNER/$REPO/branches/$BRANCH/protection" --jq '{
    required_status_checks: .required_status_checks.contexts,
    enforce_admins: .enforce_admins.enabled,
    required_reviews: .required_pull_request_reviews.required_approving_review_count,
    allow_force_pushes: .allow_force_pushes.enabled
  }'

else
  echo "⚠️  Branch protection API failed (likely requires GitHub Pro for private repos)"
  echo ""
  echo "Falling back to rulesets (available on free tier)..."

  # Create ruleset instead
  if gh api "repos/$OWNER/$REPO/rulesets" \
    --method POST \
    --field name="Protect $BRANCH branch" \
    --field enforcement="active" \
    --field target="branch" \
    --field conditions[ref_name][include][]=refs/heads/$BRANCH \
    --field rules[0][type]="pull_request" \
    --field rules[0][parameters][required_approving_review_count]=0 \
    --field rules[1][type]="required_status_checks" \
    --field rules[1][parameters][strict_required_status_checks_policy]=true \
    --field rules[1][parameters][required_status_checks][0][context]="ci" \
    --field rules[2][type]="deletion" \
    --field rules[3][type]="non_fast_forward" \
    >/dev/null 2>&1; then

    echo "✅ Ruleset created successfully!"
    echo ""
    echo "Your branch is protected via rulesets instead of branch protection rules."
    echo "View at: https://github.com/$OWNER/$REPO/settings/rules"

  else
    echo "❌ Failed to create ruleset"
    echo ""
    echo "Manual setup required:"
    echo "1. Go to https://github.com/$OWNER/$REPO/settings/branches"
    echo "2. Click 'Add rule' for branch: $BRANCH"
    echo "3. Enable:"
    echo "   - Require status checks to pass (select 'ci')"
    echo "   - Require branches to be up to date"
    echo "4. Save changes"
    exit 1
  fi
fi

echo ""
echo "Branch protection setup complete!"
echo ""
echo "Required status checks:"
echo "  - ci (from .github/workflows/ci-pipeline.yml)"
echo ""
echo "Next steps:"
echo "  1. Verify CI workflow is working: gh workflow list"
echo "  2. Test with a PR to confirm checks are required"
echo "  3. Enable dependabot auto-merge if desired"
```

Make it executable:

```bash
chmod +x scripts/setup-branch-protection.sh
```

### Usage

```bash
# Setup for specific repo
./scripts/setup-branch-protection.sh ambient-code reporters

# Setup for different branch
./scripts/setup-branch-protection.sh ambient-code reporters develop

# Setup for multiple repos
for repo in repo1 repo2 repo3; do
  ./scripts/setup-branch-protection.sh ambient-code "$repo"
done
```

---

## Configuration Options

### Minimal Protection (Required)

Bare minimum for safety:

```bash
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field enforce_admins=false \
  --field restrictions=null
```

**Enables:**
- ✅ CI must pass before merge
- ✅ Branches must be up-to-date

### Standard Protection (Recommended)

Good for most teams:

```bash
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field required_status_checks[contexts][]=security-scan \
  --field enforce_admins=true \
  --field required_pull_request_reviews[required_approving_review_count]=1 \
  --field required_pull_request_reviews[dismiss_stale_reviews]=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  --field restrictions=null
```

**Enables:**
- ✅ CI and security scans must pass
- ✅ 1 approval required
- ✅ Stale reviews dismissed on new commits
- ✅ No force pushes
- ✅ No branch deletion
- ✅ Even admins must follow rules

### Strict Protection (High Security)

For critical production code:

```bash
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field required_status_checks[contexts][]=security-scan \
  --field required_status_checks[contexts][]=code-review \
  --field enforce_admins=true \
  --field required_pull_request_reviews[required_approving_review_count]=2 \
  --field required_pull_request_reviews[dismiss_stale_reviews]=true \
  --field required_pull_request_reviews[require_code_owner_reviews]=true \
  --field required_linear_history=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  --field restrictions[users][]=security-team \
  --field restrictions[teams][]=senior-engineers
```

**Enables:**
- ✅ Multiple required status checks
- ✅ 2 approvals required
- ✅ Code owner approval required
- ✅ Linear history (no merge commits)
- ✅ Restricted to specific users/teams

---

## GitHub Free vs Pro Limitations

### Branch Protection API Limitations

**GitHub Free (Public Repos):**
- ✅ Full branch protection API access
- ✅ Required status checks
- ✅ Required reviews
- ✅ Enforce admins
- ✅ All features available

**GitHub Free (Private Repos):**
- ❌ Branch protection API requires GitHub Pro
- ❌ Cannot use traditional protection rules
- ✅ Can use Rulesets instead (newer feature)

**GitHub Pro/Team/Enterprise:**
- ✅ Full branch protection on all repos
- ✅ All features available

### Rulesets as Alternative

Rulesets are available on all tiers:

```bash
# Works on GitHub Free for private repos
gh api repos/$OWNER/$REPO/rulesets \
  --method POST \
  --field name="Protect main" \
  --field enforcement="active" \
  --field target="branch" \
  --field conditions[ref_name][include][]=refs/heads/main \
  --field rules[0][type]="pull_request" \
  --field rules[1][type]="required_status_checks" \
  --field rules[1][parameters][required_status_checks][0][context]="ci"
```

### Detection Script

Check which method to use:

```bash
#!/bin/bash
# detect-protection-method.sh

OWNER="$1"
REPO="$2"

# Check if branch protection API works
if gh api "repos/$OWNER/$REPO/branches/main/protection" >/dev/null 2>&1; then
  echo "Branch Protection API: Available"
  echo "Use: Branch protection rules"
else
  echo "Branch Protection API: Not available (requires GitHub Pro for private repos)"
  echo "Use: Rulesets instead"
fi

# Check if rulesets are available
if gh api "repos/$OWNER/$REPO/rulesets" >/dev/null 2>&1; then
  echo "Rulesets API: Available"
else
  echo "Rulesets API: Not available"
fi
```

---

## Common Status Check Names

Map your workflows to status check names:

| Workflow File | Job Name | Status Check Context |
|---------------|----------|---------------------|
| `ci-pipeline.yml` | `ci` | `ci` |
| `ci-pipeline.yml` | `test` | `test` |
| `quality-check.yml` | `quality` | `quality` |
| `security-scan.yml` | `security` | `security` |
| `build.yml` | `build` | `build` |

Find your workflow's status check name:

```bash
# List recent check runs for a PR
gh api repos/$OWNER/$REPO/commits/COMMIT_SHA/check-runs \
  --jq '.check_runs[] | {name: .name, status: .status, conclusion: .conclusion}'

# Or view in GitHub UI:
# Pull Request > Checks tab > Look at check names
```

---

## Bulk Operations

### Apply to Multiple Repositories

```bash
#!/bin/bash
# setup-all-repos.sh

OWNER="ambient-code"
REPOS=(
  "reporters"
  "reference"
  "demo-fastapi"
  "claude-code"
)

for repo in "${REPOS[@]}"; do
  echo "Setting up $repo..."
  ./scripts/setup-branch-protection.sh "$OWNER" "$repo"
  echo ""
done
```

### Apply to All Repos in Organization

```bash
#!/bin/bash
# setup-org-protection.sh

ORG="ambient-code"

# Get all repos in org
gh repo list "$ORG" --json name --jq '.[].name' | while read -r repo; do
  echo "Setting up $repo..."
  ./scripts/setup-branch-protection.sh "$ORG" "$repo"
  echo ""
done
```

### Update Existing Protection

```bash
#!/bin/bash
# update-status-checks.sh
# Add a new required status check to existing protection

OWNER="$1"
REPO="$2"
NEW_CHECK="$3"

# Get current contexts
CURRENT=$(gh api "repos/$OWNER/$REPO/branches/main/protection" \
  --jq '.required_status_checks.contexts[]')

# Add new check
CHECKS=()
while IFS= read -r check; do
  CHECKS+=("$check")
done <<< "$CURRENT"
CHECKS+=("$NEW_CHECK")

# Build the field arguments
ARGS=""
for check in "${CHECKS[@]}"; do
  ARGS="$ARGS --field required_status_checks[contexts][]=$check"
done

# Update protection
gh api "repos/$OWNER/$REPO/branches/main/protection" \
  --method PUT \
  --field required_status_checks[strict]=true \
  $ARGS \
  --field enforce_admins=false \
  --field restrictions=null

echo "Added $NEW_CHECK to required status checks"
```

---

## Troubleshooting

### Error: Resource not accessible by integration

**Cause**: Insufficient permissions.

**Solution**:

```bash
# Check your permissions
gh api repos/$OWNER/$REPO --jq '.permissions'

# You need admin access
# "permissions": {
#   "admin": true,
#   "push": true,
#   "pull": true
# }
```

Ask a repository admin to run the script or grant you admin access.

### Error: Validation Failed (422)

**Cause**: Invalid API request or trying to use Pro features on Free tier.

**Solution**:

```bash
# Check repository visibility
gh api repos/$OWNER/$REPO --jq '{visibility: .visibility, private: .private}'

# If private repo on Free tier, use rulesets instead
./scripts/setup-branch-protection.sh $OWNER $REPO --use-rulesets
```

### Error: Status check "ci" not found

**Cause**: Status check hasn't run yet or wrong name.

**Solution**:

```bash
# Create a dummy commit to trigger CI
git commit --allow-empty -m "Trigger CI for branch protection setup"
git push

# Wait for CI to run, then setup branch protection
gh run list --workflow=ci-pipeline.yml --limit=1
./scripts/setup-branch-protection.sh $OWNER $REPO
```

Or allow the status check to be added even if it hasn't run:

```bash
# GitHub will warn but allow it
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \  # Doesn't exist yet - OK
  --field enforce_admins=false \
  --field restrictions=null
```

### Branch Protection Not Enforced

**Cause**: Admins can bypass, or settings not saved.

**Solution**:

```bash
# Verify protection is actually enabled
gh api repos/$OWNER/$REPO/branches/main/protection --jq '{
  enabled: true,
  required_checks: .required_status_checks.contexts,
  enforce_admins: .enforce_admins.enabled
}'

# If enforce_admins is false, enable it:
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field enforce_admins=true \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field restrictions=null
```

### Can Merge Without Status Checks

**Cause**: Status check name doesn't match workflow job name.

**Solution**:

```bash
# Find the actual status check name from a PR
gh pr view 123 --json statusCheckRollup --jq '.statusCheckRollup[] | .context'

# Use the exact name in branch protection
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[contexts][]="CI Pipeline / ci"  # Use exact name
```

---

## Best Practices

### 1. Set Up Protection Early

Add branch protection when you create the repository:

```bash
# Initialize repo
gh repo create $ORG/$REPO --public
cd $REPO

# Add CI workflow
mkdir -p .github/workflows
cp ../templates/ci-pipeline.yml .github/workflows/

# Commit and push
git add .github/
git commit -m "Add CI workflow"
git push

# Wait for first CI run
sleep 30

# Enable protection
../scripts/setup-branch-protection.sh $ORG $REPO
```

### 2. Test Protection with a PR

```bash
# Create test branch
git checkout -b test-protection

# Make a change that will fail CI
echo "print('bad code')" >> test.py

# Push and create PR
git add test.py
git commit -m "Test: should fail CI"
git push -u origin test-protection

# Create PR
gh pr create --title "Test branch protection" --body "Should fail CI"

# Verify you can't merge until CI passes
gh pr merge --auto  # Should fail with "Required status check ci has not completed"
```

### 3. Document Required Checks

In your README or CONTRIBUTING.md:

```markdown
## Branch Protection

The `main` branch is protected. All PRs must:

1. Pass the `ci` status check (linting, tests, security scans)
2. Be up-to-date with main
3. Not be force-pushed

Setup: `./scripts/setup-branch-protection.sh ambient-code reporters`
```

### 4. Sync Protection Across Repos

Use a template configuration:

```bash
# config/branch-protection.json
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["ci", "security-scan"]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}

# Apply to repo
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --input config/branch-protection.json
```

### 5. Audit Protection Settings

```bash
#!/bin/bash
# audit-protection.sh

OWNER="ambient-code"

gh repo list "$OWNER" --json name --jq '.[].name' | while read -r repo; do
  echo "=== $repo ==="
  gh api "repos/$OWNER/$repo/branches/main/protection" 2>/dev/null | jq '{
    required_checks: .required_status_checks.contexts,
    enforce_admins: .enforce_admins.enabled,
    required_reviews: .required_pull_request_reviews.required_approving_review_count
  }' || echo "No protection"
  echo ""
done
```

### 6. Update Protection When Adding Workflows

When you add a new required workflow:

```bash
# Added new security-scan.yml workflow
# Update branch protection to require it
gh api repos/$OWNER/$REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks[contexts][]=ci \
  --field required_status_checks[contexts][]=security-scan \  # New check
  --field required_status_checks[strict]=true \
  --field enforce_admins=false \
  --field restrictions=null
```

---

## Alternative: GitHub Web UI

If you prefer manual setup:

1. Go to `https://github.com/OWNER/REPO/settings/branches`
2. Click "Add rule"
3. Branch name pattern: `main`
4. Check "Require status checks to pass before merging"
5. Check "Require branches to be up to date before merging"
6. Search for and select your status checks (`ci`, etc.)
7. Optionally check "Require a pull request before merging"
8. Click "Create"

**Pros:**
- Visual interface
- No CLI required
- See all options at once

**Cons:**
- Slow and tedious
- Easy to miss settings
- Not reproducible across repos
- No audit trail

---

## Terraform Alternative

For infrastructure-as-code approach:

```hcl
# github.tf
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

resource "github_branch_protection" "main" {
  repository_id = "reporters"
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = ["ci"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = false
  }

  enforce_admins = false
}

# Apply with:
# terraform init
# terraform apply
```

**Pros:**
- Infrastructure as code
- Version controlled
- Declarative
- Supports all GitHub resources

**Cons:**
- Requires Terraform knowledge
- More complex setup
- Overkill for single repo

---

## Related Patterns

- [ci-pipeline-pattern.md](ci-pipeline-pattern.md) - CI pipeline that provides the required status checks
- [autonomous-quality-enforcement.md](autonomous-quality-enforcement.md) - Quality enforcement at multiple levels
- [gha-automation-patterns.md](gha-automation-patterns.md) - GitHub Actions automation workflows

---

## Summary

This pattern provides:

- **Automated branch protection setup** via scripts
- **Consistency across repositories** with reusable configurations
- **Protection against broken code** reaching main
- **Support for both Pro and Free tiers** with rulesets fallback
- **Audit and bulk operation capabilities**

Copy the setup script, customize for your organization, and protect your branches automatically.
