# Troubleshooting Guide

Common issues, how to debug them, and quick fixes.

## Canvas Not Updating

**Problem:** You make changes in VSCode/CLI but Obsidian doesn't show them

**Solution:**
1. Check that Project.canvas file exists and has valid JSON:
   ```bash
   cat Project.canvas | jq
   ```
   If it says "parse error," the JSON is broken

2. Refresh Obsidian:
   - Click on Project.canvas in Obsidian
   - Press Ctrl+R to reload
   - If still not showing, restart Obsidian

3. Check canvas-coordinator.py was called successfully:
   ```bash
   python canvas-coordinator.py "session-slug" show
   ```
   Should print current task state without errors

## Agent Stuck or Not Making Progress

**Problem:** Agent was dispatched but status.json not updating, or agent seems frozen

**Solution:**
1. Check status.json for last_update timestamp:
   ```bash
   cat .agents-work/<session>/status.json | jq .canvas_state.last_update
   ```
   If it's old, agent may have crashed

2. Check agent-results/ folder:
   ```bash
   ls -la .agents-work/<session>/agent-results/
   ```
   If empty, agent hasn't produced output yet

3. Check for errors in canvas-coordinator.py:
   ```bash
   python canvas-coordinator.py "session" status
   ```
   Should show error if something failed

4. Restart agent dispatch:
   - Set status.json: `current_state` back to phase before stuck agent
   - Run orchestrator again

## Task Stuck in ORANGE (Can't Change State)

**Problem:** Card is ORANGE but agent can't finish it (change to CYAN)

**Solution:**
1. Task might be blocked by dependency:
   ```bash
   python canvas-coordinator.py "session" show
   ```
   Look for GRAY tasks that this task depends on

2. Agent might be confused by acceptance criteria:
   - Edit task description in canvas with clearer requirements
   - Add note to status.json: developer_decisions with guidance
   - Pause agent (change ORANGE back to RED)
   - Rerun agent

3. Canvas state might be corrupted:
   ```bash
   # Normalize canvas state
   python canvas-coordinator.py "session" normalize
   ```

## Task Blocked (GRAY) Won't Unblock

**Problem:** Task is GRAY but you think its dependency is done

**Solution:**
1. Check dependencies are correctly set:
   ```bash
   python canvas-coordinator.py "session" show
   ```
   Verify the blocking task is actually GREEN

2. Manually unblock if needed:
   - Remove blocking link in Obsidian (right-click link → delete)
   - Or run:
     ```bash
     python canvas-coordinator.py "session" unblock TASK-ID
     ```

3. If dependency is done but still showing GRAY:
   - Normalize state:
     ```bash
     python canvas-coordinator.py "session" normalize
     ```

## Session Not Creating

**Problem:** Can't create new session; command fails or folder not created

**Solution:**
1. Check .agents-work directory exists:
   ```bash
   ls -la .agents-work/
   ```
   If not, create it:
   ```bash
   mkdir -p .agents-work
   ```

2. Check session-template exists:
   ```bash
   ls -la .agents-work/session-template/
   ```
   Should have: status.json, spec.md, tasks.yaml, architecture.md

3. Try creating session manually:
   ```bash
   mkdir .agents-work/2026-03-14_test
   cp .agents-work/session-template/* .agents-work/2026-03-14_test/
   ```

4. Edit status.json: change session_id to "2026-03-14_test"

## Approval Commands Not Working

**Problem:** `canvas-coordinator approve` or `finish` command does nothing or errors

**Solution:**
1. Check command syntax:
   ```bash
   python canvas-coordinator.py "session-slug" approve T-001
   # Correct format: session name, command, task ID
   ```

2. Check task exists in canvas:
   ```bash
   python canvas-coordinator.py "session-slug" show | grep T-001
   ```

3. Check AGENT_NAME env var is set (for tracking):
   ```bash
   export AGENT_NAME="developer"
   python canvas-coordinator.py "session-slug" approve T-001
   ```

## Canvas Coordinator Not Found

**Problem:** Command says "canvas-coordinator.py: command not found"

**Solution:**
1. Check file exists:
   ```bash
   ls -la girlfriendweb/canvas-coordinator.py
   ```

2. Make sure you're in correct directory:
   ```bash
   pwd  # Should show .../girlfriendweb/
   ```

3. Try with full path:
   ```bash
   python ./canvas-coordinator.py "session" status
   ```

4. Check Python version:
   ```bash
   python --version  # Should be 3.8+
   ```

