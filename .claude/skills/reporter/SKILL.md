---
name: reporter
description: Create automated news reporters for tracking technical developments. Use when setting up monitoring for a technology, framework, or organization.
argument-hint: [technology-name]
disable-model-invocation: true
allowed-tools: Write, Edit, Read, Bash
---

# Reporter Skill

Create a new automated reporter that monitors public sources and generates daily news reports.

## What You'll Get

A complete reporter setup that:
1. Monitors GitHub, HackerNews, Reddit, Twitter/X, and ArXiv
2. Filters content with keywords
3. Analyzes with Claude
4. Posts daily GitHub issue reports
5. Learns from team reactions (RLHF)

## Usage

```bash
/reporter [technology-name]
```

**Example:**
```bash
/reporter kubernetes
```

This creates a Kubernetes reporter monitoring:
- kubernetes/kubernetes GitHub releases
- HackerNews stories mentioning "kubernetes", "k8s"
- r/kubernetes subreddit
- @kubernetesio Twitter
- Papers from Kubernetes maintainers

## What Gets Created

```
$0/
├── src/signal/
│   ├── $0_reporter.py       # Main monitoring script
│   └── github_utils.py       # Shared GitHub utilities
├── config/
│   ├── $0-sources.md        # What to monitor
│   └── system-prompt.txt     # How Claude analyzes
├── .github/workflows/
│   └── $0-reporter.yml      # Daily automation (8am EST)
├── data/
│   └── reports.json          # Deduplication state
├── requirements.txt          # Production dependencies
├── requirements-dev.txt      # Development tools
└── README.md
```

## Customization After Creation

### Add/Remove Sources

Edit `config/$0-sources.md`:

```markdown
## GitHub Repositories
- owner/repo

## Reddit Subreddits
- subreddit-name

## Twitter Accounts
- @username

## ArXiv Authors
- Full Name
```

### Customize Analysis

Edit `config/system-prompt.txt` to change:
- Team focus areas
- Selection criteria (top 5 → top 3, etc.)
- Output format
- Suggested actions

### Change Schedule

Edit `.github/workflows/$0-reporter.yml`:
```yaml
schedule:
  - cron: "0 13 * * *"  # 8am EST = 1pm UTC
```

## Required Setup

After creation, set GitHub secrets:

```bash
gh secret set ANTHROPIC_API_KEY --body "sk-..."
gh secret set TWITTER_BEARER_TOKEN --body "..." # Optional
```

Then enable the workflow:

```bash
gh workflow enable $0-reporter.yml
```

## Implementation Notes

**Copy from template**: Use the `anthropic/` reporter as a template. It's production-tested and includes all the patterns you need.

**Key files to customize**:
1. `config/$0-sources.md` - Set your monitoring targets
2. `config/system-prompt.txt` - Tailor analysis to your team
3. `README.md` - Document your specific use case

**Don't modify**:
- Core fetcher logic (proven and tested)
- GitHub utilities (shared across reporters)
- Deduplication approach (7-day window works well)

## Testing Locally

```bash
cd $0
pip install -r requirements.txt

export ANTHROPIC_API_KEY="your-key"
export GITHUB_TOKEN="your-token"
export GITHUB_REPOSITORY="owner/repo"

python src/signal/$0_reporter.py
```

## Tips

**Start narrow**: Monitor 2-3 sources initially. Expand based on signal quality.

**Tune the prompt**: After a week, review reports and adjust `system-prompt.txt` to improve relevance.

**Use reactions**: Team members should 👍/👎 individual items. This trains the system over time.

**Keywords matter**: In sources.md comments, note why each source is included. Helps future maintainers.

## Examples of Good Reporters

**Anthropic** (existing): Monitors all Anthropic developments for enterprise AI team
**PyTorch**: Track releases, papers, and community discussions
**Kubernetes**: Monitor k8s releases, CVEs, and SIG updates
**Red Hat**: Track product releases, blogs, and community contributions

## Related

- Template: See `anthropic/` directory
- CI/CD: Reporters use the same CI Pipeline as the main repo
- Automation: All reporters share the same GHA workflows
