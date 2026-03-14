# Canvas Workflow — Agent Instructions

This project uses Obsidian Canvas files as visual task boards. A Python CLI tool manages all board modifications.

**Session-aware mode**: Agents update a shared `Project.canvas` that tracks progress for ALL agents working on the same project.

---

## 📚 Documentation Standards

**See also:** [`docs/README.md`](../../docs/README.md) for complete documentation index.

### Where to Put Documentation

All project documentation goes in `docs/` folder, organized by audience/purpose:

- **Getting started:** `docs/getting-started/` — Onboarding and setup
- **Developer (user):** `docs/developer/` — Authority, capabilities, workflow
- **Reference:** `docs/reference/` — Technical deep-dives, architecture
- **Agents:** `docs/agents/` — Agent roles, responsibilities, coordination
- **Sessions:** `docs/sessions/` — Session management, structure, tracking
- **Troubleshooting:** `docs/troubleshooting/` — Common issues, solutions

**Master index:** [`docs/README.md`](../../docs/README.md) with full navigation.

### Naming Conventions

All documentation files use **`snake_case.md`** (not camelCase, not UPPERCASE):

✅ Good:
- `canvas-workflow.md`
- `agent-coordination.md`
- `your-role.md`
- `common-issues.md`

❌ Bad:
- `CanvasWorkflow.md`
- `AGENT-COORDINATION.md`
- `YourRole.md`

### When to Create Documentation

Create docs when:
- Implementing new workflows or processes
- Documenting agent roles or capabilities
- Recording design decisions or architecture changes
- Creating troubleshooting guides for common issues

Examples:
- New agent → Add to `docs/agents/index.md`
- New session template → Document in `docs/sessions/session-setup.md`
- New workflow → Document in `docs/reference/canvas-workflow.md`
- New feature → Add to appropriate reference file

### Linking Guidelines

Use relative paths in links:

```markdown
# From docs/reference/architecture.md to docs/developer/quick-reference.md:
See [Quick Reference](../developer/quick-reference.md) for commands.

# From docs/agents/index.md to docs/reference/agent-coordination.md:
See [Coordination Protocol](../reference/agent-coordination.md)
```

**Never use absolute paths or external URLs for internal docs.**

### Markdown Style

