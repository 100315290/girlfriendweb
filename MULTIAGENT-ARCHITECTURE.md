# Multi-Agent Coordination System — Architecture Overview

## The Problem

You have 11+ specialized agents (Architect, Coder, Reviewer, QA, Security, etc.) that need to work on the same project:
- They work **sequentially** (not truly parallel, but coordinated)
- They all need to track progress on a **shared canvas**
- They need to avoid stepping on each other's toes
- You need **real-time visibility** in both VSCode and Obsidian

## The Solution

**Three-layer system:**

### Layer 1: Shared Canvas (`Project.canvas`)
- **Single source of truth** for all agents
- One `.canvas` file in root of `girlfriendweb/`
- Visual board with color-coded tasks in Obsidian
- Managed entirely through CLI (never direct JSON edits)

### Layer 2: Session-Aware Coordination (`canvas-coordinator.py`)
- Wrapper around `canvas-tool.py` that adds **session tracking**
- Every agent call is logged in `.agents-work/<session>/status.json`
- No race conditions (Orchestrator runs sequentially)
- Automatic environment variable handling

### Layer 3: VSCode Tasks + Obsidian Integration
- **VSCode tasks** for quick command execution (`Ctrl+Shift+B`)
- **Obsidian canvas** for real-time visual feedback
- Both stay in sync through canvas JSON

---

## How It Works

### Initialization
```
User starts session
    ↓
Orchestrator creates: `.agents-work/2026-03-14_myproject/`
    ↓
SpecAgent creates: `spec.md`, `acceptance.json`
    ↓
Architect creates: `architecture.md`
    ↓
Planner creates: `tasks.yaml` + initial canvas with RED/GRAY cards
```

### Execution Loop (Repeats for Each Task)
```
Coder:
  python canvas-coordinator.py "session" start T-001        # RED → ORANGE
  [... implement task ...]
  python canvas-coordinator.py "session" finish T-001       # ORANGE → CYAN

Reviewer:
  python canvas-coordinator.py "session" start T-001        # CYAN → ORANGE
  [... review ...]
  python canvas-coordinator.py "session" finish T-001       # ORANGE → CYAN

[Optional: QA, Security]

Orchestrator:
  Marks T-001 GREEN in Obsidian
  Checks status.json to see who worked on it
  Moves to next unblocked task
```

### State Tracking
Every operation updates `.agents-work/<session>/status.json`:

```json
{
  "current_state": "IMPLEMENT_LOOP",
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:45:30Z",
    "tasks_assigned": ["T-001", "T-002"]
  }
}
```

**Why this matters:**
- If a session is interrupted, you can resume from the last known state
- Orchestrator knows which agents worked on which tasks
- Full audit trail of project progression

---

## File Organization

### Project Root
```
girlfriendweb/
├── Project.canvas                    # THE SHARED CANVAS (one file for all)
├── canvas-coordinator.py             # CLI wrapper with session tracking
├── MULTIAGENT-QUICKSTART.md          # ← Start here
├── MULTIAGENT-ARCHITECTURE.md        # This file
└── ...
```

### Session Folders
```
.agents-work/
├── 2026-03-14_myproject/
│   ├── status.json                   # State tracking (auto-updated)
│   ├── spec.md                       # What to build
│   ├── tasks.yaml                    # Breakdown of work
│   ├── architecture.md               # How to build it
│   └── agent-results/                # Temporary work artifacts
│       ├── architect-notes.md
│       ├── coder-draft.md
│       └── reviewer-report.md
└── (older sessions preserved for history)
```

### Configuration
```
.vscode/
├── tasks.json                        # Canvas commands (Ctrl+Shift+B)
└── launch.json                       # Debug configs

.github/agents/
├── CANVAS-COORDINATOR.md             # ← Integration guide
├── 00-orchestrator.md                # Orchestrator spec
├── 04-coder.md                       # Coder spec (updated)
└── (other agent specs)

.github/
└── copilot-instructions.md           # ← Updated for session mode
```

---

## Key Concepts

### Canvas Color States

| Color | Meaning | Who Sets It |
|-------|---------|------------|
| 🟣 Purple | Proposed (awaiting approval) | Agent |
| 🔴 Red | Ready to start | Human/Planner |
| 🟠 Orange | Currently being worked on | Agent (via start) |
| 🔵 Cyan | Finished, awaiting review | Agent (via finish) |
| 🟢 Green | Approved and complete | Human only |
| ⬜ Gray | Blocked (dependencies not met) | Auto |

### Workflow Guarantee

✅ **Each agent transitions only their own task colors:**
- Red → Orange (agent starts)
- Orange → Cyan (agent finishes)
- Orange → Red (agent pauses)

❌ **Agents CANNOT:**
- Set cards green (human only)
- Edit gray/cyan cards
- Edit other agents' cards

✅ **Orchestrator ensures:**
- Gray → Red (auto, when deps met)
- Cyan → Green (after review passes)

---

