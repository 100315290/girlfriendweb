# Quickstart Guide

Get up and running in 5 minutes.

## Step 1: Create a Session

```powershell
.\init-session.ps1 -SessionName "myproject"
# Creates: .agents-work/2026-03-14_myproject/
```

Or manually:
```powershell
$date = Get-Date -Format "yyyy-MM-dd"
mkdir ".agents-work/$date`_myproject/agent-results"
Copy-Item ".agents-work/session-template/status.json" ".agents-work/$date`_myproject/status.json"
```

## Step 2: Open Canvas

1. Open Obsidian with `girlfriendweb/` vault
2. Open `Project.canvas`
3. Leave it visible alongside VSCode

## Step 3: Start Working

### See what's ready
```powershell
python canvas-coordinator.py "2026-03-14_myproject" ready
```

### You start a task
```powershell
$env:AGENT_NAME = "developer"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
# Card turns 🟠 ORANGE
```

### You do the work
(Edit files in VSCode, implement feature, etc.)

### You finish
```powershell
python canvas-coordinator.py "2026-03-14_myproject" finish T-001
# Card turns 🔵 CYAN
```

### You approve
In Obsidian, drag the card to 🟢 GREEN

## Step 4: Watch in Real-Time

As you or agents work, Obsidian updates live. You'll see:
- 🟣 Purple = Proposed tasks
- 🔴 Red = Ready to start
- 🟠 Orange = Someone working
- 🔵 Cyan = Done, awaiting approval
- 🟢 Green = Approved ✓
- ⬜ Gray = Blocked (waiting for dependencies)

## Next Steps

- [Your Role](../developer/your-role.md) — Understand your control
- [Your Quick Reference](../developer/quick-reference.md) — Commands cheat sheet
- [First Session Details](./first-session.md) — Detailed walkthrough

**That's it! You're ready to work with multiple agents. 🚀**