- Use proper headings hierarchy (# → ## → ###)
- Surround code blocks with language marker: ` ```bash `, ` ```json `, etc.
- Use tables for comparison/reference material
- Include "See also" sections linking to related docs
- Keep lines under 100 characters for readability

### Cross-References

Always add a "See also" footer linking to related documents:

```markdown
---

See also:
- [Architecture](../reference/architecture.md) — System design
- [Your Role](../developer/your-role.md) — Your authority
```

---

### Agent Documentation Contributions

If you (as an agent) create new documentation during your work:

1. **Place in correct folder:**
   - Architecture decisions? → `docs/reference/`
   - New workflow? → `docs/reference/canvas-workflow.md` or `docs/sessions/`
   - New process? → `docs/troubleshooting/` or `docs/reference/`

2. **Use snake_case naming:** `new-feature.md` (not NewFeature.md or NEW_FEATURE.md)

3. **Link appropriately:**
   - Include in master index if major topic
   - Add "See also" sections to related docs
   - Use relative paths: `../reference/architecture.md`

4. **Update relevant sections:**
   - New agent? → Update `docs/agents/index.md`
   - New session type? → Update `docs/sessions/session-setup.md`
   - New command? → Update `docs/developer/quick-reference.md`

5. **Keep consistent style:**
   - Follow markdown standards in existing docs
   - Use tables for reference material
   - Include examples
   - Link to related content

---

## CRITICAL RULE

**NEVER edit `.canvas` files directly.** All canvas modifications MUST go through the CLI coordinator:

```bash
# Set your agent name (required for tracking)
$env:AGENT_NAME = "coder"

# All canvas commands go through canvas-coordinator.py
python canvas-coordinator.py <session> <command> [args]
```

Example:
```bash
$env:AGENT_NAME = "architect"
python canvas-coordinator.py "2026-03-14_myproject" status
python canvas-coordinator.py "2026-03-14_myproject" start T-001
```

Direct JSON editing of `.canvas` files is **forbidden**. The CLI tool enforces workflow rules (valid transitions, cycle detection, blocked states) so you don't have to remember them.

## Session Protocol

### 1. Start of session — read the board

```bash
$env:AGENT_NAME = "your-role"  # e.g., "architect", "coder", "reviewer"
python canvas-coordinator.py "2026-03-14_myproject" status
```

Review the board state. Run `normalize` if needed. Report ready tasks, blocked tasks, and any anomalies to the user.

### 2. Pick a task

```bash
python canvas-coordinator.py "2026-03-14_myproject" ready            # see what's available
python canvas-coordinator.py "2026-03-14_myproject" show <TASK-ID>   # read task details
python canvas-coordinator.py "2026-03-14_myproject" start <TASK-ID>  # begin work (red → orange)
```

If multiple tasks are ready, ask the user which to prioritize.

### 3. Work on the task

Execute the task. If you discover subtasks, propose them:

```bash
python canvas-coordinator.py "2026-03-14_myproject" propose Development "Subtask title" "Description" --depends-on DV-01
```

Update notes on your in-progress task:

```bash
python canvas-coordinator.py "2026-03-14_myproject" edit <TASK-ID> "Updated description with findings."
```

### 4. Finish the task

```bash
python canvas-coordinator.py "2026-03-14_myproject" finish <TASK-ID>   # orange → cyan
```

Tell the user what was done. Do NOT attempt to set the card green — only the human does that.

### 5. Session tracking

Every time you call `canvas-coordinator.py` with a write command (`start`, `finish`, `propose`, `edit`, etc.), the session's `status.json` is automatically updated:

```json
{
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:30:00Z",
    "tasks_assigned": ["T-001", "T-002"]
  }
}
```

This allows the Orchestrator and other agents to see who worked on what, and maintain a clear timeline.

### 6. Repeat

After the human marks your task green, check for newly unblocked tasks:

```bash
python canvas-coordinator.py "2026-03-14_myproject" normalize
python canvas-coordinator.py "2026-03-14_myproject" ready
```

## What you CAN do

- **Read** the board: `status`, `show`, `list`, `blocked`, `blocking`, `ready`, `dump`
- **Normalize** the board: `normalize`
- **Propose** tasks: `propose` or `batch` (creates purple cards)
- **Propose** groups: `propose-group` or `batch`
- **Start** a task: `start <ID>` (red → orange)
- **Finish** a task: `finish <ID>` (orange → cyan)
- **Pause** a task: `pause <ID>` (orange → red)
- **Edit** task text: `edit <ID> "<text>"` (only orange tasks)
- **Add dependencies**: `add-dep <FROM> <TO>`

## What you CANNOT do

- Edit `.canvas` files directly
- Mark any card green (done) — human only
- Work on purple cards (proposals awaiting approval)
- Work on gray cards (blocked)
- Work on cyan cards (awaiting human review)
- Remove cards or edges
- Change green cards

## CLI Quick Reference

### Read-only commands
| Command | Description |
|---------|-------------|
| `status` | Board overview |
| `show <ID>` | Task detail with dependencies |
| `list [STATE\|GROUP]` | List tasks (filtered) |
| `blocked` | Gray tasks and blockers |
| `blocking` | Tasks that block others |
| `ready` | Red tasks with deps met |
| `dump` | Raw JSON |

### Lifecycle commands
| Command | Transition |
|---------|-----------|
| `start <ID>` | Red → Orange |
| `finish <ID>` | Orange → Cyan |
| `pause <ID>` | Orange → Red |

### Proposal commands
| Command | Description |
|---------|-------------|
| `propose <GROUP> "<TITLE>" "<DESC>" [--depends-on ID ...]` | Add task |
| `propose-group "<LABEL>"` | Add group |
| `batch` | Bulk-add from JSON on stdin |

### Other commands
| Command | Description |
|---------|-------------|
| `edit <ID> "<TEXT>"` | Update text (orange only) |
| `add-dep <FROM> <TO>` | Add dependency |
| `normalize` | Assign IDs, fix blocked states |

## Color meanings

| Color | Meaning |
|-------|---------|
| 🟣 Purple | Proposed by agent |
| 🔴 Red | To Do (ready) |
| 🟠 Orange | Doing |
| 🔵 Cyan | Ready to review |
| 🟢 Green | Done |
| ⬜ Gray | Blocked |

---

## 📖 Documentation Resources for Agents

**Project-level:** This file (you're reading it now)

**System documentation:**
- Complete system docs: `docs/README.md` (master index)
- System architecture: `docs/reference/architecture.md`
- Canvas workflow: `docs/reference/canvas-workflow.md`
- Agent coordination: `docs/reference/agent-coordination.md`

**For specific questions:**
- Canvas commands: `docs/developer/quick-reference.md`
- Session management: `docs/sessions/session-setup.md`
- Common issues: `docs/troubleshooting/common-issues.md`
- Agent roles: `docs/agents/index.md`

**Start here:** `SYSTEM-OVERVIEW.md` (root level, quick reference)
