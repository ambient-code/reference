"""Unit tests for security functions."""

import pytest
from src.core.security import sanitize_string, validate_slug, sanitize_path


class TestSanitizeString:
    """Tests for sanitize_string function."""

    def test_removes_control_characters(self):
        """Control characters should be removed."""
        # Arrange
        input_str = "Hello\x00World\x1f"

        # Act
        result = sanitize_string(input_str)

        # Assert
        assert result == "HelloWorld"

    def test_trims_whitespace(self):
        """Leading and trailing whitespace should be trimmed."""
        # Arrange
        input_str = "  Hello World  "

        # Act
        result = sanitize_string(input_str)

        # Assert
        assert result == "Hello World"

    def test_enforces_max_length(self):
        """String should be truncated to max_length."""
        # Arrange
        input_str = "A" * 300

        # Act
        result = sanitize_string(input_str, max_length=200)

        # Assert
        assert len(result) == 200

    def test_handles_none(self):
        """None input should return empty string."""
        # Act
        result = sanitize_string(None)

        # Assert
        assert result == ""

    def test_removes_html_tags(self):
        """HTML tags should be removed to prevent XSS."""
        # Arrange
        input_str = "<script>alert('xss')</script>Hello"

        # Act
        result = sanitize_string(input_str)

        # Assert
        assert "<script>" not in result
        assert "Hello" in result


class TestValidateSlug:
    """Tests for validate_slug function."""

    def test_valid_slug_passes(self):
        """Valid slugs should pass validation."""
        # Arrange
        slug = "valid-slug-123"

        # Act
        result = validate_slug(slug)

        # Assert
        assert result == slug

    def test_empty_slug_raises(self):
        """Empty slug should raise ValueError."""
        with pytest.raises(ValueError, match="cannot be empty"):
            validate_slug("")

    def test_leading_hyphen_raises(self):
        """Slug starting with hyphen should raise ValueError."""
        with pytest.raises(ValueError, match="cannot start with hyphen"):
            validate_slug("-test")

    def test_trailing_hyphen_raises(self):
        """Slug ending with hyphen should raise ValueError."""
        with pytest.raises(ValueError, match="cannot end with hyphen"):
            validate_slug("test-")

    def test_consecutive_hyphens_raises(self):
        """Slug with consecutive hyphens should raise ValueError."""
        with pytest.raises(ValueError, match="consecutive hyphens"):
            validate_slug("test--name")

    def test_uppercase_raises(self):
        """Slug with uppercase should raise ValueError."""
        with pytest.raises(ValueError, match="lowercase"):
            validate_slug("Test")

    def test_special_characters_raises(self):
        """Slug with special characters should raise ValueError."""
        with pytest.raises(ValueError, match="invalid characters"):
            validate_slug("test@name")


class TestSanitizePath:
    """Tests for sanitize_path function."""

    def test_blocks_path_traversal(self):
        """Path traversal attempts should be blocked."""
        # Arrange
        dangerous_path = "../../../etc/passwd"

        # Act
        result = sanitize_path(dangerous_path)

        # Assert
        assert ".." not in result

    def test_allows_valid_path(self):
        """Valid paths should pass through."""
        # Arrange
        valid_path = "docs/patterns/security.md"

        # Act
        result = sanitize_path(valid_path)

        # Assert
        assert result == valid_path

    def test_normalizes_slashes(self):
        """Multiple slashes should be normalized."""
        # Arrange
        path = "docs//patterns///file.md"

        # Act
        result = sanitize_path(path)

        # Assert
        assert "//" not in result

    def test_removes_null_bytes(self):
        """Null bytes should be removed."""
        # Arrange
        path = "docs/file\x00.md"

        # Act
        result = sanitize_path(path)

        # Assert
        assert "\x00" not in result
