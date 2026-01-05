# Security Patterns

**Practical protection without over-engineering.**

---

## Overview

!!! note "Section Summary"
    Philosophy: "Validate at boundaries, trust internal code." Most security bugs come from unvalidated user input, hardcoded secrets, and injection attacks. Focus on actual attack vectors.

---

## Quick Start

!!! note "Section Summary"
    Copy security context file. Add Pydantic validation to API models. Move secrets to environment variables. Done.

---

## Input Validation

!!! note "Section Summary"
    Validate all request payloads with Pydantic. Sanitization in model validators. Internal code trusts validated data. Examples of validation patterns.

---

## Sanitization Functions

!!! note "Section Summary"
    sanitize_string() - remove control characters, trim whitespace. validate_slug() - ensure URL-safe identifiers. When to use each.

---

## Secrets Management

!!! note "Section Summary"
    Environment variables only. .env files never committed. Pydantic Settings for config. Container secrets.

---

## What We Don't Do

!!! note "Section Summary"
    No security theater. No excessive validation everywhere. No complex encryption for non-sensitive data. Why less is more.

---

## AI Integration

!!! note "Section Summary"
    How to describe security rules in context files. What the CBA should check. Automated security review in PRs.

---

## Related Patterns

- [Layered Architecture](layered-architecture.md) - Where security boundaries live
- [PR Auto-Review](pr-auto-review.md) - Automated security checks
