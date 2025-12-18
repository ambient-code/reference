# Testing Patterns

**Purpose**: Testing best practices and patterns for code validation and quality assurance

**Scope**: General testing principles (template contains no application code)

**Last Updated**: 2025-12-17

---

## Core Testing Principles

### 1. Arrange-Act-Assert (AAA) Pattern

**Principle**: Structure tests in three clear phases.

```python
def test_user_registration():
    # Arrange: Set up test data and dependencies
    user_data = {"email": "test@example.com", "password": "SecurePass123!"}
    mock_db = MockDatabase()

    # Act: Execute the function under test
    result = register_user(user_data, mock_db)

    # Assert: Verify expected outcomes
    assert result.success is True
    assert result.user_id is not None
    assert mock_db.insert_called is True
```

**Benefits**:
- Clear test structure
- Easy to understand what's being tested
- Separates setup from verification

### 2. Test Independence

**Principle**: Each test runs independently without side effects.

**Good** (isolated):
```python
def test_create_user():
    db = create_test_database()  # Fresh database per test
    user = create_user(db, "alice@example.com")
    assert user.email == "alice@example.com"
    cleanup_test_database(db)

def test_delete_user():
    db = create_test_database()  # Independent database
    user = create_user(db, "bob@example.com")
    delete_user(db, user.id)
    assert get_user(db, user.id) is None
    cleanup_test_database(db)
```

**Bad** (coupled):
```python
shared_db = create_database()  # ❌ Shared state

def test_create_user():
    user = create_user(shared_db, "alice@example.com")
    assert user.email == "alice@example.com"

def test_delete_user():
    # ❌ Assumes test_create_user ran first
    user = get_user(shared_db, "alice@example.com")
    delete_user(shared_db, user.id)
```

### 3. Fast Feedback

**Principle**: Tests should run quickly to encourage frequent execution.

**Performance Goals**:
- Unit tests: <1ms per test
- Integration tests: <100ms per test
- Full test suite: <5 minutes

**Optimization Techniques**:
```python
# Use in-memory databases
import sqlite3
db = sqlite3.connect(':memory:')

# Mock external services
@patch('requests.get')
def test_api_call(mock_get):
    mock_get.return_value.json.return_value = {"status": "ok"}
    result = fetch_data()
    assert result["status"] == "ok"

# Parallelize independent tests
pytest -n auto  # Use all CPU cores
```

---

## Test Types and Levels

### Unit Tests

**Purpose**: Test individual functions/methods in isolation.

**Characteristics**:
- No external dependencies (database, network, filesystem)
- Use mocks/stubs for dependencies
- Fast execution (<1ms)
- High coverage (80%+ goal)

**Example**:
```python
def validate_email(email):
    """Validate email format."""
    if not isinstance(email, str):
        return False
    if '@' not in email:
        return False
    local, domain = email.rsplit('@', 1)
    if not local or not domain:
        return False
    return True

# Unit test
def test_validate_email():
    # Valid emails
    assert validate_email("user@example.com") is True
    assert validate_email("user+tag@example.co.uk") is True

    # Invalid emails
    assert validate_email("@example.com") is False
    assert validate_email("user@") is False
    assert validate_email("userexample.com") is False
    assert validate_email(123) is False
```

### Integration Tests

**Purpose**: Test interaction between components.

**Characteristics**:
- Test component integration (database, API, services)
- Use test databases/services
- Slower than unit tests (<100ms)
- Lower coverage (60%+ goal)

**Example**:
```python
def test_user_registration_integration():
    # Arrange: Use test database
    db = create_test_database()
    user_service = UserService(db)

    # Act: Register user (hits database)
    result = user_service.register(
        email="test@example.com",
        password="SecurePass123!"
    )

    # Assert: Verify database state
    assert result.success is True
    stored_user = db.query(User).filter_by(email="test@example.com").first()
    assert stored_user is not None
    assert stored_user.email == "test@example.com"
    assert stored_user.password != "SecurePass123!"  # Hashed

    cleanup_test_database(db)
```

### End-to-End Tests

**Purpose**: Test complete user workflows.

