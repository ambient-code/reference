# Testing Patterns

**Test pyramid: many unit, some integration, few E2E.**

---

## Quick Start

```bash
mkdir -p tests/unit tests/integration tests/e2e
```

```ini
# pytest.ini
[pytest]
testpaths = tests
addopts = --cov=app --cov-report=term-missing --cov-fail-under=80
```

---

## Test Levels

| Level | Location | Purpose | Speed |
|-------|----------|---------|-------|
| **Unit** | `tests/unit/` | Service layer logic | Fast |
| **Integration** | `tests/integration/` | API endpoints | Medium |
| **E2E** | `tests/e2e/` | Critical user journeys | Slow |

---

## Unit Tests

Test business logic in isolation. No HTTP, no database.

```python
# tests/unit/test_item_service.py
def test_create_item():
    service = ItemService()
    item = service.create(ItemCreate(name="Test", slug="test"))
    
    assert item.name == "Test"
    assert item.id is not None

def test_duplicate_slug_raises():
    service = ItemService()
    service.create(ItemCreate(name="A", slug="test"))
    
    with pytest.raises(ValueError, match="already exists"):
        service.create(ItemCreate(name="B", slug="test"))
```

---

## Integration Tests

Test API endpoints with TestClient.

```python
# tests/integration/test_api.py
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_item_returns_201():
    response = client.post("/items", json={"name": "Test", "slug": "test"})
    assert response.status_code == 201

def test_not_found_returns_404():
    response = client.get("/items/99999")
    assert response.status_code == 404
```

---

## E2E Tests

Test complete user journeys. Keep minimal.

```python
# tests/e2e/test_item_lifecycle.py
@pytest.mark.e2e
def test_create_read_update_delete(client):
    # Create
    resp = client.post("/items", json={"name": "Widget", "slug": "widget"})
    item_id = resp.json()["id"]
    
    # Read
    assert client.get(f"/items/{item_id}").status_code == 200
    
    # Update
    client.patch(f"/items/{item_id}", json={"name": "Updated"})
    
    # Delete
    assert client.delete(f"/items/{item_id}").status_code == 204
```

---

## Coverage

| Priority | What | Target |
|----------|------|--------|
| High | Business logic, security | 100% |
| Medium | API endpoints | 90% |
| Low | Config, utilities | 60% |

Target 80%+ overall. Don't chase 100%.

---

## Parametrize

```python
@pytest.mark.parametrize("slug,valid", [
    ("valid-slug", True),
    ("UPPERCASE", False),
    ("-starts-hyphen", False),
])
def test_slug_validation(slug, valid):
    if valid:
        assert validate_slug(slug) == slug
    else:
        with pytest.raises(ValueError):
            validate_slug(slug)
```

---

## Related Patterns

- [Layered Architecture](layered-architecture.md) - What each test level covers
- [Autonomous Quality Enforcement](autonomous-quality-enforcement.md) - Running tests in CI
