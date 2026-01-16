"""Shared fixtures for testing."""

import pytest


@pytest.fixture
def sample_string():
    """Sample string for testing sanitization."""
    return "Test String"


@pytest.fixture
def dangerous_string():
    """String with dangerous characters for security testing."""
    return "<script>alert('xss')</script>"


@pytest.fixture
def path_traversal_string():
    """String attempting path traversal."""
    return "../../../etc/passwd"


@pytest.fixture
def valid_slug():
    """Valid URL-safe slug."""
    return "valid-slug-123"


@pytest.fixture
def invalid_slugs():
    """List of invalid slugs for testing."""
    return [
        "",           # empty
        "-test",      # starts with hyphen
        "test-",      # ends with hyphen
        "test--name", # consecutive hyphens
        "Test",       # uppercase
        "test name",  # space
        "test@name",  # special char
    ]
