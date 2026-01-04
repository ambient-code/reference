# Architecture Decision Records (ADRs)

This directory contains Architecture Decision Records for significant architectural decisions in the Ambient Code Reference Repository.

## What is an ADR?

An ADR documents:

- **Context**: The situation requiring a decision
- **Decision**: The choice made
- **Consequences**: The results, both positive and negative

## Format

ADRs follow this naming convention:

```text
YYYYMMDD-title.md
```

Example: `20251217-use-fastapi.md`

## Template

See `template.md` for the ADR format.

## Creating an ADR

1. Copy `template.md`
2. Rename with date and title
3. Fill in all sections
4. Commit to repository

## Status

ADRs can have these statuses:

- **Proposed**: Under discussion
- **Accepted**: Decision made
- **Deprecated**: No longer recommended
- **Superseded**: Replaced by newer ADR

## Example ADRs

This repository currently has no ADRs (scaffolding only).

When you make architectural decisions, create ADRs for:

- Technology choices (FastAPI, Pydantic, etc.)
- Architecture patterns (layered architecture)
- Security approaches (input validation strategy)
- Testing strategies (pytest, coverage goals)
