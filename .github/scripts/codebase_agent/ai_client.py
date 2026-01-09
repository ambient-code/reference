"""AI client and GitHub API utilities."""
import os
import sys
import requests
from anthropic import Anthropic

try:
    from anthropic import AnthropicVertex

    VERTEX_AVAILABLE = True
except ImportError:
    VERTEX_AVAILABLE = False

# Hardcoded agent context for portability (template-friendly)
AGENT_CONTEXT = """
**Your Role**:
You are the Codebase Agent for this repository. You assist with code reviews,
technical guidance, and maintaining code quality standards.

**Operating Principles**:

1. **Safety First**
   - Show plan before major changes
   - Explain reasoning and alternatives
   - Ask for clarification when requirements are ambiguous

2. **High Signal, Low Noise**
   - Only comment when adding unique value
   - Be concise and get to the point
   - Focus on critical issues, not minor style differences

**Code Review Focus**:
When reviewing code, prioritize:
- **Bugs**: Logic errors, edge cases, error handling
- **Security**: Input validation, OWASP Top 10 vulnerabilities
- **Performance**: Inefficient algorithms, unnecessary operations
- **Style**: Code quality and maintainability
- **Testing**: Coverage, missing test cases

**Feedback Guidelines**:
- Be specific and actionable
- Provide code examples for fixes
- Explain "why" not just "what"
- Prioritize critical issues
- Acknowledge good practices

**Communication Style**:
- Direct and technical (assume user has context)
- Code-focused (show examples, not just descriptions)
- Actionable (always provide next steps)
- Honest (admit uncertainty, ask for clarification)

**What NOT to Do**:
- No generic AI responses or "AI slop"
- Don't state the obvious or add filler content
- Don't make assumptions about ambiguous requirements
- Don't include unnecessary praise or validation
"""


def _get_claude_client():
    """Get Claude client with Vertex AI fallback to Anthropic API.

    Tries Vertex AI first (if GCP_PROJECT_ID set), falls back to Anthropic API.

    Returns:
        Anthropic or AnthropicVertex client

    Raises:
        RuntimeError: If no credentials configured
    """
    # Try Vertex AI first if credentials available
    if VERTEX_AVAILABLE:
        project_id = os.environ.get("GCP_PROJECT_ID")
        region = os.environ.get("GCP_REGION", "us-central1")

        if project_id:
            try:
                return AnthropicVertex(project_id=project_id, region=region)
            except Exception as e:
                print(
                    f"⚠️  Vertex AI unavailable ({e}), falling back to Anthropic API",
                    file=sys.stderr,
                )

    # Fall back to Anthropic API
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise RuntimeError(
            "No AI credentials found. Set either:\n"
            "  - GCP_PROJECT_ID (for Vertex AI), or\n"
            "  - ANTHROPIC_API_KEY (for Anthropic API)"
        )

    return Anthropic(api_key=api_key)


def call_claude(repo_name: str, command: str, url: str) -> str:
    """Call Claude API with context.

    Args:
        repo_name: Repository name (owner/repo)
        command: User command to execute
        url: GitHub issue/PR URL

    Returns:
        AI response text

    Raises:
        RuntimeError: If AI API call fails
    """
    client = _get_claude_client()

    prompt = f"""You are the Codebase Agent for {repo_name}.

{AGENT_CONTEXT}

---

**Current Task**:
Command: {command}
Context: {url}

Provide a helpful, concise response following the operating principles above."""

    try:
        message = client.messages.create(
            model="claude-sonnet-4-5-20250929",
            max_tokens=2000,
            messages=[{"role": "user", "content": prompt}],
        )
        return message.content[0].text
    except Exception as e:
        raise RuntimeError(f"AI API error: {e}")


def post_github_comment(repo: str, issue_number: int, body: str):
    """Post comment to GitHub issue/PR.

    Args:
        repo: Repository name (owner/repo)
        issue_number: Issue or PR number
        body: Comment body text

    Raises:
        requests.HTTPError: If GitHub API call fails
    """
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        raise RuntimeError("GITHUB_TOKEN environment variable not set")

    url = f"https://api.github.com/repos/{repo}/issues/{issue_number}/comments"

    try:
        response = requests.post(
            url,
            headers={
                "Authorization": f"token {token}",
                "Accept": "application/vnd.github.v3+json",
            },
            json={"body": body},
            timeout=30,
        )
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        raise RuntimeError(f"GitHub API error: {e}")
