# Multi-Agent Workflow — Quick Start Guide

**IMPORTANT: You (the developer) are in control.** This system works FOR you, not the other way around.

See **[DEVELOPER-QUICK-REFERENCE.md](./DEVELOPER-QUICK-REFERENCE.md)** for what YOU can do.

## Setup (One Time)

1. **Open VSCode** with workspace at `girlfriendweb/`
2. **Open Obsidian** in another window with vault at `girlfriendweb/`
3. **Open canvas** in Obsidian: `Project.canvas`
4. **Run VSCode Task**: `Session: Create New` (or manually create in `.agents-work/`)

Example session creation:
```powershell
$date = Get-Date -Format "yyyy-MM-dd"
$session = "2026-03-14_myproject"
mkdir ".agents-work/$session/agent-results"
Copy-Item ".agents-work/session-template/status.json" ".agents-work/$session/status.json"
```

---

## Running a Project

### Phase 1: Planning (Orchestrator + Agents)

1. **Orchestrator** starts session and creates initial tasks
2. **SpecAgent** → Produces `spec.md` in `.agents-work/<session>/`
3. **Architect** → Produces `architecture.md`
4. **Designer** (if UI) → Produces design specs
5. **Planner** → Produces `tasks.yaml` and initial canvas board
6. At this point: Canvas shows RED cards (ready) and GRAY cards (blocked)

**Canvas State:**
- 🔴 RED = Ready to start (all dependencies met)
- ⬜ GRAY = Blocked (waiting for dependencies)

### Phase 2: Execution Loop (Multiple Agents in Sequence)

For each task (T-001, T-002, etc.):

#### 1. **Coder Works** (if it's a code task)

```powershell
# Terminal 1 - VSCode
$env:AGENT_NAME = "coder"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
# Canvas: T-001 changes from RED to ORANGE

# ... implement the task ...
# Commit code if needed

python canvas-coordinator.py "2026-03-14_myproject" finish T-001
# Canvas: T-001 changes from ORANGE to CYAN (awaiting review)
```

**Obsidian shows:** 🟠 ORANGE while coding, then 🔵 CYAN when done

#### 2. **Reviewer Reviews** (per strategy in REVIEW_STRATEGY)

```powershell
$env:AGENT_NAME = "reviewer"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
# Canvas: T-001 back to ORANGE for review

# ... review code, request changes or approve ...

python canvas-coordinator.py "2026-03-14_myproject" finish T-001
# Canvas: back to CYAN (awaiting human decision)
```

#### 3. **QA Tests** (if applicable)

```powershell
$env:AGENT_NAME = "qa"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
python canvas-coordinator.py "2026-03-14_myproject" finish T-001
```

#### 4. **Security Audits** (if applicable)

```powershell
$env:AGENT_NAME = "security"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
python canvas-coordinator.py "2026-03-14_myproject" finish T-001
```

#### 5. **Orchestrator Approves** (Human/AI Decision)

- Reads `status.json` to see who worked on the task
- Verifies all gates (Reviewer ✓, QA ✓, Security ✓)
- Marks task GREEN in canvas (only humans/orchestrator can set GREEN)
- Canvas: T-001 → 🟢 GREEN

#### 6. **Repeat for Next Task**

