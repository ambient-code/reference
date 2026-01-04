# Testing Patterns

## Test Structure

```text
tests/
├── conftest.py          # Shared fixtures
├── unit/                # Service layer tests
│   └── test_item_service.py
├── integration/         # API endpoint tests
│   └── test_api.py
└── e2e/                 # End-to-end tests
    └── test_cba_workflow.py
```text

## Unit Tests

### Purpose

Test service layer in isolation without HTTP or external dependencies.

### Pattern: Arrange-Act-Assert

```python
def test_create_item():
    # Arrange - setup test data and conditions
    service = ItemService()
    data = ItemCreate(name="Test", slug="test")

    # Act - execute the operation
    result = service.create_item(data)

    # Assert - verify the outcome
    assert result.name == "Test"
    assert result.slug == "test"
    assert result.id == 1
```text

### Coverage

- Business logic
- Edge cases (empty, max length, duplicates)
- Error conditions
- Pagination
- Data validation

### Example: `tests/unit/test_item_service.py`

```python
def test_create_duplicate_slug():
    service = ItemService()
    data = ItemCreate(name="Test", slug="test")
    service.create_item(data)

    # Attempting to create duplicate should raise ValueError
    with pytest.raises(ValueError, match="already exists"):
        service.create_item(data)
```text

## Integration Tests

### Purpose

Test API endpoints with full HTTP request/response cycle.

### Tool: FastAPI TestClient

```python
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_item_endpoint():
    response = client.post(
        "/api/v1/items",
        json={"name": "Test", "slug": "test"}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test"
```text

### Coverage

- HTTP status codes
- Request/response serialization
- Error responses (404, 409, 422)
- Input validation
- Content negotiation

### Error Cases

```python
def test_create_item_duplicate_returns_409():
    # Create first item
    client.post("/api/v1/items", json={"name": "Test", "slug": "test"})

    # Attempt duplicate
    response = client.post("/api/v1/items", json={"name": "Test2", "slug": "test"})
    assert response.status_code == 409
    assert "already exists" in response.json()["detail"]
```text

## Fixtures

### Location: `tests/conftest.py`

```python
import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.models.item import ItemCreate

@pytest.fixture
def client():
    """FastAPI test client."""
    return TestClient(app)

@pytest.fixture
def sample_item():
    """Sample item for testing."""
    return ItemCreate(
        name="Sample Item",
        slug="sample-item",
        description="A sample item for testing"
    )

@pytest.fixture
def created_items(client, sample_item):
    """Create multiple items for testing."""
    items = []
    for i in range(5):
        data = sample_item.model_copy()
        data.slug = f"item-{i}"
        response = client.post("/api/v1/items", json=data.model_dump())
        items.append(response.json())
    return items
```text

### Fixture Scopes

- `function` (default): New instance per test
- `module`: Shared across tests in module
- `session`: Shared across entire test session

## E2E Tests

### Purpose

Test complete workflows including CBA automation.

### File: `tests/e2e/test_cba_workflow.py`

**Status**: OUTLINE ONLY (requires GitHub API credentials)

```python
@pytest.mark.e2e
def test_cba_issue_to_pr_workflow():
    """
    Test Codebase Agent issue-to-PR workflow.

    Workflow:
    1. Create GitHub issue with clear acceptance criteria
    2. Apply 'cba' label to trigger agent
    3. Wait for CBA to create PR
    4. Verify PR contents match issue requirements
    5. Verify all CI checks pass
    6. Clean up (close PR, delete branch)
    """
    # This is an outline - requires GitHub API setup
    pass
```text

## Mocking

### When to Mock

- External APIs
- Database connections (not applicable in this example)
- File system operations
- Time-dependent operations

### Example: Mocking Time

```python
from unittest.mock import patch
from datetime import datetime

def test_item_timestamps():
    with patch('app.services.item_service.datetime') as mock_dt:
        fixed_time = datetime(2025, 1, 1, 12, 0, 0)
        mock_dt.utcnow.return_value = fixed_time

        service = ItemService()
        item = service.create_item(ItemCreate(name="Test", slug="test"))

        assert item.created_at == fixed_time
```text

## Coverage Configuration

### pytest.ini

```ini
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = """
    --cov=app
    --cov-report=html
    --cov-report=term-missing
    --cov-fail-under=80
"""
```text

### Coverage Goals

- **Minimum**: 80% overall (enforced in CI)
- **Critical paths**: 100% (business logic, security functions)
- **Configuration**: Excluded

## Test Naming

**Convention**: `test_<what>_<condition>_<expected>`

```python
# Good
def test_create_item_valid_data_returns_item()
def test_get_item_not_found_returns_404()
def test_list_items_pagination_returns_correct_subset()

# Avoid
def test_item()  # Too vague
def test_1()     # Non-descriptive
```text

## Parametrize for Multiple Cases

```python
@pytest.mark.parametrize("slug,expected_error", [
    ("", "cannot be empty"),
    ("-test", "cannot start"),
    ("test-", "cannot end"),
    ("test--name", "consecutive hyphens"),
    ("Test", "lowercase"),
])
def test_validate_slug_invalid_formats(slug, expected_error):
    with pytest.raises(ValueError, match=expected_error):
        validate_slug(slug)
```text

## Running Tests

```bash
# All tests
pytest

# Specific file
pytest tests/unit/test_item_service.py

# Specific test
pytest tests/unit/test_item_service.py::test_create_item

# With coverage
pytest --cov=app

# Verbose
pytest -v

# Stop on first failure
pytest -x
```text

## CI Integration

Tests run in `.github/workflows/ci.yml`:

- Python 3.11 + 3.12 matrix
- All linters before tests
- Coverage uploaded to Codecov
- Fail build if tests fail or coverage < 80%
