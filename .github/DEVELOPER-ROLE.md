# Developer Role — Your Authority in the Multi-Agent System

## Overview

**You are the decision-maker.** This system executes YOUR decisions through agents. You control:

- ✅ What gets built (scope)
- ✅ When agents work or pause
- ✅ Whether to accept/reject agent work
- ✅ What's ready vs. blocked
- ✅ Architecture and design decisions
- ✅ Which agents to activate/deactivate

---

## Your Powers in the Canvas

### 1. **Approve Tasks (Purple → Red)**
When an agent PROPOSES a task (🟣 Purple), YOU decide if it's approved:

```
Agent proposes task
       ↓
You review in Obsidian Canvas
       ↓
Drag card from 🟣 Purple to 🔴 Red
       OR reject it (delete or keep purple)
```

✅ **Only you approve new work.**

### 2. **Mark Tasks Complete (Cyan → Green)**
When an agent FINISHES a task (🔵 Cyan), YOU decide if it's acceptable:

```
Agent finishes and sets CYAN
       ↓
You review code/results in VSCode
       ↓
If good: Drag card to 🟢 Green
If not: Leave on CYAN or move back to 🔴 Red
```

✅ **Only you mark work as final.**

### 3. **Do Manual Work (Set to Orange)**
You can work on tasks yourself:

```powershell
# Mark a task as "you're working on it"
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-005

# Do your work (design, architecture decision, manual testing, etc.)

# Mark as done
python canvas-coordinator.py "session" finish T-005

# Then APPROVE it (yourself) by dragging to GREEN in Obsidian
```

🟠 **Orange = anyone is working (could be you)**

### 4. **Pause Agent Work**
If an agent is working on something you want to stop:

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" pause T-001
# ORANGE → RED (task goes back to "ready but not started")
```

✅ **You can pause any agent at any time.**

### 5. **Create Tasks Manually**
Instead of waiting for agents to propose, you can propose tasks directly:

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" propose "Backend" "Fix database migration" "We need to handle null values properly"
```

✅ **You create the initial project plan or ad-hoc tasks.**

### 6. **Edit Task Descriptions**
Update task descriptions to give agents better guidance:

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" edit T-001 "IMPORTANT: Use async/await, not callbacks. See arch-doc for pattern."
```

✅ **Only Orange (in-progress) tasks can be edited.**

### 7. **Draw Dependencies**
In Obsidian, draw arrows between cards to define dependencies:

```
T-001 (DB Schema)  →  T-002 (API Layer)  →  T-003 (Tests)
```

✅ **Automatically creates GRAY (blocked) states for downstream tasks.**

### 8. **Normalize the Board**
Fix issues, recalculate blocked states:

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" normalize
```

✅ **Use this if cards aren't updating correctly.**

---

## Your Role at Each Stage

### Stage 1: Planning
**What Agents Do:**
- SpecAgent: Create spec.md
- Architect: Create architecture.md
- Designer: Create design specs

**What YOU Do:**
- 📝 Read and review spec.md
- 🏗️ Review architecture with Architect
- 💡 Make architecture decisions (approve or request changes)
- 🎨 Review design specs (approve or request changes)
- ✅ Approve the plan to move forward

### Stage 2: Implementation
**What Agents Do:**
- Coder: Implement tasks
- Reviewer: Review code

**What YOU Do:**
- 🔍 Monitor progress (check `Canvas: Status` regularly)
- 📋 Review code when Reviewer marks tasks CYAN
- ✅ Approve (GREEN) or reject (back to RED)
- 🛑 Pause agents if needed
- 🔧 Do manual work if required (design decisions, debugging, architecture)
- 🎓 Guide agents (edit task descriptions to be clearer)

### Stage 3: Quality Gates
**What Agents Do:**
- QA: Test
- Security: Audit
- Integrator: Merge branches

**What YOU Do:**
- 🧪 Final testing (can do manual testing)
- 🔐 Review security findings
- 📦 Approve integration strategy
- ✅ Mark tasks GREEN when satisfied

### Stage 4: Release
**What YOU Do:**
- 🚀 Deploy (manual, not agent)
- 📝 Tag releases
- ✅ Mark final GREEN

---

## Commands You'll Use Most

### Monitor Progress
```powershell
# See what's available
python canvas-coordinator.py "session" ready

# Full board status
python canvas-coordinator.py "session" status

# See blocked tasks and why
python canvas-coordinator.py "session" blocked
```

### Make Decisions
```powershell
# Approve a proposal (Purple → Red in Obsidian)
# (Or just drag in Obsidian, which is faster)

# Approve completed work (Cyan → Green in Obsidian)
# (Or just drag in Obsidian, which is faster)

# Pause an agent
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" pause T-001
```

### Do Work Yourself
```powershell
# Start working on a task
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-005

# ... do your work in VSCode ...

# Mark your work as done
python canvas-coordinator.py "session" finish T-005

# Then approve it (in Obsidian, drag to GREEN)
```

### Provide Guidance
```powershell
# Guide an agent with better instructions
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" edit T-001 "Focus on error handling. See error-handling.md for patterns."
```

---

## What You CANNOT Do (By Design)

