# Your Role as Developer

**You are in control.** This system works FOR you, not the other way around.

## What You Control

| Area | Your Power |
|------|-----------|
| **Scope** | Decide what gets built |
| **Approval** | Mark tasks GREEN (done) |
| **Prioritization** | Decide task order |
| **Quality** | Reject work that doesn't meet standards |
| **Architecture** | Approve design decisions |
| **Deployment** | You deploy (manual step) |
| **Agents** | Activate, deactivate, pause, guide |

## Your Main Responsibilities

### 1. Approve Work
When agents mark tasks CYAN (done), YOU decide if it's acceptable:
```
Agent finishes (CYAN) → You review → Drag to GREEN (approved)
                                     OR back to RED (needs work)
```

### 2. Guide Agents
Edit task descriptions to give better instructions:
```powershell
python canvas-coordinator.py "session" edit T-001 "Use async/await pattern"
```

### 3. Do Work Yourself
You can work on tasks anytime:
```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-005
# ... do your work ...
python canvas-coordinator.py "session" finish T-005
# Drag to GREEN in Obsidian (you approve your own work)
```

### 4. Pause Agents
Stop an agent mid-task if needed:
```powershell
python canvas-coordinator.py "session" pause T-001  # ORANGE → RED
```

### 5. Make Decisions
You decide at key gates:
- **Design approval**: "Is the architecture good?"
- **Code review**: "Does this meet quality standards?"
- **Deployment**: "Are we ready to ship?"

## Your Workflow

### Morning
1. Check status: `python canvas-coordinator.py "session" status`
2. Review proposals (🟣 Purple) → Drag to 🔴 Red if approved
3. Review completed work (🔵 Cyan) → Drag to 🟢 Green if good

### Midday
1. Continue reviews
2. Do your own work if needed: `start T-005` → work → `finish T-005`

### Afternoon
1. More reviews
2. Mark your work GREEN (you approve yourself)

### End of Day
1. Check what's ready: `python canvas-coordinator.py "session" ready`
2. Git commit (code + Project.canvas)

## Decision Gates

### After Design Phase
**Your decision:** "Can we proceed to implementation?"
- ✅ Approve → Implementation starts
- ❌ Reject → Agents revise

### For Each Task
**Your decision:** "Is this acceptable?"
- ✅ Approve (GREEN) → Done
- ❌ Reject (RED) → Redo

### Before Deployment
**Your decision:** "Are we ready to ship?"
- ✅ Yes → You deploy
- ❌ No → Back to development

## What's Tracked

Every action you take is recorded in `status.json`:
```json
{
  "canvas_state": {
    "last_agent": "developer",
    "developer_work": ["T-003", "T-005"]
  },
  "developer_decisions": [
    {
      "timestamp": "2026-03-14T10:30:00Z",
      "action": "approved_T-001",
      "notes": "Code looks good"
    }
  ]
}
```

✅ Complete audit trail of your decisions.

## You Can Always

✅ Approve/reject work anytime  
✅ Pause agents  
✅ Do work yourself  
✅ Edit task descriptions  
✅ Create new tasks  
✅ Manage dependencies  
✅ Make final decisions  

## You Cannot Do (By Design)

❌ Edit `.canvas` JSON directly (use coordinator or Obsidian)  
❌ Delete tasks (persistent record)  
❌ Remove dependencies  
❌ Set cards GREEN automatically  

---

See also:
- [Your Powers](./your-powers.md) — Complete capability list
- [Quick Reference](./quick-reference.md) — Commands cheat sheet
- [Your Workflow](./workflow.md) — Daily patterns
