# Quick Reference — Canvas Commands

## Essential Commands

### Start of Day
```powershell
# 1. Check what's ready
python canvas-coordinator.py "2026-03-14_myproject" ready

# 2. See full status
python canvas-coordinator.py "2026-03-14_myproject" status

# 3. In Obsidian, open Project.canvas
```

### Pick a Task & Work
```powershell
$env:AGENT_NAME = "coder"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
# 🟠 ORANGE now — You're working

# ... do your work ...

python canvas-coordinator.py "2026-03-14_myproject" finish T-001
# 🔵 CYAN now — Awaiting review
```

### Review / Approve
```powershell
$env:AGENT_NAME = "reviewer"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
# (do review)
python canvas-coordinator.py "2026-03-14_myproject" finish T-001
# (human marks GREEN in Obsidian)
```

---

## VSCode Shortcuts (Ctrl+Shift+B)

```
Canvas: Status              → See overview
Canvas: Ready Tasks         → What can I work on?
Canvas: Start Task          → Begin working
Canvas: Finish Task         → Done with task
Canvas: Show Task Details   → What am I working on?
Canvas: Normalize Board     → Fix blocked states
Session: Create New         → Start new project
Session: List All           → Show all sessions
```

---

## Canvas Colors

| 🟣 | 🔴 | 🟠 | 🔵 | 🟢 | ⬜ |
|----|----|----|----|----|-----|
| Proposed | Ready | Working | Reviewing | Done | Blocked |

---

## Environment Variable

```powershell
# REQUIRED before each command
$env:AGENT_NAME = "coder"        # or reviewer, qa, security, etc.

# Then run commands
python canvas-coordinator.py "session" start T-001
```

---

## Session Naming

Format: `YYYY-MM-DD_short-name`

Examples:
- `2026-03-14_auth-refactor`
- `2026-03-14_payment-integration`
- `2026-03-14_bug-fix`

---

## Files to Know

```
Project.canvas              ← The shared board (Obsidian)
canvas-coordinator.py       ← The CLI tool (run this)
.agents-work/<session>/     ← Session folder
  ├── status.json           ← Auto-updated tracking
  ├── spec.md               ← What to build
  ├── tasks.yaml            ← How to build it
  └── architecture.md       ← System design
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Canvas not updating | `python canvas-coordinator.py "session" normalize` |
| Stuck on ORANGE | `python canvas-coordinator.py "session" pause T-001` |
| Need current session | `Get-ChildItem .agents-work/` |
| Python not found | Check you're in `girlfriendweb/` folder |

---

## Full Documentation

- **Getting Started:** `MULTIAGENT-QUICKSTART.md`
- **Architecture:** `MULTIAGENT-ARCHITECTURE.md`
- **Agent Integration:** `.github/agents/CANVAS-COORDINATOR.md`
- **Canvas Tool:** `.Kanvas-main/README.md`

---

## One-Minute Workflow

```powershell
# 1. See what's ready
python canvas-coordinator.py "2026-03-14_x" ready

# 2. Pick a task
$env:AGENT_NAME = "coder"
python canvas-coordinator.py "2026-03-14_x" start T-001

# 3. Do your work
# (edit files in VSCode)

# 4. Mark done
python canvas-coordinator.py "2026-03-14_x" finish T-001

# 5. Repeat
```

**That's it! 🚀**
