#!/usr/bin/env python3
"""
canvas-coordinator.py — Session-aware wrapper around canvas-tool.py

Adds session tracking and agent coordination without modifying canvas-tool.py directly.
Updates status.json after each canvas operation to track which agent did what.

Usage:
  python canvas-coordinator.py <session> status                 # Read board
  python canvas-coordinator.py <session> start <TASK-ID>        # Start task
  python canvas-coordinator.py <session> finish <TASK-ID>       # Finish task
  python canvas-coordinator.py <session> propose ...            # Propose task
"""

import json
import sys
import os
import subprocess
import datetime
from pathlib import Path

# Get agent name from environment or CLI
AGENT_NAME = os.environ.get("AGENT_NAME", "unknown")

def get_status_file(session):
    """Return path to status.json for a session."""
    return f".agents-work/{session}/status.json"

def get_canvas_file(session=None):
    """Return path to Project.canvas (shared, not session-scoped)."""
    return "Project.canvas"

def load_status(session):
    """Load status.json for a session."""
    path = get_status_file(session)
    if not os.path.exists(path):
        return None
    with open(path, "r") as f:
        return json.load(f)

def save_status(session, status):
    """Save status.json for a session."""
    path = get_status_file(session)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(status, f, indent=2)

def call_canvas_tool(session, *args):
    """Call canvas-tool.py and return output."""
    canvas_path = get_canvas_file(session)
    cmd = ["python", ".Kanvas-main/canvas-tool.py", canvas_path] + list(args)
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode, result.stdout, result.stderr

def update_canvas_state(session, agent, operation, task_id=None):
    """Update status.json with latest canvas operation."""
    status = load_status(session)
    if not status:
        return
    
    status["canvas_state"]["last_agent"] = agent
    status["canvas_state"]["last_update"] = datetime.datetime.utcnow().isoformat() + "Z"
    if task_id and task_id not in status["canvas_state"]["tasks_assigned"]:
        status["canvas_state"]["tasks_assigned"].append(task_id)
    
    # Track developer work separately
    if agent == "developer":
        if "developer_work" not in status["canvas_state"]:
            status["canvas_state"]["developer_work"] = []
        if task_id and task_id not in status["canvas_state"]["developer_work"]:
            status["canvas_state"]["developer_work"].append(task_id)
    
    save_status(session, status)

def main():
    if len(sys.argv) < 3:
        print("Usage: python canvas-coordinator.py <session> <command> [args...]")
        sys.exit(1)
    
    session = sys.argv[1]
    command = sys.argv[2]
    args = sys.argv[3:] if len(sys.argv) > 3 else []
    
    # Read-only commands don't need tracking
    if command in ["status", "show", "list", "blocked", "blocking", "ready", "dump"]:
        rc, out, err = call_canvas_tool(session, command, *args)
        print(out, end="")
        if err:
            print(err, file=sys.stderr, end="")
        sys.exit(rc)
    
    # Write commands: update status after
    if command in ["start", "finish", "pause", "edit", "propose", "batch", "add-dep"]:
        rc, out, err = call_canvas_tool(session, command, *args)
        
        # Extract task ID if available
        task_id = args[0] if args else None
        
        # Track in status.json
        update_canvas_state(session, AGENT_NAME, command, task_id)
        
        print(out, end="")
        if err:
            print(err, file=sys.stderr, end="")
        sys.exit(rc)
    
    # Normalize is maintenance
    if command == "normalize":
        rc, out, err = call_canvas_tool(session, command, *args)
        update_canvas_state(session, AGENT_NAME, "normalize")
        print(out, end="")
        if err:
            print(err, file=sys.stderr, end="")
        sys.exit(rc)
    
    print(f"Unknown command: {command}", file=sys.stderr)
    sys.exit(1)

if __name__ == "__main__":
    main()
