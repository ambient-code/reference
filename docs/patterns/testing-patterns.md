# Testing Patterns

**Test pyramid approach with clear responsibilities.**

---

## Overview

!!! note "Section Summary"
    Three levels: unit (many, fast), integration (some, medium), E2E (few, slow). Each level has clear responsibilities. 80%+ coverage target without chasing 100%.

---

## Quick Start

!!! note "Section Summary"
    Copy testing context file. Set up tests/ directory structure. Configure pytest. Run first tests.

---

## Unit Tests

!!! note "Section Summary"
    Test service layer in isolation. Mock external dependencies. Arrange-Act-Assert pattern. Location: tests/unit/. What to test, what not to test.

---

## Integration Tests

!!! note "Section Summary"
    Test API endpoints with TestClient. Real request/response cycle. Database fixtures if applicable. Location: tests/integration/. When integration tests are better than unit tests.

---

## E2E Tests

!!! note "Section Summary"
    Test complete workflows. CBA automation scenarios. Location: tests/e2e/. Why to keep these minimal.

---

## Coverage Philosophy

!!! note "Section Summary"
    Target 80%+ coverage. Focus on critical paths. Don't chase 100% (diminishing returns). How to identify critical paths.

---

## AI Test Generation

!!! note "Section Summary"
    How CBA generates tests. Test patterns in context files. Review process for AI-generated tests.

---

## Related Patterns

- [Layered Architecture](layered-architecture.md) - What each test level covers
- [Autonomous Quality Enforcement](autonomous-quality-enforcement.md) - Running tests in CBA
