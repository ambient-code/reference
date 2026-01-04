# Tutorial: Building Your First Feature

Learn how to add a new resource to the Ambient Code Reference Repository by building a "Tags" feature.

## Goal

Add a Tags resource that allows:

- Creating tags with name and color
- Listing tags
- Tagging items

## Step 1: Create the Model

Create `app/models/tag.py`:

```python
from pydantic import BaseModel, Field, field_validator

from app.core.security import sanitize_string


class TagBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=50)
    color: str = Field(..., pattern=r"^#[0-9A-Fa-f]{6}$")

    @field_validator("name")
    @classmethod
    def sanitize_name(cls, v: str) -> str:
        return sanitize_string(v, max_length=50)


class TagCreate(TagBase):
    pass


class Tag(TagBase):
    id: int
```

**What we did**:

- Created Pydantic models for validation
- Added sanitization to name field
- Used regex to validate hex color codes

## Step 2: Create the Service

Create `app/services/tag_service.py`:

```python
from app.models.tag import Tag, TagCreate


class TagService:
    def __init__(self) -> None:
        self._tags: dict[int, Tag] = {}
        self._next_id: int = 1

    def create_tag(self, data: TagCreate) -> Tag:
        tag = Tag(id=self._next_id, name=data.name, color=data.color)
        self._tags[tag.id] = tag
        self._next_id += 1
        return tag

    def list_tags(self) -> list[Tag]:
        return list(self._tags.values())


tag_service = TagService()
```

**What we did**:

- Created service with business logic
- Used singleton pattern
- In-memory storage (like items)

## Step 3: Create the API

Create `app/api/v1/tags.py`:

```python
from fastapi import APIRouter, status

from app.models.tag import Tag, TagCreate
from app.services.tag_service import tag_service

router = APIRouter(prefix="/tags", tags=["tags"])


@router.post("/", response_model=Tag, status_code=status.HTTP_201_CREATED)
def create_tag(data: TagCreate) -> Tag:
    return tag_service.create_tag(data)


@router.get("/", response_model=list[Tag])
def list_tags() -> list[Tag]:
    return tag_service.list_tags()
```

**What we did**:

- Created FastAPI router
- Defined POST and GET endpoints
- Connected to service layer

## Step 4: Register the Router

Update `app/main.py`:

```python
from app.api.v1 import items, tags  # Add tags import

# Add this line after items router
app.include_router(tags.router, prefix=settings.api_v1_prefix)
```

**What we did**:

- Imported tags router
- Registered with FastAPI app
- Used API v1 prefix

## Step 5: Write Tests

Create `tests/unit/test_tag_service.py`:

```python
from app.models.tag import TagCreate
from app.services.tag_service import TagService


def test_create_tag():
    service = TagService()
    data = TagCreate(name="Important", color="#ff0000")

    result = service.create_tag(data)

    assert result.id == 1
    assert result.name == "Important"
    assert result.color == "#ff0000"


def test_list_tags():
    service = TagService()
    service.create_tag(TagCreate(name="Tag1", color="#ff0000"))
    service.create_tag(TagCreate(name="Tag2", color="#00ff00"))

    result = service.list_tags()

    assert len(result) == 2
```

Create `tests/integration/test_tags_api.py`:

```python
def test_create_tag(client):
    response = client.post(
        "/api/v1/tags",
        json={"name": "Important", "color": "#ff0000"}
    )

    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Important"
    assert data["color"] == "#ff0000"


def test_list_tags(client):
    client.post("/api/v1/tags", json={"name": "Tag1", "color": "#ff0000"})
    client.post("/api/v1/tags", json={"name": "Tag2", "color": "#00ff00"})

    response = client.get("/api/v1/tags")

    assert response.status_code == 200
    assert len(response.json()) == 2
```

## Step 6: Run Linters

```bash
# Format
black app/ tests/

# Sort imports
isort app/ tests/

# Lint
ruff check app/ tests/
```

Fix any issues reported.

## Step 7: Run Tests

```bash
pytest
```

Ensure all tests pass and coverage is above 80%.

## Step 8: Test the API

Start the server:

```bash
uvicorn app.main:app --reload
```

Create a tag:

```bash
curl -X POST http://localhost:8000/api/v1/tags \
  -H "Content-Type: application/json" \
  -d '{"name": "Important", "color": "#ff0000"}'
```

List tags:

```bash
curl http://localhost:8000/api/v1/tags
```

## What You Learned

✅ **Layered Architecture**:

- Models for validation
- Services for logic
- API for HTTP

✅ **Pydantic Validation**:

- Field constraints
- Regex patterns
- Custom validators

✅ **Testing Strategy**:

- Unit tests for services
- Integration tests for API
- 80%+ coverage

✅ **Code Quality**:

- black formatting
- isort import sorting
- ruff linting

## Next Steps

Try these enhancements:

1. **Add tag deletion**:
   - `DELETE /api/v1/tags/{id}`
   - Service method
   - Tests

2. **Add tag-item relationship**:
   - Update Item model with tags field
   - Add/remove tags from items
   - List items by tag

3. **Add validation**:
   - Prevent duplicate tag names
   - Add color name aliases

4. **Add documentation**:
   - OpenAPI descriptions
   - Example responses
   - Error codes

## Common Issues

**Import errors?**

```python
# Make sure __init__.py exists in all directories
app/api/v1/__init__.py
app/models/__init__.py
```

**Tests failing?**

```bash
# Check service initialization
# Each test should create fresh service instance
service = TagService()
```

**Linter errors?**

```bash
# Run formatters first
black app/ tests/
isort app/ tests/

# Then check linting
ruff check app/ tests/
```
