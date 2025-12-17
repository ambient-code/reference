# Project Board & Task Tracking

**Purpose**: Define work package organization and progress tracking for the Ambient Code Reference Repository

**Team Structure**: 3 parallel workstreams during Phase 3

---

## Work Package Boundaries

### Stream 1: Documentation Team

**Responsibility**: Create all dual documentation pairs and comparison system

**Team Size**: 2 people

**Deliverables**:
- All `docs/*.md` and `docs/*-terry.md` pairs
- Comparison webpage (`docs/comparison/index.html`)
- Adoption guides (`docs/adoption/*.md`)
- Development documentation

**Key Files**:
- `docs/quickstart.md` + `docs/quickstart-terry.md`
- `docs/architecture.md` + `docs/architecture-terry.md`
- `docs/tutorial.md` + `docs/tutorial-terry.md`
- `docs/api-reference.md` + `docs/api-reference-terry.md`
- `docs/contributing-terry.md`
- `docs/deployment.md` + `docs/deployment-terry.md`
- `docs/development.md` + `docs/development-terry.md`
- `docs/agent-workflow.md` + `docs/agent-workflow-terry.md`
- `docs/comparison/index.html`

**Success Criteria**:
- All doc pairs exist and pass `check-doc-pairs.sh`
- Comparison webpage loads locally (file:// protocol)
- Clear style differences visible between standard and Terry versions
- All documentation follows STYLE_GUIDE.md

---

### Stream 2: Agent Configuration Team

**Responsibility**: Build complete Codebase Agent configuration with modular context

**Team Size**: 2 people

**Deliverables**:
- Agent personality definition
- Modular context files (architecture, security, testing)
- Agent workflow diagram
- Command definitions

**Key Files**:
- `.claude/agents/codebase-agent.md`
- `.claude/context/architecture.md`
- `.claude/context/security-standards.md`
- `.claude/context/testing-patterns.md`
- `.claude/commands/quickstart.md`
- `docs/diagrams/agent-workflow.mmd`

**Success Criteria**:
- Each context file independently usable (buffet approach)
- No "Amber" terminology (grep verification)
- Agent workflow diagram validates with mmdc
- Agent configuration works in test environment

---

### Stream 3: CI/CD & Infrastructure Team

**Responsibility**: Complete GitHub template configuration and automation workflows

**Team Size**: 1-2 people

**Deliverables**:
- GitHub template configuration
- CI/CD workflows (validation, security, demo rebuild)
- Automation scripts
- Infrastructure diagrams

**Key Files**:
- `.github/ISSUE_TEMPLATE/bug_report.yml`
- `.github/ISSUE_TEMPLATE/feature_request.yml`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/workflows/validate-docs.yml`
- `.github/workflows/security-checks.yml`
- `.github/workflows/rebuild-demos.yml`
- `scripts/lint-all.sh`
- `docs/diagrams/buffet-approach.mmd`
- `docs/diagrams/ci-cd-pipeline.mmd`

**Success Criteria**:
- "Use this template" button functional
- All workflows pass on test commits
- Security checks prevent violations (no app code, no secrets)
- Diagrams validate with mmdc

---

## Task Organization

### Task Naming Convention

**Format**: `[TaskID] [Flags] Description`

**Flags**:
- `[P]` = Parallelizable within phase
- `[US#]` = Associated with User Story # (US1-US6)

**Examples**:
- `T015 [P] [US1] Create docs/quickstart.md`
- `T038 [P] [US3] Create .claude/agents/codebase-agent.md`
- `T022 [P] [US1] Create .github/workflows/validate-docs.yml`

### Task States

**States**:
- `[ ]` = Pending (not started)
- `[~]` = In Progress
- `[x]` = Complete

**Example**:
```markdown
- [ ] T015 [P] [US1] Create docs/quickstart.md
- [~] T016 [P] [US1] Create docs/quickstart-terry.md
- [x] T000 Create docs/STYLE_GUIDE.md
```

---

## Daily Standup Format

### Per-Stream Check-In (5 minutes each)

**Stream 1 (Docs)**:
- Completed yesterday: [Task IDs]
- Working today: [Task IDs]
- Blockers: [Issues, dependencies]
- Style guide questions/clarifications

**Stream 2 (Agent)**:
- Completed yesterday: [Task IDs]
- Working today: [Task IDs]
- Blockers: [Issues, dependencies]
- Agent testing results

**Stream 3 (CI/CD)**:
- Completed yesterday: [Task IDs]
- Working today: [Task IDs]
- Blockers: [Issues, dependencies]
- Workflow validation status

### Integration Points

**Question**: "Any cross-stream dependencies discovered?"

**Examples**:
- Documentation needs diagram from Stream 2
- CI/CD workflow needs to validate doc pairs from Stream 1
- Agent config references docs from Stream 1

**Resolution**: Agree on interface/handoff timing

---

## Pull Request Workflow

### Branch Strategy

**Pattern**: `feature/{stream}/{task-id}-{short-description}`

**Examples**:
- `feature/docs/T015-quickstart-standard`
- `feature/agent/T038-codebase-agent-config`
- `feature/cicd/T022-validate-docs-workflow`

### PR Checklist (from template)

Every PR must check:
- [ ] Dual documentation pairs created (if applicable)
- [ ] Mermaid diagrams validated with mmdc (if applicable)
- [ ] Terry version reviewed for accessibility (if applicable)
- [ ] No Red Hat branding
- [ ] No "Amber" terminology (use "Codebase Agent" or "CBA")
- [ ] CI checks passing
- [ ] Follows STYLE_GUIDE.md (for documentation)

### Review Assignments

**Stream 1 (Docs)**:
- Technical review: Any team member
- Terry review: Designated Terry expert (ensures accessibility)
- Style review: Check against STYLE_GUIDE.md

**Stream 2 (Agent)**:
- Agent functionality review: Test in isolated project
- Terminology review: Grep for "Amber"
- Modularity review: Verify independent usability

**Stream 3 (CI/CD)**:
- Workflow review: Test on branch
- Security review: Verify checks work
- Diagram review: Validate with mmdc

---

## Progress Tracking

### Weekly Milestones

**Week 1: Foundation**
- [ ] Phase 0 complete (style guide, project board)
- [ ] Phase 1 complete (repository structure)
- [ ] Phase 2 complete (scripts, first diagram, security foundation)
- **Deliverable**: Working template structure

**Week 2-3: Parallel Streams**
- [ ] Stream 1: 50% of doc pairs complete
- [ ] Stream 2: Agent config and context files complete
- [ ] Stream 3: GitHub template config and core workflows complete
- **Mid-point check**: Integration test (streams can reference each other's work)

**Week 3: Integration**
- [ ] All streams complete (Phase 3)
- [ ] Phase 4 tutorials recorded
- **Deliverable**: Complete documentation + agent + automation

**Week 4: Polish**
- [ ] Phase 5 polish complete
- [ ] All validation streams pass
- **Deliverable**: Production-ready template

### Burndown Tracking

**Metrics**:
- Tasks completed per day
- Tasks remaining (total and per stream)
- Blocked tasks (with reasons)
- Validation failures (track and resolve)

**Target Velocity**:
- Phase 2: 2-3 tasks/day (foundation is sequential)
- Phase 3: 6-8 tasks/day (3 streams parallel)
- Phase 4: 3-4 tasks/day (tutorial integration)
- Phase 5: 5-6 tasks/day (parallel validation)

---

## Quality Gates

### Phase Completion Criteria

**Phase 0 (Pre-Work)**:
- [ ] STYLE_GUIDE.md exists and is comprehensive
- [ ] PROJECT_BOARD.md defines clear work packages
- **Gate**: Team reviews and approves standards

**Phase 1 (Setup)**:
- [ ] Git repository initialized
- [ ] Directory structure matches plan.md
- [ ] GitHub template button functional
- **Gate**: Structure validation script passes

**Phase 2 (Foundation)**:
- [ ] All scripts exist and are executable
- [ ] First diagram (architecture.mmd) validates
- [ ] Security workflow runs
- [ ] Setup script completes in <10 minutes
- **Gate**: Foundation validation suite passes

**Phase 3 (Parallel Streams)**:
- [ ] Stream 1: All doc pairs exist, comparison page loads
- [ ] Stream 2: Agent config works, no "Amber" terminology
- [ ] Stream 3: Template functional, workflows pass
- **Gate**: Independent stream validation + integration test

**Phase 4 (Tutorials)**:
- [ ] All .cast files recorded
- [ ] Auto-rebuild workflow configured
- [ ] Tutorials play correctly
- **Gate**: Demo walkthrough successful

**Phase 5 (Polish)**:
- [ ] All 4 supporting docs created
- [ ] 4 validation streams pass
- [ ] Buffet tests pass (5 features extracted independently)
- **Gate**: All 14 success criteria met

---

## Risk Management

### Common Blockers & Resolutions

**Blocker**: "Terry version quality inconsistent"
**Resolution**:
- Use Terry agent for all conversions
- Single designated reviewer for all Terry docs
- Reference STYLE_GUIDE.md "What Just Happened?" examples

**Blocker**: "Mermaid diagrams failing validation"
**Resolution**:
- Run `mmdc -i file.mmd -o test.svg` locally before committing
- Reference Mermaid documentation for syntax
- Pair program on complex diagrams

**Blocker**: "Cross-stream dependencies discovered mid-sprint"
**Resolution**:
- Daily standup identifies dependencies early
- Create stub/interface file for handoff
- Adjust task sequencing if needed

**Blocker**: "Setup script exceeds 10 minutes"
**Resolution**:
- Profile script execution with `time ./scripts/setup.sh`
- Identify slow steps
- Optimize or parallelize (but maintain correctness)

---

## Communication Channels

### Synchronous

**Daily Standup**: 15 minutes, all streams
**Integration Meetings**: As needed when cross-stream work required
**Pair Programming**: Encouraged for complex tasks (diagrams, workflows)

### Asynchronous

**PR Comments**: For code review feedback
**Issue Tracking**: For bugs, questions, clarifications
**Documentation**: All decisions recorded in appropriate files (ADRs if significant)

---

## Tool Usage

### Required Tools

**Development**:
- Git 2.30+
- Text editor with markdown support
- Node.js 18+ (for mermaid-cli, markdownlint)

**Validation**:
- mermaid-cli: `npm install -g @mermaid-js/mermaid-cli`
- markdownlint: `npm install -g markdownlint-cli`
- shellcheck: System package manager

**Recording**:
- asciinema: System package manager (for Phase 4)

### Automation Scripts

**Daily Use**:
- `./scripts/validate-mermaid.sh` - Validate all diagrams
- `./scripts/check-doc-pairs.sh` - Verify Terry versions exist
- `./scripts/lint-all.sh` - Run all linters (Phase 3+)

**Testing**:
- `./scripts/setup.sh` - Test setup flow (timed)
- `git clone <test-repo> && cd <test-repo> && ./scripts/setup.sh` - End-to-end test

---

## Success Metrics

### Quantitative

- **Velocity**: 61 tasks parallelizable / 99 total = 63% parallel capacity
- **Time**: 3-4 weeks target (vs 5-6 weeks unoptimized)
- **Quality**: Zero validation failures in Phase 5
- **Buffet**: All 5 features extract independently (T093a-e)

### Qualitative

- **Usability**: Setup completes in <10 minutes (measured)
- **Clarity**: Non-technical stakeholders understand Terry docs (user testing)
- **Consistency**: All documentation follows STYLE_GUIDE.md
- **Independence**: Features adoptable without forced dependencies

---

## Retrospective Format (End of Each Week)

### What Went Well
- Tasks completed ahead of schedule
- Quality gates passed without rework
- Smooth cross-stream collaboration

### What Needs Improvement
- Tasks blocked longer than expected
- Validation failures requiring rework
- Communication gaps between streams

### Action Items
- Process improvements for next week
- Tool changes if needed
- Documentation clarifications

---

**Last Updated**: 2025-12-17
**Maintained By**: Project lead (update weekly during retrospectives)
