"""Security utilities for input validation and sanitization.

This module provides security functions as documented in the security-patterns.md.
All input validation and sanitization happens at the API boundary.
"""

import re
import os
from typing import Optional


def sanitize_string(value: Optional[str], max_length: int = 200) -> str:
    """
    Sanitize a string by removing dangerous characters.

    Args:
        value: The input string to sanitize
        max_length: Maximum allowed length (default 200)

    Returns:
        Sanitized string with:
        - Control characters removed
        - HTML tags removed
        - Whitespace trimmed
        - Length enforced

    Example:
        >>> sanitize_string("  Hello<script>bad</script>World  ")
        'HelloWorld'
    """
    if value is None:
        return ""

    # Convert to string if needed
    result = str(value)

    # Remove control characters (ASCII 0-31, except tab/newline)
    result = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', result)

    # Remove HTML tags to prevent XSS
    result = re.sub(r'<[^>]+>', '', result)

    # Trim whitespace
    result = result.strip()

    # Enforce max length
    if len(result) > max_length:
        result = result[:max_length]

    return result


def validate_slug(value: str) -> str:
    """
    Validate a URL-safe slug.

    Args:
        value: The slug to validate

    Returns:
        The validated slug (unchanged if valid)

    Raises:
        ValueError: If the slug is invalid

    Valid slugs:
    - Lowercase letters, numbers, and hyphens only
    - Cannot start or end with hyphen
    - Cannot have consecutive hyphens
    - Cannot be empty

    Example:
        >>> validate_slug("valid-slug-123")
        'valid-slug-123'
        >>> validate_slug("Invalid!")
        ValueError: Slug contains invalid characters
    """
    if not value:
        raise ValueError("Slug cannot be empty")

    if value.startswith('-'):
        raise ValueError("Slug cannot start with hyphen")

    if value.endswith('-'):
        raise ValueError("Slug cannot end with hyphen")

    if '--' in value:
        raise ValueError("Slug cannot contain consecutive hyphens")

    if value != value.lower():
        raise ValueError("Slug must be lowercase")

    # Check for valid characters (lowercase, numbers, hyphens)
    if not re.match(r'^[a-z0-9-]+$', value):
        raise ValueError("Slug contains invalid characters (only lowercase letters, numbers, and hyphens allowed)")

    return value


def sanitize_path(path: str) -> str:
    """
    Sanitize a file path to prevent path traversal attacks.

    Args:
        path: The file path to sanitize

    Returns:
        Sanitized path with:
        - Path traversal sequences removed
        - Null bytes removed
        - Multiple slashes normalized

    Example:
        >>> sanitize_path("../../../etc/passwd")
        'etc/passwd'
        >>> sanitize_path("docs//file.md")
        'docs/file.md'
    """
    if not path:
        return ""

    # Remove null bytes
    result = path.replace('\x00', '')

    # Normalize path separators
    result = result.replace('\\', '/')

    # Remove path traversal sequences
    while '..' in result:
        result = result.replace('..', '')

    # Normalize multiple slashes
    while '//' in result:
        result = result.replace('//', '/')

    # Remove leading slash to ensure relative path
    result = result.lstrip('/')

    return result


def validate_environment_secret(name: str) -> Optional[str]:
    """
    Safely retrieve a secret from environment variables.

    Args:
        name: The environment variable name

    Returns:
        The secret value, or None if not set

    Note:
        This function demonstrates the secrets management pattern:
        - Secrets should ONLY come from environment variables
        - Never hardcode secrets in source code
        - Use .env files (in .gitignore) for local development

    Example:
        >>> validate_environment_secret("API_KEY")
        'secret-value-from-env'
    """
    return os.environ.get(name)