## status.json Gets Out of Sync

**Problem:** status.json doesn't match what's in canvas or vice versa

**Solution:**
1. Resync from canvas source:
   ```bash
   python canvas-coordinator.py "session" sync
   ```
   This reads Project.canvas and updates status.json

2. Or manually edit status.json:
   - Open .agents-work/<session>/status.json
   - Update tasks_assigned, tasks_completed arrays
   - Update last_agent, last_update to current values

3. After edits, verify:
   ```bash
   python canvas-coordinator.py "session" status
   # Should show no conflicts
   ```

## Obsidian Shows Old Project.canvas

**Problem:** You see stale data in Obsidian even though Project.canvas file is updated

**Solution:**
1. In Obsidian, click on Project.canvas in file list (left sidebar)

2. Force reload:
   - Click hamburger menu (top left)
   - Select "Reload" or press F5

3. Restart Obsidian completely if above doesn't work

4. Check file modification time:
   ```bash
   ls -l Project.canvas
   # Recent timestamp = file was just updated
   ```

## Git Conflicts When Committing

**Problem:** Git says Project.canvas has conflicts

**Solution:**
1. This happens if agents modify canvas while you're also editing

2. Abort current changes:
   ```bash
   git merge --abort  # If in merge
   git rebase --abort  # If in rebase
   ```

3. Pull latest:
   ```bash
   git pull origin main
   ```

4. Check for uncommitted changes:
   ```bash
   git status
   ```
   If Project.canvas shows modified, stash them:
   ```bash
   git stash
   ```

5. Try again:
   ```bash
   git add Project.canvas
   git commit -m "Update canvas: [task description]"
   ```

## Orchestrator Won't Start

**Problem:** Starting orchestrator says error or doesn't dispatch agents

**Solution:**
1. Check spec.md exists and is readable:
   ```bash
   cat .agents-work/<session>/spec.md
   ```

2. Check status.json is valid JSON:
   ```bash
   cat .agents-work/<session>/status.json | jq .
   ```

3. Check current_state in status.json is valid:
   ```bash
   cat .agents-work/<session>/status.json | jq .current_state
   # Should output: "INTAKE", "DESIGN", "PLAN", "IMPLEMENT_LOOP", etc
   ```

4. Try dry-run:
   ```bash
   python canvas-coordinator.py "session" show
   # This validates setup without dispatching
   ```

## Agent Spends Too Long on Simple Task

**Problem:** Agent seems stuck working on a task that should be quick

**Solution:**
1. Check task description isn't ambiguous:
   - Edit canvas card description
   - Make acceptance criteria very clear

2. Pause and redirect:
   ```bash
   python canvas-coordinator.py "session" pause TASK-ID
   # Changes ORANGE back to RED
   ```

3. Add guidance in status.json:
   ```json
   {
     "developer_decisions": [
       {
         "action": "task_guidance",
         "task_id": "T-001",
         "message": "Keep it simple: just do X, don't do Y"
       }
     ]
   }
   ```

4. Resume agent or reassign

## Canvas-tool.py Errors

**Problem:** Command fails with "canvas-tool.py" not found or similar

**Solution:**
1. Check .Kanvas-main exists:
   ```bash
   ls -la .Kanvas-main/
   ```

2. Check canvas-tool.py is in right location:
   ```bash
   find . -name "canvas-tool.py"
   ```

3. Update canvas-coordinator.py if path is wrong:
   - Edit canvas-coordinator.py
   - Find line: `canvas_tool_path = ...`
   - Update to correct path

4. Verify canvas-tool.py works directly:
   ```bash
   python .Kanvas-main/canvas-tool.py --help
   ```

---

## Getting More Help

**Check logs:**
- status.json: last_agent, last_update, current_state
- Project.canvas: raw JSON with all tasks
- agent-results/: outputs from last agent

**Debug mode:**
```bash
export DEBUG=1
python canvas-coordinator.py "session" status
# Prints detailed info about operations
```

**Reset session:**
If session is severely broken, you can restart:
```bash
# Back up current work
cp -r .agents-work/<session> .agents-work/<session>-backup

# Reset status.json
cp .agents-work/session-template/status.json .agents-work/<session>/status.json

# Edit session_id in status.json to match session
```

---

See also:
- [Canvas Workflow](../reference/canvas-workflow.md) — State transitions
- [Architecture](../reference/architecture.md) — System design
- [Sessions](./session-setup.md) — Session structure
