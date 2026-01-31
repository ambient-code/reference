# Expert System Pattern

Package domain expertise as queryable knowledge for humans and AI agents.

## Problem

Technical knowledge trapped in experts' heads. Teams lack instant access to guidance on upgrades, debugging, optimization. AI agents lack domain depth.

## Solution

3-layer knowledge architecture:
1. **Human docs** - Narrative guides with examples
2. **AI skills** - Quick-reference patterns optimized for LLM consumption
3. **Validation tests** - Automated checks that knowledge stays current

## Quick Start

```bash
# 1. Create structure
mkdir -p docs/{domain}-expert .ambient/skills/{domain}-expert tests/expert-validation

# 2. Write human guide (docs/{domain}-expert/README.md)
# 3. Distill to AI skill (.ambient/skills/{domain}-expert/SKILL.md)
# 4. Add validation tests (tests/expert-validation/test_{domain}.py)
```

## Architecture

```
docs/{domain}-expert/              # Human layer (comprehensive)
├── README.md                      # Hub + quick reference
├── USAGE.md                       # Integration guide
├── UPGRADE.md                     # Version migration
└── OPTIMIZATION.md                # Performance tuning

.ambient/skills/{domain}-expert/   # AI layer (concise)
├── SKILL.md                       # Quick patterns, checklists, Q&A
└── USAGE-FOR-AI.md               # How AI should use the skill

tests/expert-validation/           # Validation layer
└── test_{domain}.py              # Verify knowledge is current
```

## Layer 1: Human Documentation Template

```markdown
# {Domain} Expert

## Quick Reference
- Common task 1: Answer [details →](USAGE.md#task1)
- Common task 2: Answer [details →](USAGE.md#task2)

## Guides
- [Usage](USAGE.md) - Integration patterns
- [Upgrade](UPGRADE.md) - Version migration
- [Optimization](OPTIMIZATION.md) - Performance
- [Troubleshooting](TROUBLESHOOTING.md) - Debug guide

## Code Examples
\```language
# Concrete examples from your codebase
# Include file paths: src/foo.py:123
\```
```

**Rules:**
- Use real examples from your codebase (not generic tutorials)
- Include file paths and line numbers
- Explain why, not just what
- Keep examples runnable

## Layer 2: AI Skills Template

```markdown
# {Domain} Expert Skill

**Version:** 1.0.0
**Purpose:** {One-line description}

## When to Use
- {Trigger 1}
- {Trigger 2}

## Quick Patterns

### {Task}
\```language
# Minimal code example
\```

## Configuration
| Setting | Default | Purpose |
|---------|---------|---------|

## Troubleshooting
When X fails:
1. Check Y
2. Verify Z

## Q&A Templates

### "{Common question}?"
**Response:**
\```
Direct answer.
Source: [file.md#section]
\```

## Documentation Links
- **USAGE.md** - Integration patterns
- **UPGRADE.md** - Version migration
```

**Rules:**
- Concise (tables, checklists, not prose)
- Self-contained sections
- Always link to human docs for details
- Include Q&A templates for instant answers

## Layer 3: Validation Tests Template

```python
"""Validate {domain} expert knowledge."""
import pytest

def test_config_examples_valid():
    """Config examples in docs actually work."""
    # Extract configs from markdown
    # Validate they parse correctly
    pass

def test_version_info_current():
    """Version numbers not outdated."""
    # Check versions against registries
    # Flag if CVEs found
    pass

def test_code_examples_run():
    """Code snippets execute without errors."""
    # Extract code blocks
    # Run in isolated environment
    pass
```

**Run in CI:**
```yaml
# .github/workflows/validate-expert.yml
on:
  push:
    paths: ['docs/{domain}-expert/**', '.ambient/skills/{domain}-expert/**']
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - run: pytest tests/expert-validation/ -v
```

## Real Example: Claude SDK Expert

```
platform/
├── docs/claude-agent-sdk/          # 15K words
│   ├── README.md
│   ├── SDK-USAGE.md               # Integration (~5K)
│   ├── UPGRADE-GUIDE.md           # Migration (~4K)
│   └── AG-UI-OPTIMIZATION.md      # Performance (~6K)
│
├── .ambient/skills/claude-sdk-expert/  # 700 lines
│   ├── SKILL.md                   # Patterns, checklists
│   └── USAGE-FOR-AMBER.md         # Meta-guide
│
└── tests/smoketest/
    ├── test_sdk_integration.py    # 15+ tests
    └── README.md
```

**Impact:**
- "Should we upgrade?" → Instant answer (was: hours of research)
- SDK debugging → Follow checklist (was: trial and error)
- Performance → 3-5x improvement roadmap documented

## Distribution

