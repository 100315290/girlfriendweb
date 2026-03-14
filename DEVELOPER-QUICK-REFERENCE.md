# Your Role as Developer — Quick Summary

## You Are In Control

This multi-agent system works FOR you, not the other way around.

```
┌─────────────────────────────────────────┐
│         YOU (Developer)                  │
│                                         │
│  Make decisions                         │
│  Approve/reject work                    │
│  Do manual work                         │
│  Guide agents                           │
└──────────────────┬──────────────────────┘
                   │ You control via:
         ┌─────────┼─────────┐
         ▼         ▼         ▼
    Project   VSCode    Obsidian
    Canvas    Tasks     Drag/drop
```

---

## Your Powers

| Power | How | Command |
|-------|-----|---------|
| **Approve proposals** | Drag Purple → Red in Obsidian | (Visual) |
| **Approve completed work** | Drag Cyan → Green in Obsidian | (Visual) |
| **Do work yourself** | Set to Orange, work, finish | `start T-001` → work → `finish T-001` |
| **Pause agents** | Stop their current task | `pause T-001` |
| **Guide agents** | Edit task descriptions | `edit T-001 "Better instructions"` |
| **Check progress** | View status anytime | `status`, `ready`, `blocked` |
| **Propose tasks** | Create work for agents (or yourself) | `propose ...` |

---

## Your Day

### Morning
```
1. Check status:    python canvas-coordinator.py "session" status
2. Review work:     Look at VSCode (changes from yesterday)
3. Approve/reject:  Drag cards in Obsidian (Purple→Red, Cyan→Green)
```

### Midday
```
1. Review agent work (CYAN cards)
2. Drag to GREEN if good, RED if needs work
3. Start your own task if needed: start T-005
```

### Afternoon
```
1. Continue reviewing agent work
2. Finish your own work: finish T-005
3. Drag your work to GREEN (you approve yourself)
```

### End of Day
```
1. Check what's ready: python canvas-coordinator.py "session" ready
2. Check what's blocked: python canvas-coordinator.py "session" blocked
3. Git commit (code + Project.canvas)
```

---

## VSCode Tasks for You

Press `Ctrl+Shift+B` and look for:

- **Developer: Start Working** — You begin a task
- **Developer: Finish Working** — You mark your task done
- **Developer: Pause Agent Task** — Stop an agent mid-work
- **Developer: Edit Task Guidance** — Give agents better instructions
- **Developer: View Progress** — See full status
- **Developer: See What's Blocked** — What's waiting
- **Developer: See What's Ready** — What can start

---

## In Obsidian

**You control the board visually:**

1. **🟣 Purple** (Proposed) → **Drag to 🔴 Red** if you approve it
2. **🟠 Orange** (Working) → **Leave it** (agent is working)
3. **🔵 Cyan** (Done) → **Drag to 🟢 Green** if you approve it
4. **🟢 Green** (Approved) → **Done!** Move on
5. **⬜ Gray** (Blocked) → **Automatically manages** (don't worry)

---

## Decision Points

### You Must Decide: Design
After Architect/Designer finish:
- ✅ Review architecture + design specs
- ✅ Approve to move forward (or request changes)
- ✅ This happens early, prevents rework

### You Must Decide: Each Task
When agents mark tasks CYAN:
- ✅ Review their work
- ✅ Approve (GREEN) or reject (RED)
- ✅ This is your quality gate

### You Must Decide: Deployment
When all work is GREEN:
- ✅ You deploy (manual step, agents don't)
- ✅ You tag releases
- ✅ You're responsible for the decision

---

## What Gets Tracked

Every time you interact:

```json
{
  "canvas_state": {
    "last_agent": "developer",           // ← You're recorded
    "developer_work": ["T-003", "T-005"] // ← Tasks you did
  },
  "developer_decisions": [
    {
      "decision": "approved_design",
      "timestamp": "2026-03-14T10:30:00Z",
      "notes": "Architecture looks good, proceed with implementation"
    }
  ]
}
```

**You have a complete record of your decisions.**

---

## You Can Always

✅ Pause agent work (`pause T-001`)  
✅ Review work anytime (`status`, `ready`, `blocked`)  
✅ Do work yourself (just set to Orange)  
✅ Approve/reject in Obsidian (drag cards)  
✅ Guide agents (edit task descriptions)  
✅ Create new tasks (propose)  
✅ Manage dependencies (draw arrows in Obsidian)  

---

## Quick Reference: Your Commands

```powershell
# Check status
python canvas-coordinator.py "session" status

# See what's ready to work on
python canvas-coordinator.py "session" ready

# See what's blocked and why
python canvas-coordinator.py "session" blocked

# Start your own work
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-001

# Finish your work
python canvas-coordinator.py "session" finish T-001

# Pause an agent
python canvas-coordinator.py "session" pause T-001

# Guide an agent with better instructions
python canvas-coordinator.py "session" edit T-001 "Use async/await pattern"

# Create a new task
python canvas-coordinator.py "session" propose "Backend" "Task title" "Description"
```

---

## Golden Rules

1. **You approve everything** (Purple→Red, Cyan→Green)
2. **You can work anytime** (set to Orange yourself)
3. **You can pause anytime** (stop agents mid-task)
4. **You decide what's built** (create tasks, set priorities)
5. **You own the decisions** (all recorded in status.json)

---

## You're the Boss 🎖️

Agents are tools to help you ship faster. Use them:
- ✅ For coding (Coder)
- ✅ For reviewing (Reviewer)
- ✅ For testing (QA)
- ✅ For security (Security)
- ✅ For docs (Docs)

But YOU decide everything else. You're in control.

**Ready to orchestrate? 🚀**
