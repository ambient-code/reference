# API Reference

Complete API documentation for the Ambient Code Reference Repository.

## Base URL

```text
http://localhost:8000
```text

## Authentication

Current version: No authentication required.

Production: Add JWT or OAuth2 as needed.

## Health Endpoints

### GET /health

Health check endpoint.

**Response** (200):

```json
{
  "status": "healthy"
}
```text

### GET /readiness

Kubernetes readiness probe.

**Response** (200):

```json
{
  "status": "ready"
}
```text

### GET /liveness

Kubernetes liveness probe.

**Response** (200):

```json
{
  "status": "alive"
}
```text

## Items Resource

### POST /api/v1/items

Create a new item.

**Request Body**:

```json
{
  "name": "Sample Item",
  "slug": "sample-item",
  "description": "Optional description"
}
```text

**Field Constraints**:

- `name`: 1-200 characters, sanitized
- `slug`: 1-100 characters, lowercase letters/numbers/hyphens only
- `description`: Optional, max 1000 characters

**Response** (201 Created):

```json
{
  "id": 1,
  "name": "Sample Item",
  "slug": "sample-item",
  "description": "Optional description",
  "created_at": "2025-12-17T12:00:00",
  "updated_at": "2025-12-17T12:00:00"
}
```text

**Error Responses**:

409 Conflict (duplicate slug):

```json
{
  "detail": "Item with slug 'sample-item' already exists"
}
```text

422 Validation Error:

```json
{
  "detail": [
    {
      "loc": ["body", "slug"],
      "msg": "Slug must contain only lowercase letters, numbers, and hyphens",
      "type": "value_error"
    }
  ]
}
```text

### GET /api/v1/items

List all items with pagination.

**Query Parameters**:

- `skip`: Number of items to skip (default: 0)
- `limit`: Maximum items to return (default: 100)

**Example**:

```text
GET /api/v1/items?skip=10&limit=20
```text

**Response** (200):

```json
[
  {
    "id": 1,
    "name": "Item 1",
    "slug": "item-1",
    "description": null,
    "created_at": "2025-12-17T12:00:00",
    "updated_at": "2025-12-17T12:00:00"
  },
  {
    "id": 2,
    "name": "Item 2",
    "slug": "item-2",
    "description": "Description",
    "created_at": "2025-12-17T12:01:00",
    "updated_at": "2025-12-17T12:01:00"
  }
]
```text

### GET /api/v1/items/{id}

Get item by ID.

**Path Parameters**:

- `id`: Integer item ID

**Response** (200):

```json
{
  "id": 1,
  "name": "Sample Item",
  "slug": "sample-item",
  "description": null,
  "created_at": "2025-12-17T12:00:00",
  "updated_at": "2025-12-17T12:00:00"
}
```text

**Error Responses**:

404 Not Found:

```json
{
  "detail": "Item not found"
}
```text

### GET /api/v1/items/slug/{slug}

Get item by slug.

**Path Parameters**:

- `slug`: URL-safe slug

**Example**:

```text
GET /api/v1/items/slug/sample-item
```text

**Response** (200):

```json
{
  "id": 1,
  "name": "Sample Item",
  "slug": "sample-item",
  "description": null,
  "created_at": "2025-12-17T12:00:00",
  "updated_at": "2025-12-17T12:00:00"
}
```text

**Error Responses**:

404 Not Found:

```json
{
  "detail": "Item not found"
}
```text

### PATCH /api/v1/items/{id}

Update an existing item.

**Path Parameters**:

- `id`: Integer item ID

**Request Body** (partial update):

```json
{
  "name": "Updated Name",
  "description": "Updated description"
}
```text

**Note**: Only include fields you want to update. Slug cannot be updated.

**Response** (200):

```json
{
  "id": 1,
  "name": "Updated Name",
  "slug": "sample-item",
  "description": "Updated description",
  "created_at": "2025-12-17T12:00:00",
  "updated_at": "2025-12-17T12:05:00"
}
```text

**Error Responses**:

404 Not Found:

```json
{
  "detail": "Item not found"
}
```text

422 Validation Error:

```json
{
  "detail": [
    {
      "loc": ["body", "name"],
      "msg": "String should have at least 1 character",
      "type": "string_too_short"
    }
  ]
}
```text

### DELETE /api/v1/items/{id}

Delete an item.

**Path Parameters**:

- `id`: Integer item ID

**Response** (204 No Content):

No response body.

**Error Responses**:

404 Not Found:

```json
{
  "detail": "Item not found"
}
```text

## Error Codes

| Code | Description | Common Causes |
|------|-------------|---------------|
| 200 | OK | Successful GET/PATCH |
| 201 | Created | Successful POST |
| 204 | No Content | Successful DELETE |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate slug |
| 422 | Validation Error | Invalid request data |
| 500 | Internal Server Error | Server error |

## Rate Limiting

Current version: No rate limiting.

Production: Add rate limiting middleware as needed.

## Versioning

API version: `v1`

All endpoints prefixed with `/api/v1`.

Future versions will use `/api/v2`, etc.

## OpenAPI Documentation

Interactive API documentation:

- **Swagger UI**: <http://localhost:8000/docs>
- **ReDoc**: <http://localhost:8000/redoc>
- **OpenAPI JSON**: <http://localhost:8000/openapi.json>

## Example Workflows

### Create and Retrieve

```bash
# Create item
curl -X POST http://localhost:8000/api/v1/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Test", "slug": "test"}'

# Get by ID
curl http://localhost:8000/api/v1/items/1

# Get by slug
curl http://localhost:8000/api/v1/items/slug/test
```text

### List and Paginate

```bash
# Get first 10 items
curl http://localhost:8000/api/v1/items?limit=10

# Get next 10 items
curl http://localhost:8000/api/v1/items?skip=10&limit=10
```text

### Update and Delete

```bash
# Update item
curl -X PATCH http://localhost:8000/api/v1/items/1 \
  -H "Content-Type: application/json" \
  -d '{"name": "Updated Name"}'

# Delete item
curl -X DELETE http://localhost:8000/api/v1/items/1
```text

## Client Libraries

### Python (httpx)

```python
import httpx

client = httpx.Client(base_url="http://localhost:8000")

# Create item
response = client.post(
    "/api/v1/items",
    json={"name": "Test", "slug": "test"}
)
item = response.json()

# List items
items = client.get("/api/v1/items").json()
```text

### JavaScript (fetch)

```javascript
// Create item
const response = await fetch('http://localhost:8000/api/v1/items', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({name: 'Test', slug: 'test'})
});
const item = await response.json();

// List items
const items = await fetch('http://localhost:8000/api/v1/items')
  .then(r => r.json());
```text

## Testing

Use TestClient for testing:

```python
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_item():
    response = client.post(
        "/api/v1/items",
        json={"name": "Test", "slug": "test"}
    )
    assert response.status_code == 201
```text