**Characteristics**:
- Test full system flow
- Use realistic environments
- Slowest tests (seconds)
- Minimal coverage (critical paths only)

**Example**:
```python
def test_user_signup_flow():
    # Arrange: Start application
    app = create_test_app()
    client = app.test_client()

    # Act: Complete signup workflow
    # 1. Visit signup page
    response = client.get('/signup')
    assert response.status_code == 200

    # 2. Submit registration form
    response = client.post('/signup', data={
        'email': 'newuser@example.com',
        'password': 'SecurePass123!',
        'password_confirm': 'SecurePass123!'
    })
    assert response.status_code == 302  # Redirect to welcome

    # 3. Verify email sent
    assert len(mail_outbox) == 1
    assert 'Welcome' in mail_outbox[0].subject

    # 4. Confirm email
    token = extract_token(mail_outbox[0].body)
    response = client.get(f'/confirm/{token}')
    assert response.status_code == 200

    # 5. Login with new account
    response = client.post('/login', data={
        'email': 'newuser@example.com',
        'password': 'SecurePass123!'
    })
    assert response.status_code == 302  # Redirect to dashboard
```

---

## Mocking and Stubbing

### When to Mock

**Mock External Dependencies**:
- HTTP APIs (requests, httpx)
- Databases (SQLAlchemy, psycopg2)
- File system operations
- Time-dependent code
- Random number generation

**Don't Mock**:
- Code under test
- Value objects (data classes)
- Pure functions
- Simple utilities

### Mock Patterns

**Mock HTTP Requests**:
```python
from unittest.mock import patch, Mock

@patch('requests.get')
def test_fetch_user_data(mock_get):
    # Arrange: Configure mock response
    mock_response = Mock()
    mock_response.json.return_value = {
        'id': 123,
        'name': 'Alice'
    }
    mock_response.status_code = 200
    mock_get.return_value = mock_response

    # Act
    user = fetch_user_from_api(123)

    # Assert
    assert user['name'] == 'Alice'
    mock_get.assert_called_once_with('https://api.example.com/users/123')
```

**Mock Database**:
```python
class MockDatabase:
    def __init__(self):
        self.data = {}
        self.insert_called = False

    def insert(self, table, record):
        self.insert_called = True
        record_id = len(self.data) + 1
        self.data[record_id] = record
        return record_id

    def get(self, table, record_id):
        return self.data.get(record_id)

def test_save_user():
    # Arrange
    db = MockDatabase()

    # Act
    user_id = save_user(db, {'name': 'Alice'})

    # Assert
    assert db.insert_called is True
    assert db.get('users', user_id)['name'] == 'Alice'
```

**Mock Time**:
```python
from datetime import datetime
from unittest.mock import patch

@patch('datetime.datetime')
def test_is_weekend(mock_datetime):
    # Arrange: Saturday
    mock_datetime.now.return_value = datetime(2024, 1, 6, 10, 0)

    # Act & Assert
    assert is_weekend() is True

    # Arrange: Monday
    mock_datetime.now.return_value = datetime(2024, 1, 8, 10, 0)

    # Act & Assert
    assert is_weekend() is False
```

---

## Fixture Patterns

### pytest Fixtures

**Basic Fixture**:
```python
import pytest

@pytest.fixture
def test_database():
    """Provide test database for each test."""
    db = create_database(':memory:')
    db.execute('CREATE TABLE users (id INT, email TEXT)')
    yield db
    db.close()

def test_insert_user(test_database):
    # test_database automatically provided
    test_database.execute("INSERT INTO users VALUES (1, 'alice@example.com')")
    result = test_database.execute("SELECT * FROM users WHERE id=1").fetchone()
    assert result[1] == 'alice@example.com'
```

**Fixture Scopes**:
```python
@pytest.fixture(scope='function')  # Default: new instance per test
def function_db():
    return create_database()

@pytest.fixture(scope='class')  # One instance per test class
def class_db():
    return create_database()

@pytest.fixture(scope='module')  # One instance per module
def module_db():
    return create_database()

@pytest.fixture(scope='session')  # One instance for entire test session
def session_db():
    return create_database()
```

