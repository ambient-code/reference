#!/usr/bin/env python3
"""Codebase Agent - AI-powered code review assistant."""
import sys
import json
from .github_parser import parse_github_context, extract_command
from .ai_client import call_claude, post_github_comment


def main():
    """Main entry point."""
    try:
        # Parse GitHub context from argument
        context = parse_github_context(sys.argv[1])

        # Extract command
        command = extract_command(context)

        # Call AI
        response = call_claude(
            repo_name=context["repository"], command=command, url=context["url"]
        )

        # Post comment
        post_github_comment(
            repo=context["repository"],
            issue_number=context["number"],
            body=f"## 🤖 Codebase Agent\n\n{response}",
        )

        print(f"✅ Posted response to {context['url']}")

    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
