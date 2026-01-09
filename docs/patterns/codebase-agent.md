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

---

## GitHub Actions Deployment

**Deploy your Codebase Agent as a GitHub bot for team-wide access.**

### Architecture: Two Complementary Approaches

| Approach | Location | Trigger | Use Case |
|----------|----------|---------|----------|
| **Local Agent** (above) | Developer's machine | Claude Code CLI | Individual development workflows |
| **Deployed Agent** (below) | GitHub Actions | @mentions, labels | Team code reviews, PR automation |

### Quick Deploy

**1. Copy the workflow file:**

See the [reference implementation](/.github/workflows/codebase-agent.yml) for the complete, production-ready workflow.

**2. Add GitHub Secret:**

- `ANTHROPIC_API_KEY`: Your Anthropic API key from <https://console.anthropic.com>

**3. Usage:**

```markdown
# In any issue or PR:
@cba please review this PR for security issues
@cba help me understand this error

# Or use labels:
cba-review  → Automatic code review
cba-help    → Automatic analysis
```

### Implementation Details

The reference workflow uses:

- **Modular Python code** - Extracted to `.github/scripts/codebase_agent/` for testability
- **Error handling** - Specific exceptions for API errors, timeouts, rate limits
- **Security** - Command sanitization to prevent prompt injection
- **Safe commands** - Only `review`, `help`, `summarize`, `explain`, `test`, `security`

### Authentication Options

The workflow supports two authentication methods with automatic fallback:

#### Option 1: Anthropic API (Default - Recommended for Quick Start)

**Best for**: Quick setup, any cloud provider, pay-as-you-go

**Setup:**

1. Get API key from <https://console.anthropic.com>
2. Add GitHub secret: `Settings → Secrets → Actions → New secret`
   - Name: `ANTHROPIC_API_KEY`
   - Value: `sk-ant-...`
3. Done!

**Pros:**

- ✅ Simple setup (1 secret)
- ✅ Works anywhere (no GCP required)
- ✅ Pay-as-you-go pricing

**Cons:**

- ❌ Requires API key management
- ❌ Key rotation needed periodically

#### Option 2: Vertex AI (Advanced - For GCP Users)

**Best for**: GCP users, enterprise deployments, no API key management

**Setup:**

1. Set up GCP Workload Identity Federation (see [setup guide](#gcp-workload-identity-setup) below)
2. Uncomment GCP auth steps in workflow (lines 32-37)
3. Add GitHub secrets:
   - `GCP_WORKLOAD_IDENTITY_PROVIDER`
   - `GCP_SERVICE_ACCOUNT`
4. Add GitHub variables:
   - `GCP_PROJECT_ID`
   - `GCP_REGION` (optional, defaults to `us-central1`)
5. Done!

**Pros:**

- ✅ No API keys (uses Workload Identity)
- ✅ Automatic credential rotation
- ✅ GCP billing integration
- ✅ Audit trail in GCP logs

**Cons:**

- ❌ More complex setup
- ❌ Requires GCP project with billing
- ❌ GCP-specific

#### Automatic Fallback

The workflow automatically tries Vertex AI first (if configured), then falls back to Anthropic API:

```text
GCP_PROJECT_ID set? → Try Vertex AI
  ↓ Success? → ✅ Use Vertex AI
  ↓ Failure? → ⚠️ Fall back to Anthropic API

ANTHROPIC_API_KEY set? → ✅ Use Anthropic API
  ↓ Not set? → ❌ Error (no credentials)
```

**Example fallback message** (in workflow logs):

```text
⚠️  Vertex AI unavailable (Project not found), falling back to Anthropic API
```

### GitHub Actions Issues

| Issue | Solution |
|-------|----------|
| Workflow doesn't trigger | Check `if:` condition matches your use case |
| Response not posted | Verify `ANTHROPIC_API_KEY` or `GCP_PROJECT_ID` is set |
| Module import error | Ensure `cd .github/scripts` before running Python |
| Rate limit errors | Add concurrency limits to workflow |
| Vertex AI fallback warning | Expected if GCP not configured - will use Anthropic API |

---

### GCP Workload Identity Setup

<details>
<summary><b>Advanced: Complete GCP Workload Identity Setup Guide</b></summary>

**Prerequisites:**

- GCP project with billing enabled
- GitHub repository admin access
- `gcloud` CLI installed

**Setup script:**

```bash
export PROJECT_ID="your-gcp-project"
export PROJECT_NUMBER="123456789"  # Find in GCP Console → Project Info
export POOL_ID="github-actions-pool"
export PROVIDER_ID="github-provider"
export SERVICE_ACCOUNT="codebase-agent@${PROJECT_ID}.iam.gserviceaccount.com"
export GITHUB_REPO="owner/repo"  # e.g., "jeremyeder/reference"

# 1. Enable required APIs
gcloud services enable iamcredentials.googleapis.com \
  --project="$PROJECT_ID"
gcloud services enable sts.googleapis.com \
  --project="$PROJECT_ID"
gcloud services enable aiplatform.googleapis.com \
  --project="$PROJECT_ID"

# 2. Create Workload Identity Pool
gcloud iam workload-identity-pools create "$POOL_ID" \
  --project="$PROJECT_ID" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# 3. Create OIDC Provider
gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_ID" \
  --project="$PROJECT_ID" \
  --location="global" \
  --workload-identity-pool="$POOL_ID" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='${GITHUB_REPO}'" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# 4. Create Service Account
gcloud iam service-accounts create codebase-agent \
  --project="$PROJECT_ID" \
  --display-name="Codebase Agent"

# 5. Grant Vertex AI permissions
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/aiplatform.user"

# 6. Allow GitHub Actions to impersonate
gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT" \
  --project="$PROJECT_ID" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/attribute.repository/${GITHUB_REPO}"

# 7. Output GitHub secrets and variables
echo ""
echo "======================================"
echo "Add to GitHub Secrets (Settings → Secrets → Actions):"
echo "======================================"
echo "GCP_WORKLOAD_IDENTITY_PROVIDER=projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL_ID}/providers/${PROVIDER_ID}"
echo "GCP_SERVICE_ACCOUNT=${SERVICE_ACCOUNT}"
echo ""
echo "======================================"
echo "Add to GitHub Variables (Settings → Secrets → Variables):"
echo "======================================"
echo "GCP_PROJECT_ID=${PROJECT_ID}"
echo "GCP_REGION=us-central1"
echo ""
echo "Then uncomment GCP auth steps in .github/workflows/codebase-agent.yml (lines 32-37)"
```

**Verification:**

```bash
# Test that GitHub Actions can authenticate
gh workflow run codebase-agent.yml

# Check workflow logs for:
# ✅ "Successfully authenticated to Google Cloud"
# ❌ "Vertex AI unavailable" (means GCP auth failed, falling back)
```

</details>

---

### Example Usage

**Developer adds label:**
![Screenshot: User adds "cba-review" label to PR]

**Bot posts review:**

```markdown
## 🤖 Codebase Agent

I've reviewed this PR. Here are my findings:

### Security
✅ No SQL injection risks
⚠️  Consider rate limiting (line 42)

### Performance
⚠️  DB query in loop (lines 67-73)
✅ Good caching implementation

### Suggestions
1. Add rate limiting: `@limits(calls=100, period=60)`
2. Use bulk query: `User.objects.filter(id__in=ids)`
```