**Parametrized Fixtures**:
```python
@pytest.fixture(params=['postgresql', 'mysql', 'sqlite'])
def database_type(request):
    return request.param

def test_query_works_on_all_databases(database_type):
    db = connect(database_type)
    result = db.execute("SELECT 1")
    assert result is not None
```

---

## Test Coverage

### Coverage Goals

**Minimum Coverage**:
- Unit tests: 80%+ line coverage
- Integration tests: 60%+ line coverage
- Critical paths: 100% coverage (authentication, payment, security)

**Measuring Coverage**:
```bash
# Python (pytest-cov)
pytest --cov=src --cov-report=html
# Generates htmlcov/index.html

# JavaScript (jest)
jest --coverage
# Generates coverage/index.html
```

### What to Cover

**High Priority** (100% coverage):
- Authentication and authorization
- Payment processing
- Data validation
- Security controls
- Error handling

**Medium Priority** (80% coverage):
- Business logic
- API endpoints
- Database operations
- File processing

**Low Priority** (60% coverage):
- UI rendering
- Logging
- Configuration loading

**Don't Test**:
- Third-party libraries
- Generated code
- Trivial getters/setters

### Coverage Example

```python
def process_payment(amount, card_number, cvv):
    """Process payment (critical function - needs 100% coverage)."""
    # Validate amount
    if amount <= 0:
        raise ValueError("Amount must be positive")

    # Validate card number
    if not validate_card_number(card_number):
        raise ValueError("Invalid card number")

    # Validate CVV
    if not validate_cvv(cvv):
        raise ValueError("Invalid CVV")

    # Process payment
    try:
        result = payment_gateway.charge(amount, card_number, cvv)
    except PaymentGatewayError as e:
        log_payment_error(e)
        raise PaymentFailedError("Payment declined")

    return result

# Tests covering 100% of branches
def test_process_payment_valid():
    result = process_payment(100, '4111111111111111', '123')
    assert result.success is True

def test_process_payment_zero_amount():
    with pytest.raises(ValueError, match="Amount must be positive"):
        process_payment(0, '4111111111111111', '123')

def test_process_payment_negative_amount():
    with pytest.raises(ValueError, match="Amount must be positive"):
        process_payment(-50, '4111111111111111', '123')

def test_process_payment_invalid_card():
    with pytest.raises(ValueError, match="Invalid card number"):
        process_payment(100, 'invalid', '123')

def test_process_payment_invalid_cvv():
    with pytest.raises(ValueError, match="Invalid CVV"):
        process_payment(100, '4111111111111111', 'abc')

def test_process_payment_gateway_failure():
    with patch('payment_gateway.charge', side_effect=PaymentGatewayError()):
        with pytest.raises(PaymentFailedError, match="Payment declined"):
            process_payment(100, '4111111111111111', '123')
```

---

## Test Data Management

### Factories

**Pattern**: Create test data programmatically.

```python
class UserFactory:
    """Generate test users."""

    _counter = 0

    @classmethod
    def create(cls, **kwargs):
        cls._counter += 1
        defaults = {
            'id': cls._counter,
            'email': f'user{cls._counter}@example.com',
            'name': f'User {cls._counter}',
            'is_active': True
        }
        defaults.update(kwargs)
        return User(**defaults)

# Usage
def test_user_creation():
    user1 = UserFactory.create()
    user2 = UserFactory.create(email='custom@example.com')
    user3 = UserFactory.create(is_active=False)

    assert user1.email == 'user1@example.com'
    assert user2.email == 'custom@example.com'
    assert user3.is_active is False
```

### Builders

**Pattern**: Fluent API for complex object construction.

