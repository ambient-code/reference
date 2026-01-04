# Security Standards

## Input Validation

### Principle: Validate at Boundaries

**Validate external input at API boundary only**:

- Use Pydantic models for all request payloads
- Validation happens automatically in route parameters
- Trust internal code - don't re-validate

```python
# API Layer - automatic validation
@router.post("/", response_model=Item)
def create_item(data: ItemCreate):  # Pydantic validates here
    return item_service.create_item(data)
```

### Field Validators

Use Pydantic field validators for sanitization:

```python
from pydantic import BaseModel, field_validator
from app.core.security import sanitize_string

class ItemCreate(BaseModel):
    name: str

    @field_validator("name")
    @classmethod
    def sanitize_name(cls, v: str) -> str:
        return sanitize_string(v, max_length=200)
```

## Sanitization

### Location

All sanitization functions in `app/core/security.py`.

### Functions

**`sanitize_string(value, max_length)`**:

- Remove control characters
- Trim whitespace
- Enforce length limits

**`validate_slug(value)`**:

- Ensure URL-safe (lowercase, numbers, hyphens only)
- No leading/trailing hyphens
- No consecutive hyphens

### Usage Pattern

```python
# In Pydantic model
@field_validator("description")
@classmethod
def sanitize_description(cls, v: str | None) -> str | None:
    if v is None:
        return None
    return sanitize_string(v, max_length=1000)
```

## Secrets Management

### Never Commit Secrets

- `.env` files in `.gitignore`
- No hardcoded credentials
- No API keys in code
- No passwords in version control

### Environment Variables

Use Pydantic Settings:

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    database_url: str = "sqlite:///./test.db"
    secret_key: str

    class Config:
        env_file = ".env"

settings = Settings()
```

### Container Secrets

Pass as environment variables at runtime:

```bash
podman run -e SECRET_KEY=xxx myapp
```

## OWASP Top 10 Prevention

### Light Touch Approach

**Don't overrotate** - apply security proportionally:

1. **SQL Injection**: Not applicable (in-memory storage)
2. **XSS**: Sanitize strings, FastAPI encodes JSON automatically
3. **Command Injection**: Validate file paths, no shell execution
4. **Secrets Exposure**: Environment variables only
5. **Broken Access Control**: Not in reference (show pattern if needed)

### Input Validation Rules

**String fields**:

- Max length limits
- Character allowlist (for slugs)
- Trim whitespace
- Remove control characters

**Numeric fields**:

- Min/max validation
- Type checking (Pydantic automatic)

**Examples**:

```python
# String with length limit
name: str = Field(..., min_length=1, max_length=200)

# Slug with pattern
slug: str = Field(..., pattern=r"^[a-z0-9-]+$")

# Optional with default
description: str | None = Field(None, max_length=1000)
```

## Container Security

### Dockerfile Best Practices

```dockerfile
# Minimal base image
FROM python:3.11-slim

# Non-root user
RUN useradd -m -u 1000 app
USER app

# Copy with ownership
COPY --chown=app:app . /app

# No secrets in layers
# Use runtime env vars instead
```

### Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"
```

## Security Testing

### Static Analysis

```bash
# Run Bandit for security issues
bandit -r app/

# Check dependencies for vulnerabilities
safety check
```

### CI Integration

Both run in `.github/workflows/security.yml`:

- Weekly schedule
- On push/PR
- Fail build on HIGH severity

## Common Mistakes

**DON'T**:

- ❌ Validate the same data multiple times
- ❌ Sanitize in both model and service layer
- ❌ Trust user input without validation
- ❌ Commit `.env` files
- ❌ Hardcode secrets

**DO**:

- ✅ Validate once at API boundary
- ✅ Use Pydantic validators
- ✅ Keep secrets in environment
- ✅ Run security scans in CI
- ✅ Keep approach proportional (light touch)