### Option 1: Git Submodule
```bash
git submodule add https://github.com/org/experts.git .experts
# Reference in agent: skills: [.experts/{domain}-expert]
```

### Option 2: MCP Server (Recommended)
```python
# mcp_server_{domain}_expert.py
from mcp.server import Server

server = Server("domain-expert")

@server.call_tool()
async def call_tool(name: str, args: dict):
    if name == "query_expert":
        # Load SKILL.md, search for answer
        return {"content": [{"type": "text", "text": answer}]}
```

Usage:
```json
# .mcp.json or Claude Desktop config
{
  "mcpServers": {
    "domain-expert": {
      "command": "python",
      "args": ["-m", "domain_expert_mcp.server", "/path/to/knowledge"]
    }
  }
}
```

### Option 3: Package
```bash
pip install {domain}-expert-system
# Installs docs/, skills/, tests/
```

## Building Your Expert System

### Phase 1: Knowledge Capture (Day 1-2)
1. Interview domain expert
2. Ask: "What do people always ask you?" "Biggest mistakes?" "What took longest to learn?"
3. Document in human guides with real examples

### Phase 2: AI Optimization (Day 3)
1. Extract key patterns from human docs
2. Create decision trees for troubleshooting
3. Build Q&A templates
4. Write SKILL.md

### Phase 3: Validation (Day 4)
1. Extract testable claims
2. Write validation tests
3. Add to CI

### Phase 4: Integration (Day 5)
1. Add to agent skills
2. Create shortcuts (slash commands)
3. Monitor usage

## Telemetry

Track usage to find gaps:

```python
# Log queries
telemetry = {
    "timestamp": time.time(),
    "question": question[:100],
    "question_type": categorize(question),  # upgrade, perf, debug
    "confidence": "HIGH|MEDIUM|LOW",
    "sources_used": len(sources),
    "duration_ms": duration
}
```

Analyze:
```bash
# Most common questions
cat telemetry.jsonl | jq -r '.question_type' | sort | uniq -c

# Knowledge gaps (low confidence)
cat telemetry.jsonl | jq 'select(.confidence == "LOW")'
```

## Measuring Success

| Metric | Before | After |
|--------|--------|-------|
| Time to answer | Hours | Seconds |
| Expert bottleneck | 1 person | Zero |
| Knowledge drift | Undetected | CI catches |
| New hire onboarding | Slow | Fast |

## Common Pitfalls

**Knowledge drift:** Domain evolves, docs don't.
→ Fix: Weekly CI validation, check against external sources

**Over-generalization:** Generic advice, not specific to your codebase.
→ Fix: Use real file paths, actual code from your repo

**AI hallucination:** Invents answers beyond knowledge base.
→ Fix: Explicit boundaries in USAGE-FOR-AI.md, require source citation

## Advanced Patterns

### Multi-Domain Networks
```markdown
# In database-expert/SKILL.md
## Related Experts
- **cache-expert** - Cache invalidation
- **security-expert** - SQL injection prevention
When query involves caching → consult cache-expert
```

### Version-Specific Knowledge
```
docs/k8s-expert/
├── v1.28/
├── v1.29/
└── VERSION-MAP.md  # Which version to use
```

### Confidence Scoring
```markdown
**Response (Confidence: HIGH - tested in prod):**
Yes, feature X is ready.
Source: tests/production/test_x.py
```

## Recommended Expert Systems

**Start with:** Domain where team asks most repeat questions.

**High-value domains:**
- `sdk-expert` - Third-party SDK integrations
- `kubernetes-expert` - K8s deployment, debugging
- `database-expert` - Query optimization, schema
- `security-expert` - OWASP Top 10, compliance
- `performance-expert` - Profiling, optimization

## Getting Started Checklist

- [ ] Pick domain with most repeat questions
- [ ] Interview expert, extract knowledge
- [ ] Create structure (docs/, .ambient/skills/, tests/)
- [ ] Write first guide (USAGE.md)
- [ ] Distill to SKILL.md
- [ ] Add 3-5 validation tests
- [ ] Add to CI
- [ ] Deploy (submodule/MCP/package)
- [ ] Monitor telemetry
- [ ] Iterate based on usage

## Benefits

- **Democratize knowledge** - Juniors access senior expertise
- **24/7 availability** - No human bottleneck
- **Consistency** - Same answer every time
- **Scalability** - Unlimited concurrent users
- **AI capability** - Agents gain domain depth
- **Preservation** - Survives employee turnover
- **Validation** - Tests catch knowledge drift

## See Also

- [Autonomous Quality Enforcement](autonomous-quality-enforcement.md)
- [Multi-Agent Code Review](multi-agent-code-review.md)
- [Codebase Agent](codebase-agent.md)
