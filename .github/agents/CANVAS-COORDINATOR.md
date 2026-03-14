# Canvas Coordinator Integration — For All Agents

## Overview

All agents now use a **shared, session-aware Canvas** (`Project.canvas`) via `canvas-coordinator.py`. This replaces direct canvas-tool.py calls and adds automatic session tracking.

## When to Use Canvas Coordinator

- **Coder**: Marks `start` when beginning a task, `finish` when implementation is done
- **Reviewer**: Marks `start` to begin review, `finish` when review is complete
- **QA**: Marks `start` for QA testing, `finish` when tests pass/complete
- **Security**: Marks `start` for security audit, `finish` when audit is done
- **Integrator**: Updates canvas when merging branches/integrating work
- **Architect/Designer/Planner**: Propose tasks initially, may update descriptions
- **SpecAgent**: Creates initial task board in canvas

## Mandatory Pattern

All agents MUST set `AGENT_NAME` environment variable before any canvas operation:

```powershell
$env:AGENT_NAME = "coder"
python canvas-coordinator.py "2026-03-14_session" start T-001
```

Without `$env:AGENT_NAME`, the coordinator cannot track who did what.

## Session Structure

Session format: `YYYY-MM-DD_short-slug`

Example: `2026-03-14_auth-refactor`

All agents working on the same project use the **same session name**.

## Common Operations

### Read operations (no tracking needed)
```powershell
python canvas-coordinator.py "2026-03-14_myproject" status
python canvas-coordinator.py "2026-03-14_myproject" ready
python canvas-coordinator.py "2026-03-14_myproject" show T-001
```

### Write operations (auto-tracked in status.json)
```powershell
$env:AGENT_NAME = "coder"
python canvas-coordinator.py "2026-03-14_myproject" start T-001
python canvas-coordinator.py "2026-03-14_myproject" edit T-001 "Updated: found issue X"
python canvas-coordinator.py "2026-03-14_myproject" finish T-001
```

After each write, `status.json` is updated:
```json
{
  "canvas_state": {
    "last_agent": "coder",
    "last_update": "2026-03-14T10:30:00Z",
    "tasks_assigned": ["T-001", "T-002"]
  }
}
```

## Workflow: From Agent Perspective

### Stage 1: Initialization (SpecAgent + Architect + Designer + Planner)
1. **SpecAgent** reads user input, creates `spec.md` and `acceptance.json`
2. **Architect** reads spec, creates `architecture.md`
3. **Designer** (if needed) reads spec+arch, creates design-specs
4. **Planner** reads everything, creates `tasks.yaml` with color-coded cards in canvas
5. Canvas now has RED cards (ready for work) and GRAY cards (blocked)

### Stage 2: Implementation Loop (Coder → Reviewer → QA → Security)
For each task T-001, T-002, etc.:

1. **Coder**:
   ```powershell
   $env:AGENT_NAME = "coder"
   python canvas-coordinator.py "2026-03-14_x" start T-001      # RED → ORANGE
   # ... implement task ...
   python canvas-coordinator.py "2026-03-14_x" finish T-001     # ORANGE → CYAN
   ```

2. **Reviewer** (per-batch or single-final, per REVIEW_STRATEGY):
   ```powershell
   $env:AGENT_NAME = "reviewer"
   python canvas-coordinator.py "2026-03-14_x" start T-001      # CYAN → ORANGE
   # ... review code ...
   python canvas-coordinator.py "2026-03-14_x" finish T-001     # ORANGE → CYAN
   ```

3. **QA** (if needed):
   ```powershell
   $env:AGENT_NAME = "qa"
   python canvas-coordinator.py "2026-03-14_x" start T-001
   python canvas-coordinator.py "2026-03-14_x" finish T-001
   ```

4. **Security** (if needed):
   ```powershell
   $env:AGENT_NAME = "security"
   python canvas-coordinator.py "2026-03-14_x" start T-001
   python canvas-coordinator.py "2026-03-14_x" finish T-001
   ```

5. **Orchestrator** (human approval):
   - Marks T-001 as GREEN
   - Checks canvas-state in status.json to see who worked on it
   - Moves to next task or integration phase

### Stage 3: Integration & Release (Integrator + Docs)
1. **Integrator** proposes/updates integration tasks, marks complete
2. **Docs** updates documentation as needed
3. Canvas reflects all work completed

## Obsidian Integration

1. Open `Project.canvas` in Obsidian
2. Every time an agent calls `python canvas-coordinator.py`, the `.canvas` JSON is updated
3. Obsidian auto-refreshes the visual board
4. You can see in real-time:
   - 🟣 Purple: Proposed (awaiting approval)
   - 🔴 Red: Ready to start
   - 🟠 Orange: Currently being worked on
   - 🔵 Cyan: Awaiting review
   - 🟢 Green: Complete and verified
   - ⬜ Gray: Blocked (dependencies not met)

## VSCode Integration

1. Set up tasks in `.vscode/tasks.json` (see VSCODE-TASKS.md) to monitor canvas state
2. Quick panel to see "what's ready" and "who's working"
3. Faster context switching between agents

## Troubleshooting

### Canvas not updating?
```powershell
python canvas-coordinator.py "2026-03-14_x" normalize
```

### Lost track of session?
```powershell
# List all sessions
Get-ChildItem .agents-work/
```

### Agent got stuck on ORANGE task?
```powershell
$env:AGENT_NAME = "stuck-agent"
python canvas-coordinator.py "2026-03-14_x" pause T-001  # ORANGE → RED
```

## Reference Commands

| Command | Effect | Agent Visibility |
|---------|--------|------------------|
| `status` | Board overview | All agents see this |
| `ready` | Available tasks | All agents see this |
| `show <ID>` | Task details | All agents see this |
| `start <ID>` | RED → ORANGE | Tracked in status.json |
| `finish <ID>` | ORANGE → CYAN | Tracked in status.json |
| `pause <ID>` | ORANGE → RED | Tracked in status.json |
| `edit <ID> "..."` | Update notes | Only on ORANGE tasks |
| `propose <GROUP> "..." "..."` | Create PURPLE card | Agent proposes, human approves |
| `normalize` | Auto-fix blocked states | Maintenance command |
