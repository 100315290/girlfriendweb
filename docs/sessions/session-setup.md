# Sessions Overview

How to create, structure, and manage project sessions.

## What is a Session?

A **session** is one complete project run with all agents. It captures:
- Your project specification
- Task breakdown
- Progress tracking (status.json)
- Agent outputs and decisions
- Your approvals and feedback

**Example session name:** `2026-03-14_auth-refactor`
- `2026-03-14` = Date created
- `auth-refactor` = Short project slug

## Session Folder Structure

```
.agents-work/2026-03-14_auth-refactor/
├── spec.md                    # Your project specification
├── tasks.yaml                 # Task breakdown (auto-created)
├── architecture.md            # System design
├── acceptance.json            # Acceptance criteria
├── status.json                # Auto-updated, tracks progress
└── agent-results/             # Temporary outputs
    ├── architect.md
    ├── coder-draft.md
    ├── reviewer-report.md
    └── qa-findings.json
```

### Key Files

**spec.md** (Your input)
- Project overview
- Requirements
- Goals and constraints
- User stories (optional)

Example:
```markdown
# Auth Refactor Project

## Goal
Modernize authentication from custom to OAuth2

## Requirements
- Support Google, GitHub, Microsoft SSO
- Migrate existing users
- Zero downtime deployment

## Acceptance Criteria
- All existing users can log in
- New OAuth providers work
- Performance: < 200ms login
```

**tasks.yaml** (Auto-generated)
- Breakdown of spec into concrete tasks
- Dependencies between tasks
- Acceptance criteria per task

**status.json** (Auto-updated)
- Current workflow state
- Last agent and timestamp
- Tasks assigned
- Your decisions and approvals
- Gates and their status

**agent-results/** (Agent outputs)
- Architect's design
- Coder's code suggestions
- Reviewer's findings
- QA's test results
- Any other work products

## Creating a Session

### Method 1: VSCode Task

```
Press Ctrl+Shift+B
Select: "Create New Session"
Enter project slug (e.g., "auth-refactor")
→ Creates .agents-work/YYYY-MM-DD_slug/
→ Opens session-template/status.json
→ Ready to fill in spec.md
```

### Method 2: Manual CLI

```bash
python canvas-coordinator.py --create-session "auth-refactor"
# Creates: .agents-work/2026-03-14_auth-refactor/
```

### Method 3: Copy Template

```bash
cp -r .agents-work/session-template .agents-work/2026-03-14_auth-refactor
# Edit spec.md
# Edit status.json: session_id to "2026-03-14_auth-refactor"
```

## Running a Session

### Step 1: Create & Configure

```
1. Create session (any method above)
2. Edit spec.md with your requirements
3. Check status.json: make sure session_id matches folder name
4. Optional: Edit workflow in status.json (Standard/Lean/Parallel)
```

### Step 2: Start Orchestrator

```bash
python canvas-coordinator.py "2026-03-14_auth-refactor" start
```

This:
- Loads spec.md and status.json
- Dispatches first agent (SpecAgent usually)
- Begins updating Project.canvas
- Tracks progress in status.json

### Step 3: Monitor Progress

**In Obsidian:**
- Watch Project.canvas
- See task colors change
- Monitor workflow state

**In VSCode:**
- Check status.json (auto-updates)
- Review agent-results/ outputs
- Respond to decision gates when prompted

### Step 4: Respond to Gates

When system pauses (status.json: `waiting_for: "user_decision"`):

```bash
# Review work in Obsidian or agent-results/
# Then approve:
python canvas-coordinator.py "session" approve <task-id>

# Or request changes:
python canvas-coordinator.py "session" request-changes <task-id> "Add X, Remove Y"
```

### Step 5: Session Complete

When all tasks are 🟢 GREEN:
```
Status.json: current_state = "DONE"
All agents have completed
Session archived (kept for history)
```

## Session Templates

### Standard Template
Full workflow: Design → Plan → Code → Review → QA → Security → Integrate → Release

Use when:
- Complex features
- High-risk changes
- First time (learn the system)

### Lean Template
Quick workflow: Plan → Code → Integrate → Release

Use when:
- Simple bugfixes
- Low-risk changes
- Familiar codebase

### Parallel Template
Multiple features work in parallel tracks

Use when:
- Multiple independent features
- Large teams
- Faster delivery needed

## Session Lifecycle

```
CREATE SESSION (status = "initial")
  ↓
INTAKE PHASE (SpecAgent, Researcher)
  ↓ [YOU APPROVE SPEC]
DESIGN PHASE (Architect, Designer)
  ↓ [YOU APPROVE DESIGN]
PLANNING PHASE (Planner)
  ↓
IMPLEMENTATION PHASE (Coder, Reviewer, QA, Security)
  ↓ [GATES: YOU APPROVE EACH TASK]
INTEGRATION PHASE (Integrator)
  ↓
RELEASE PHASE (Docs, final checks)
  ↓ [YOU SIGN OFF]
DONE (Session complete, keep for history)
```

## Tracking Progress

**In status.json:**
```json
{
  "current_state": "IMPLEMENT_LOOP",
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:45:00Z",
    "tasks_assigned": ["T-001", "T-002", "T-003"],
    "tasks_completed": ["T-001"],
    "developer_work": ["T-003"]
  },
  "developer_decisions": [
    {
      "timestamp": "2026-03-14T09:00:00Z",
      "action": "approved_architecture"
    }
  ]
}
```

**In Obsidian:**
- Count 🟢 GREEN tasks = completed work
- Count 🟠 ORANGE tasks = in progress
- Count ⬜ GRAY tasks = blocked
- Visual dashboard of project health

## Multiple Concurrent Sessions

You can run multiple sessions in parallel:

```
Session A: 2026-03-14_auth-refactor
Session B: 2026-03-14_ui-redesign
Session C: 2026-03-14_db-migration

Each has:
- Its own Project.canvas file? (No - shared, but separate task groups)
- Its own status.json (Yes)
- Its own agent-results/ (Yes)
- Its own spec.md (Yes)
```

**Sharing the canvas:**
- All sessions use same Project.canvas
- But each session has its own task groups
- Color coding prevents confusion

---

See also:
- [Quickstart](../getting-started/quickstart.md) — 5-minute setup
- [Architecture](../reference/architecture.md) — System design
- [Your Role](../developer/your-role.md) — Your responsibilities
