# System Architecture

Complete technical overview of how the multi-agent system works.

## The Three Layers

```
┌─────────────────────────────────────────┐
│   YOU (Developer)                       │
│   Make decisions                        │
│   Approve/reject work                   │
│   Do work yourself                      │
└──────────────────┬──────────────────────┘
                   │
         Obsidian Canvas (Visual)
         Project.canvas (JSON file)
                   │
                   ▼
┌─────────────────────────────────────────┐
│  canvas-coordinator.py (CLI)            │
│  Session-aware wrapper                  │
│  - Update canvas colors                 │
│  - Track in status.json                 │
│  - Coordinate agent access              │
└──────────────────┬──────────────────────┘
                   │
    ┌──────────────┼──────────────┐
    ▼              ▼              ▼
  VSCode         Agents      Terminal
  (Edit code)    (Work)      (Commands)
```

## Core Files

### Project.canvas
- **What:** Single shared canvas, JSON format
- **Where:** `girlfriendweb/Project.canvas`
- **Who edits:** Only via canvas-coordinator.py or Obsidian UI
- **Contents:** Task cards with colors (states), groups, dependencies

### canvas-coordinator.py
- **What:** CLI wrapper around canvas-tool.py
- **Where:** `girlfriendweb/canvas-coordinator.py`
- **What it does:**
  1. Calls canvas-tool.py for canvas operations
  2. Updates status.json after each operation
  3. Tracks agent work (who did what, when)
- **No locks needed:** Sequential execution prevents race conditions

### status.json (per session)
- **What:** Session state and tracking
- **Where:** `.agents-work/<session>/status.json`
- **Auto-updated:** After every canvas-coordinator.py command
- **Contains:**
  - Current workflow state
  - Last agent and timestamp
  - Tasks assigned
  - Developer decisions
  - User approval gates

## Workflow State Machine

```
INTAKE
  ↓
DESIGN (or INTAKE_LEAN in lean mode)
  ↓
APPROVE_DESIGN (user approval gate)
  ↓
PLAN
  ↓
REVIEW_STRATEGY (user choice gate)
  ↓
IMPLEMENT_LOOP (for each task)
  │ ├─ Coder: implement
  │ ├─ Reviewer: review (per strategy)
  │ ├─ QA: test
  │ └─ Security: audit
  ↓
INTEGRATE
  ↓
RELEASE
  ↓
DONE
```

## Task Color Transitions

```
🟣 Purple (Proposed)
  ↓ (Human approves)
🔴 Red (Ready)
  ↓ (Agent or Developer starts)
🟠 Orange (In Progress)
  ├─ (Pause) → 🔴 Red
  └─ (Finish) → 🔵 Cyan (Awaiting Review)
      ↓ (Reviewer starts)
      🟠 Orange (Reviewing)
        └─ (Finish) → 🔵 Cyan (Awaiting Approval)
          ↓ (Human approves)
          🟢 Green (Done)
```

**Blocked (⬜ Gray):** Automatic state when task has unmet dependencies

## No Race Conditions — Why?

**GitHub Copilot Orchestrator is sequential:**
1. Dispatch Coder agent → Wait for result
2. Dispatch Reviewer agent → Wait for result
3. Dispatch QA agent → Wait for result
4. ...

Each agent **completes before the next starts**, so:
- ✅ No file locking needed
- ✅ Simple transaction model: read → modify → write
- ✅ Automatic tracking in status.json

## Session Structure

Each session is a folder under `.agents-work/`:

```
.agents-work/2026-03-14_myproject/
├── status.json               # Session state (auto-updated)
├── spec.md                   # Specification
├── tasks.yaml                # Task breakdown
├── architecture.md           # System design
├── acceptance.json           # Acceptance criteria
└── agent-results/            # Temporary artifacts
    ├── architect.md
    ├── coder-draft.md
    ├── reviewer-report.md
    └── qa-findings.json
```

**Session naming:** `YYYY-MM-DD_slug`
Example: `2026-03-14_auth-refactor`

## Tracking Model

**status.json** is the single source of truth for:
- Who worked on what (agent name)
- When they worked (timestamps)
- What tasks are assigned
- Developer decisions and approvals
- Current workflow state
- Gates and their status

```json
{
  "session_id": "2026-03-14_myproject",
  "current_state": "IMPLEMENT_LOOP",
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:45:00Z",
    "tasks_assigned": ["T-001", "T-002"],
    "developer_work": ["T-003"]
  },
  "developer_decisions": [
    {
      "timestamp": "2026-03-14T09:00:00Z",
      "action": "approved_T-001"
    }
  ]
}
```

## Integration Points

### Obsidian
- **Connection:** Watches `Project.canvas` for changes
- **Interaction:** You drag cards to change state
- **Real-time:** Updates as agents/you work

### VSCode
- **Connection:** Tasks in `.vscode/tasks.json`
- **Quick access:** `Ctrl+Shift+B` for canvas commands
- **File editing:** Edit code while canvas tracks progress

### Git
- **Tracking:** Canvas + code committed together
- **History:** Each commit reflects task completion
- **Reversibility:** Can checkout any point in project

## Command Flow

```
You run:
  python canvas-coordinator.py "session" start T-001

canvas-coordinator.py:
  1. Check AGENT_NAME env variable
  2. Call canvas-tool.py with "start T-001"
  3. Get result (success/error)
  4. Load status.json
  5. Update: last_agent, last_update, tasks_assigned
  6. Save status.json
  7. Print output

Result:
  - Project.canvas updated (card T-001: RED → ORANGE)
  - status.json updated (agent=developer, timestamp=now)
  - Obsidian sees change and refreshes
```

## Design Principles

✅ **Single source of truth:** Project.canvas (all agents read/write this)  
✅ **Audit trail:** status.json tracks everything  
✅ **No conflicts:** Sequential execution prevents race conditions  
✅ **Simple coordination:** Each agent knows what's ready via canvas  
✅ **Human in control:** Developer approves (GREEN) all work  
✅ **Transparent:** All state visible in Obsidian and status.json  
✅ **Reversible:** Canvas color changes are undoable  
✅ **Persistent:** Sessions preserved for history  

---

See also:
- [Canvas Workflow](./canvas-workflow.md) — State machine details
- [Agent Coordination](./agent-coordination.md) — How agents work together