Canvas now shows:
- 🟢 GREEN = T-001 (done)
- 🔴 RED = T-002 (just unblocked by T-001's completion)
- ⬜ GRAY = T-003, T-004 (still blocked)

---

## VSCode Task Commands

Press `Ctrl+Shift+B` to open Task menu:

| Task | What It Does |
|------|-------------|
| `Canvas: Session Status` | Show board overview |
| `Canvas: Ready Tasks` | List RED tasks (ready to start) |
| `Canvas: Start Task` | Mark task ORANGE (in progress) |
| `Canvas: Finish Task` | Mark task CYAN (awaiting review) |
| `Canvas: Normalize Board` | Auto-fix blocked states |
| `Canvas: Show Task Details` | Read task description & dependencies |
| `Session: Create New` | Create new `.agents-work/` session |
| `Session: List All` | Show all existing sessions |
| `Agent Workflow: Coder - Full Cycle` | Walkthrough: coder start → work → finish |

**Shortcut:**
- `Ctrl+Shift+B` → Pick `Canvas: Ready Tasks` → See what's available
- `Ctrl+Shift+B` → Pick `Canvas: Start Task` → Pick agent role → Pick task → GO

---

## Session Tracking: What Gets Saved?

Every time an agent calls canvas-coordinator, `.agents-work/<session>/status.json` updates:

```json
{
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:45:30Z",
    "tasks_assigned": ["T-001", "T-002", "T-003"]
  }
}
```

This allows:
- **Orchestrator** to see who worked on what and when
- **Agents** to see project progress
- **Resume workflows**: If interrupted, check status.json to resume correctly

---

## Obsidian Canvas Colors & Meanings

| Color | State | Who Controls |
|-------|-------|-------------|
| 🟣 Purple | Proposed | Agent proposes, Human approves |
| 🔴 Red | To Do | Ready to start |
| 🟠 Orange | In Progress | Agent is working on it |
| 🔵 Cyan | Under Review | Agent finished, awaiting review/approval |
| 🟢 Green | Done | Human/Orchestrator approved ✓ |
| ⬜ Gray | Blocked | Waiting for dependencies |

**Flow:** Purple → Red → Orange → Cyan → Green

---

## Troubleshooting

### "Canvas not updating in Obsidian"
```powershell
python canvas-coordinator.py "2026-03-14_x" normalize
# Then refresh Obsidian (Cmd+R or Ctrl+R)
```

### "Task stuck in ORANGE"
```powershell
$env:AGENT_NAME = "agent-name"
python canvas-coordinator.py "2026-03-14_x" pause T-001  # ORANGE → RED
```

### "Can't find current session"
```powershell
Get-ChildItem .agents-work/
```

### "Python script not found"
Ensure you're in `girlfriendweb/` directory and file `canvas-coordinator.py` exists.

---

## Integration with GitHub Copilot Agents

Each agent (Coder, Reviewer, QA, Security, etc.) receives instructions to:

1. Read its task from `tasks.yaml`
2. Start work:
   ```powershell
   $env:AGENT_NAME = "agent-role"
   python canvas-coordinator.py "session-name" start T-XXX
   ```
3. Do the work
4. Finish work:
   ```powershell
   python canvas-coordinator.py "session-name" finish T-XXX
   ```

The coordinator automatically:
- Updates canvas color transitions
- Tracks who did what in status.json
- Syncs to Obsidian in real-time

---

## Advanced: Manual Canvas Edits in Obsidian

**ALLOWED (as Orchestrator/Human):**
- ✅ Drag cards to rearrange
- ✅ Draw arrows (dependencies)
- ✅ Color cards (set RED/ORANGE/CYAN/GREEN)
- ✅ Add/edit card descriptions

**NOT ALLOWED (JSON edits):**
- ❌ Edit `Project.canvas` JSON directly in VSCode
- ❌ Use `canvas-tool.py` directly (use `canvas-coordinator.py` instead)

All agent changes MUST go through `canvas-coordinator.py` to maintain tracking.

---

## File Structure Reference

```
girlfriendweb/
├── Project.canvas                    # ← Shared, single canvas for all agents
├── canvas-coordinator.py             # ← Session-aware wrapper
├── .Kanvas-main/canvas-tool.py       # ← Core canvas logic
├── .github/
│   ├── copilot-instructions.md       # ← Updated with canvas-coordinator
│   └── agents/
│       ├── CANVAS-COORDINATOR.md     # ← Full integration guide
│       ├── 00-orchestrator.md
│       ├── 04-coder.md               # ← And all other agents
│       └── ...
├── .agents-work/
│   ├── session-template/             # ← Template for new sessions
│   │   └── status.json
│   ├── 2026-03-14_myproject/         # ← Actual session
│   │   ├── status.json               # ← Tracks last_agent, last_update
│   │   ├── spec.md
│   │   ├── tasks.yaml
│   │   ├── architecture.md
│   │   └── agent-results/            # ← Temp artifacts
│   └── ...
└── .vscode/
    ├── tasks.json                    # ← Canvas commands
    └── launch.json
```

---

## Next Steps

1. ✅ Create a session: `Session: Create New`
2. ✅ Ask SpecAgent to create initial spec
3. ✅ Review spec in `.agents-work/<session>/spec.md`
4. ✅ Ask Architect to create architecture
5. ✅ Ask Planner to create tasks.yaml
6. ✅ Run first Coder task: `Canvas: Start Task` → T-001
7. ✅ Watch Obsidian in real-time
8. ✅ Run Reviewer: `Canvas: Start Task` → same task
9. ✅ Approve in Obsidian when ready
10. ✅ Move to next task

**You now have a visual, coordinated multi-agent workflow! 🚀**