❌ **Edit `.canvas` JSON directly** — Use canvas-coordinator or Obsidian UI only  
❌ **Delete tasks** — Tasks persist (agents can't delete, you shouldn't)  
❌ **Mark other agents' work GREEN** — Only you approve; you own final decisions  
❌ **Edit GRAY or CYAN tasks** — Only ORANGE tasks can be edited (in progress)  
❌ **Remove dependencies** — Delete arrows in Obsidian if needed, but be careful  

---

## VSCode Tasks for Developers

Press `Ctrl+Shift+B` and use:

| Task | What It Does |
|------|-------------|
| `Canvas: Status` | See full board |
| `Canvas: Ready Tasks` | What's available |
| `Canvas: Blocked` | What's waiting on what |
| `Canvas: Blocking` | What's blocking others |
| `Canvas: Start Task` (developer) | Start working yourself |
| `Canvas: Finish Task` (developer) | Mark your work done |
| `Canvas: Pause Task` | Stop an agent |
| `Canvas: Show Task Details` | Read a task fully |
| `Canvas: Normalize` | Fix board issues |
| `Session: List All` | See all your sessions |

---

## Decision Gates (Where You Approve)

### APPROVE_DESIGN Gate
After Architect/Designer finish, **you approve** before implementation starts:

```
Architect/Designer present design
       ↓
You review in status.json + architecture.md
       ↓
You decide: "Looks good" or "Changes needed"
       ↓
If approved: workflow moves to PLAN
If changes: Agents revise, re-submit
```

✅ **This is YOUR decision point.**

### APPROVE_DEPLOYMENT Gate
After all QA/Security passes:

```
All tests GREEN ✓
All security GREEN ✓
All reviews GREEN ✓
       ↓
You review: "Ready to ship?"
       ↓
If yes: You deploy (manual)
If no: Back to development
```

✅ **This is YOUR decision point.**

---

## Session Tracking: Your Work is Recorded

Every time you run a command, `status.json` updates:

```json
{
  "canvas_state": {
    "last_agent": "developer",        // ← YOU are recorded
    "last_update": "2026-03-14T15:30Z",
    "tasks_assigned": ["T-001", "T-005"]  // ← Tasks you touched
  },
  "user_decisions": [
    {
      "decision_id": "UD-APPROVE-DESIGN",
      "status": "answered",
      "answer": "approved"
    },
    {
      "decision_id": "UD-CODE-REVIEW-T-001",
      "status": "answered",
      "answer": "approved-with-notes: See comments in PR"
    }
  ]
}
```

✅ **Full audit trail of your decisions.**

---

## Workflow Example: Your Day

```powershell
# Morning: Check status
python canvas-coordinator.py "2026-03-14_auth" status
# → See: Coder worked on T-001, now CYAN (awaiting review)

# Review Coder's work
# (Open VSCode, check git diff, review)

# You approve
# (In Obsidian: Drag T-001 to GREEN)

# Check what's next
python canvas-coordinator.py "2026-03-14_auth" ready
# → See: T-002, T-003 ready (no blockers)

# Assign to agents OR do it yourself
# Option A: Let them propose tasks
python canvas-coordinator.py "2026-03-14_auth" status
# → See agent proposals (PURPLE), you drag to RED to approve

# Option B: You do the work
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "2026-03-14_auth" start T-003
# ... design database schema ...
python canvas-coordinator.py "2026-03-14_auth" finish T-003
# (In Obsidian: Drag to GREEN)

# Midday: Agent work
# Coder starts T-002 (ORANGE)
# Reviewer reviews T-001 (ORANGE)

# Afternoon: More approvals
# Reviewer finishes (T-001 CYAN)
# You review and approve (T-001 GREEN)

# Evening: Check status
python canvas-coordinator.py "2026-03-14_auth" status
# → Record of who did what, when
```

✅ **You're the conductor; agents play the instruments.**

---

## Pro Tips for Developers

1. **Use Obsidian for visual decisions** (drag cards) — Faster than CLI
2. **Use CLI for programmatic queries** (`ready`, `blocked`, `status`) — Better for scripting
3. **Set clear task descriptions** — Agents will follow them
4. **Pause early if needed** — Don't let bad work accumulate
5. **Review regularly** — Don't let CYAN pile up; approve or reject quickly
6. **Commit per task** — After each GREEN, commit code + canvas
7. **Use design-specs** — Make Designer work explicit so Coders follow it
8. **Edit task descriptions** — Guide agents mid-task with `edit` command

---

## TL;DR — Your Role

| Responsibility | Your Power |
|---|---|
| **Approve scope** | Purple → Red |
| **Approve work** | Cyan → Green |
| **Guide agents** | Edit descriptions, pause tasks |
| **Do work yourself** | Set to Orange, finish, approve |
| **Make decisions** | Gates at DESIGN and DEPLOYMENT |
| **Maintain quality** | Review before GREEN |
| **Control workflow** | Activate/deactivate agents, prioritize |

✅ **You're in control. Agents execute your decisions.**

---

## You're the Boss

Agents are here to amplify your work, not replace your judgment. Use them for:
- ✅ Code implementation (Coder)
- ✅ Code review (Reviewer)
- ✅ Testing (QA)
- ✅ Security audit (Security)
- ✅ Documentation (Docs)

But YOU decide:
- ✅ What gets built
- ✅ How it gets built
- ✅ When it's good enough
- ✅ When it ships

**You're the orchestrator; agents are the musicians. 🎼**
