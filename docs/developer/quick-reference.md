# Quick Reference — Your Commands

**Bookmark this page!** All your commands in one place.

## Check Status

```powershell
# Full board status
python canvas-coordinator.py "session" status

# What's ready to work on
python canvas-coordinator.py "session" ready

# What's waiting for dependencies
python canvas-coordinator.py "session" blocked

# Full task details
python canvas-coordinator.py "session" show T-001
```

## Approve Work

**In Obsidian (visual, faster):**
1. See 🔵 CYAN card (agent finished)
2. Drag to 🟢 GREEN (you approve)
3. Or drag back to 🔴 RED (needs work)

## You Start Working

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-001
# Card turns 🟠 ORANGE
```

## You Finish Working

```powershell
python canvas-coordinator.py "session" finish T-001
# Card turns 🔵 CYAN
# Go to Obsidian and drag to 🟢 GREEN (you approve yourself)
```

## Pause an Agent

```powershell
python canvas-coordinator.py "session" pause T-001
# Card goes 🟠 ORANGE → 🔴 RED
```

## Edit Task Descriptions

```powershell
python canvas-coordinator.py "session" edit T-001 "New instructions for agent"
# Only works if card is 🟠 ORANGE (in progress)
```

## Create a New Task

```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" propose "Group" "Task title" "Description"
# Creates 🟣 PURPLE card (awaiting your approval)
```

## Check Session History

```powershell
# Open and read (format: JSON)
cat .agents-work/session/status.json | ConvertFrom-Json
# See: who worked, when, what decisions were made
```

## VSCode Tasks (Ctrl+Shift+B)

| Task | What |
|------|------|
| Developer: Start Working | Begin a task |
| Developer: Finish Working | Mark done |
| Developer: Pause Agent Task | Stop agent |
| Developer: Edit Task Guidance | Better instructions |
| Developer: View Progress | Full status |
| Developer: See What's Blocked | Blocked tasks |
| Developer: See What's Ready | Ready tasks |

## Canvas Colors

| Color | Meaning | Your Action |
|-------|---------|------------|
| 🟣 Purple | Proposed | Approve (drag→Red) or reject |
| 🔴 Red | Ready | Wait for agent or start yourself |
| 🟠 Orange | Working | Monitor or pause |
| 🔵 Cyan | Done | Approve (drag→Green) or reject |
| 🟢 Green | Approved | Done! |
| ⬜ Gray | Blocked | Auto-managed |

## Sessions

```powershell
# Create new session
.\init-session.ps1 -SessionName "myproject"

# List all sessions
Get-ChildItem .agents-work/
```

## Git Workflow

```powershell
# After approving a task
git add .
git commit -m "T-001: Task name

- Changes made
- Files modified
- Canvas updated"
```

## One-Minute Workflow

```powershell
# 1. See what's ready
python canvas-coordinator.py "session" ready

# 2. Start work
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "session" start T-001

# 3. Do your work (edit files)

# 4. Mark done
python canvas-coordinator.py "session" finish T-001

# 5. Approve (in Obsidian: drag to GREEN)
```

---

All commands start with:
```powershell
python canvas-coordinator.py "session-name" COMMAND
```

Set session name as: `2026-03-14_myproject`

---

**See also:** [Your Role](./your-role.md) | [Your Powers](./your-powers.md) | [Workflow](./workflow.md)