## No Race Conditions — Why?

**GitHub Copilot Orchestrator executes sequentially:**

```
Dispatch Coder → Wait for result
Dispatch Reviewer → Wait for result
Dispatch QA → Wait for result
```

Each agent completes before the next starts. Therefore:
- ✅ No file locking needed
- ✅ No merge conflicts on canvas
- ✅ Simple transaction model: read → modify → write

**But we DO need session tracking** (`status.json`) so:
- Each agent knows where they are
- Orchestrator can resume if interrupted
- Audit trail is preserved

---

## Quick Workflow Example

### Day 1: Planning
```bash
Session: Create New → "myproject"
→ SpecAgent: produce spec.md
→ Architect: produce architecture.md
→ Designer: produce design-specs/
→ Planner: produce tasks.yaml + canvas
```

### Day 2: Coder Session
```bash
VSCode: Canvas: Ready Tasks
→ See: T-001, T-002 ready | T-003, T-004 blocked

Canvas: Start Task → T-001 (set RED → ORANGE)
→ Implement code
→ Canvas: Finish Task → T-001 (set ORANGE → CYAN)

Obsidian: Shows T-001 CYAN (awaiting review)
```

### Day 2: Reviewer Session
```bash
Canvas: Start Task → T-001 (set CYAN → ORANGE)
→ Review code
→ Canvas: Finish Task → T-001 (set ORANGE → CYAN)

[Human checks: looks good]
→ Obsidian: Drag T-001 to GREEN
→ Canvas: Normalize
→ Obsidian: T-002 now RED (unblocked)
```

### Day 2: QA Session
```bash
Canvas: Start Task → T-002
→ Test code
→ Canvas: Finish Task → T-002

[Human approves T-002]
→ Move on
```

---

## Integration Points

### GitHub Copilot Agents
- Read instructions from `.github/agents/CANVAS-COORDINATOR.md`
- Follow exact pattern: `start` → work → `finish`
- Set `$env:AGENT_NAME` before each command
- All updates auto-tracked in status.json

### Obsidian
- Visual board in `Project.canvas`
- See real-time updates as agents work
- Drag to change states (RED/ORANGE/CYAN/GREEN)
- No direct JSON edits

### VSCode
- Tasks for quick commands (`Ctrl+Shift+B`)
- Edit source files while canvas tracks progress
- Terminal to run agents or manual commands

---

## Customization

### Add a New Session Variable
Edit `.agents-work/session-template/status.json` and add to all new sessions.

### Add a New Agent Role
1. Add to `.github/agents/XX-role.md`
2. Add to VSCode task inputs (`agentName` options)
3. Instructions use: `$env:AGENT_NAME = "role"`

### Modify Canvas Colors
Edit `.Kanvas-main/canvas-tool.py` COLOR_MAP (not recommended unless you know the system).

### Add More Tasks to Canvas
Use `canvas-coordinator.py` commands:
```bash
$env:AGENT_NAME = "architect"
python canvas-coordinator.py "session" propose "Group" "New Task" "Description"
```

---

## Debugging

### Lost Track of Session?
```powershell
# VSCode: Run task "Session: List All"
Get-ChildItem .agents-work/ | Select-Object -ExpandProperty Name
```

### Canvas Not Updating in Obsidian?
```bash
python canvas-coordinator.py "session" normalize
# Then refresh Obsidian (Cmd+R)
```

### Check Agent's Last Action
```bash
cat .agents-work/session/status.json | Select-String "last_agent", "last_update"
```

### View Full Session History
```bash
cat .agents-work/session/status.json | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

---

## Best Practices

1. **Commit after each task:** After `finish`, git commit with task ID in message
2. **One session per sprint:** Don't reuse old sessions; create new for each project
3. **Check Obsidian before starting:** See what's ready, what's blocked
4. **Set AGENT_NAME before every command:** Consistency in tracking
5. **Use VSCode tasks:** Faster than typing; built-in help
6. **Review status.json regularly:** Understand project flow

---

## Files You Need to Know

| File | Purpose | Who Edits |
|------|---------|-----------|
| `Project.canvas` | Main task board | Only via canvas-coordinator |
| `.agents-work/<session>/status.json` | Session state & tracking | canvas-coordinator (auto) |
| `.agents-work/<session>/tasks.yaml` | Task breakdown | Planner (agent) |
| `.agents-work/<session>/spec.md` | Requirements | SpecAgent (agent) |
| `.github/copilot-instructions.md` | Project conventions | Humans (reference only) |
| `.vscode/tasks.json` | VSCode shortcuts | Humans (setup once) |

---

## Next: Getting Started

👉 **Read:** [`MULTIAGENT-QUICKSTART.md`](./MULTIAGENT-QUICKSTART.md)

👉 **Run:** `Session: Create New` task in VSCode

👉 **Open:** `Project.canvas` in Obsidian side-by-side with VSCode

**You're ready to orchestrate multiple AI agents! 🚀**
