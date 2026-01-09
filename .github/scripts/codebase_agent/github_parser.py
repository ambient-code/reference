"""GitHub context parsing utilities."""
import json


def parse_github_context(context_json: str) -> dict:
    """Parse GitHub Actions context.

    Args:
        context_json: JSON string of GitHub context

    Returns:
        Dict with repository, number, url, and event

    Raises:
        ValueError: If no issue or PR found in context
    """
    context = json.loads(context_json)

    # Extract number and URL
    if "pull_request" in context["event"]:
        number = context["event"]["pull_request"]["number"]
        url = context["event"]["pull_request"]["html_url"]
    elif "issue" in context["event"]:
        number = context["event"]["issue"]["number"]
        url = context["event"]["issue"]["html_url"]
    else:
        raise ValueError("No issue or PR found in context")

    return {
        "repository": context["repository"],
        "number": number,
        "url": url,
        "event": context["event"],
    }


def extract_command(context: dict) -> str:
    """Extract command from @cba mention or labels.

    Args:
        context: Parsed GitHub context from parse_github_context()

    Returns:
        Command string to execute
    """
    # Check for @cba mention in comment
    if "comment" in context["event"]:
        body = context["event"]["comment"]["body"]
        if "@cba" in body:
            command = body.split("@cba", 1)[1].strip()
            return command if command else "review this code"

    # Default command
    return "review this code"
