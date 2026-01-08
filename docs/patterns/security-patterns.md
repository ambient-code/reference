# Security Patterns

**Validate at boundaries, trust internal code.**

---

## Quick Start

1. Use Pydantic for all API inputs
2. Move secrets to environment variables
3. Add `.env` to `.gitignore`

---

## Input Validation

Validate once at API boundary:

```python
from pydantic import BaseModel, Field, field_validator

class ItemCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    slug: str = Field(..., pattern=r"^[a-z0-9-]+$")

    @field_validator("name")
    @classmethod
    def sanitize_name(cls, v: str) -> str:
        return sanitize_string(v, max_length=200)
```

Don't re-validate in service layer—data is already clean.

---

## Sanitization

```python
# app/core/security.py
import re

def sanitize_string(value: str, max_length: int = 1000) -> str:
    """Remove control chars, trim, enforce length."""
    cleaned = re.sub(r"[\x00-\x1f\x7f-\x9f]", "", value)
    return cleaned.strip()[:max_length]

def validate_slug(value: str) -> str:
    """Validate URL-safe slug."""
    if not re.match(r"^[a-z0-9]+(-[a-z0-9]+)*$", value):
        raise ValueError("Invalid slug")
    return value
```

---

## Secrets Management

```python
# app/core/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str
    secret_key: str

    class Config:
        env_file = ".env"
```

| Environment | How to pass secrets |
|-------------|---------------------|
| Local dev | `.env` file (never commit) |
| Container | `-e SECRET_KEY=xxx` |
| CI/CD | GitHub Actions secrets |

---

## Common Vulnerabilities

| Risk | Prevention |
|------|------------|
| SQL Injection | Use ORM or parameterized queries |
| Command Injection | `subprocess.run(["cmd", arg])` not `os.system(f"cmd {arg}")` |
| XSS | FastAPI auto-escapes JSON |
| Secrets in code | Environment variables only |

---

## What NOT to Do

- Don't validate same data in multiple layers
- Don't encrypt non-sensitive config
- Don't commit `.env` files "just for testing"

---

## Related Patterns

- [PR Auto-Review](pr-auto-review.md) - Automated security checks