```python
class OrderBuilder:
    """Build test orders."""

    def __init__(self):
        self._items = []
        self._customer = None
        self._shipping_address = None

    def with_customer(self, customer):
        self._customer = customer
        return self

    def with_item(self, product, quantity):
        self._items.append({'product': product, 'quantity': quantity})
        return self

    def with_shipping(self, address):
        self._shipping_address = address
        return self

    def build(self):
        return Order(
            customer=self._customer,
            items=self._items,
            shipping_address=self._shipping_address
        )

# Usage
def test_order_total():
    order = (OrderBuilder()
        .with_customer(UserFactory.create())
        .with_item('Widget', 2)
        .with_item('Gadget', 1)
        .with_shipping('123 Main St')
        .build())

    assert order.total() == 150  # Widget=$50, Gadget=$50
```

---

## Error Testing

### Exception Testing

```python
import pytest

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        result = divide(10, 0)

def test_invalid_input_message():
    with pytest.raises(ValueError, match="Email must contain @"):
        validate_email("invalid.email")

def test_exception_details():
    with pytest.raises(CustomError) as exc_info:
        risky_operation()

    assert exc_info.value.error_code == 'E123'
    assert 'database' in str(exc_info.value)
```

### Error Logging

```python
import logging
from unittest.mock import patch

def test_error_logging():
    with patch('logging.error') as mock_log:
        try:
            risky_operation()
        except Exception:
            pass

        mock_log.assert_called_once()
        assert 'Failed to process' in mock_log.call_args[0][0]
```

---

## Performance Testing

### Timing Assertions

```python
import time

def test_query_performance():
    start = time.perf_counter()
    result = expensive_query()
    duration = time.perf_counter() - start

    assert duration < 0.1  # Must complete in <100ms
    assert len(result) > 0
```

### Load Testing

```python
def test_concurrent_requests():
    """Test handling 100 concurrent requests."""
    import concurrent.futures

    def make_request():
        return api_client.get('/status')

    with concurrent.futures.ThreadPoolExecutor(max_workers=100) as executor:
        futures = [executor.submit(make_request) for _ in range(100)]
        results = [f.result() for f in futures]

    # All requests should succeed
    assert all(r.status_code == 200 for r in results)

    # Response time should be reasonable
    avg_time = sum(r.elapsed.total_seconds() for r in results) / len(results)
    assert avg_time < 0.5  # Average <500ms
```

---

## Test Organization

### Directory Structure

```
tests/
├── unit/               # Unit tests
│   ├── test_models.py
│   ├── test_utils.py
│   └── test_validators.py
├── integration/        # Integration tests
│   ├── test_database.py
│   ├── test_api.py
│   └── test_services.py
├── e2e/               # End-to-end tests
│   ├── test_signup_flow.py
│   └── test_checkout_flow.py
├── fixtures/          # Shared test data
│   ├── users.json
│   └── orders.json
├── conftest.py        # Shared fixtures
└── pytest.ini         # pytest configuration
```

### Naming Conventions

**Test Files**: `test_*.py` or `*_test.py`
**Test Functions**: `test_*`
**Test Classes**: `Test*`

```python
# test_calculator.py
class TestCalculator:
    def test_add_positive_numbers(self):
        assert add(2, 3) == 5

    def test_add_negative_numbers(self):
        assert add(-2, -3) == -5

    def test_subtract_larger_from_smaller(self):
        assert subtract(3, 5) == -2
```

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest pytest-cov

      - name: Run unit tests
        run: pytest tests/unit --cov=src --cov-report=xml

      - name: Run integration tests
        run: pytest tests/integration

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

---

## Best Practices Summary

**DO**:
- ✅ Use Arrange-Act-Assert pattern
- ✅ Keep tests independent
- ✅ Mock external dependencies
- ✅ Aim for 80%+ unit test coverage
- ✅ Test critical paths at 100%
- ✅ Use descriptive test names
- ✅ Run tests in CI/CD

**DON'T**:
- ❌ Share state between tests
- ❌ Test third-party code
- ❌ Write slow tests
- ❌ Skip error cases
- ❌ Ignore flaky tests
- ❌ Mock code under test
- ❌ Commit commented-out tests

---

## References

- [pytest Documentation](https://docs.pytest.org/)
- [unittest.mock](https://docs.python.org/3/library/unittest.mock.html)
- [Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)
- [Given-When-Then](https://martinfowler.com/bliki/GivenWhenThen.html)
