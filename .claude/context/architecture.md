# Architecture Patterns

## Layered Architecture

The application follows a strict layered architecture with clear separation of concerns:

```text
┌─────────────────────────────────┐
│      API Layer (FastAPI)        │  HTTP routes, request/response models
├─────────────────────────────────┤
│     Service Layer (Logic)       │  Business rules, orchestration
├─────────────────────────────────┤
│    Model Layer (Pydantic)       │  Data validation, serialization
├─────────────────────────────────┤
│   Core Layer (Utilities)        │  Config, security, logging
└─────────────────────────────────┘
```text

## Layer Responsibilities

### API Layer (`app/api/`)

**Purpose**: Handle HTTP concerns

**Files**:

- `health.py` - Health check endpoints
- `v1/items.py` - Resource endpoints

**Responsibilities**:

- Route definitions
- Request/response serialization
- HTTP status codes
- Error responses
- OpenAPI documentation

**Never in API Layer**:

- Business logic
- Database/storage operations
- Complex validation

### Service Layer (`app/services/`)

**Purpose**: Implement business logic

**Files**:

- `item_service.py` - Item business logic

**Responsibilities**:

- CRUD operations
- Business rules
- Data manipulation
- Transaction coordination

**Never in Service Layer**:

- HTTP concerns (status codes, headers)
- Request/response serialization

### Model Layer (`app/models/`)

**Purpose**: Data validation and representation

**Files**:

- `item.py` - Item models (ItemBase, ItemCreate, ItemUpdate, Item)

**Responsibilities**:

- Field validation (Pydantic validators)
- Type annotations
- Serialization rules
- Sanitization (via validators)

**Never in Model Layer**:

- Business logic
- HTTP concerns

### Core Layer (`app/core/`)

**Purpose**: Cross-cutting concerns

**Files**:

- `config.py` - Application settings
- `security.py` - Sanitization, validation utilities
- `logging.py` - Structured logging

**Responsibilities**:

- Configuration management
- Security utilities
- Logging setup
- Shared utilities

## Dependency Flow

```text
API Layer
  ↓ (depends on)
Service Layer
  ↓ (depends on)
Model Layer
  ↓ (depends on)
Core Layer
```text

**Rule**: Higher layers can depend on lower layers, but not vice versa.

## Data Flow Example

Creating an item:

```python
# 1. API Layer receives request
@router.post("/", response_model=Item)
def create_item(data: ItemCreate):  # Pydantic validates here
    # 2. Call service layer
    return item_service.create_item(data)

# 3. Service Layer implements logic
def create_item(self, data: ItemCreate) -> Item:
    # Check business rules
    if data.slug in self._slug_index:
        raise ValueError("Duplicate slug")

    # Create Item model
    item = Item(...)  # Model layer validates

    # Store
    self._items[item.id] = item
    return item
```text

## Common Patterns

### Singleton Services

Services use singleton pattern:

```python
# app/services/item_service.py
item_service = ItemService()

# app/api/v1/items.py
from app.services.item_service import item_service
```text

### Pydantic Validators

Sanitization in model validators:

```python
@field_validator("name")
@classmethod
def sanitize_name(cls, v: str) -> str:
    return sanitize_string(v, max_length=200)
```text

### Error Handling

Service layer raises exceptions, API layer converts to HTTP:

```python
# Service
def create_item(self, data: ItemCreate) -> Item:
    if duplicate:
        raise ValueError("Duplicate")

# API
def create_item(data: ItemCreate) -> Item:
    try:
        return item_service.create_item(data)
    except ValueError as e:
        raise HTTPException(status_code=409, detail=str(e))
```text

## Testing Architecture

- **Unit tests**: Test service layer in isolation
- **Integration tests**: Test API endpoints with TestClient
- **E2E tests**: Test complete workflows (outline only)

Each layer is tested independently with appropriate mocking.
