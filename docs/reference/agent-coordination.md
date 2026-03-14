# Agent Coordination

How the 11+ agents work together, how they discover tasks, and their interaction protocols.

## The 11 Agents

| Agent | Role | Inputs | Outputs | When Active |
|-------|------|--------|---------|------------|
| Architect | System design | Spec, requirements | Architecture.md, design decisions | Phase: DESIGN |
| Planner | Task breakdown | Architecture, spec | Tasks.yaml, acceptance criteria | Phase: PLAN |
| Coder | Implementation | Tasks, acceptance criteria | Code, test cases | Phase: IMPLEMENT |
| Reviewer | Code review | Code, acceptance criteria, style guide | Review report, approval/requests | Phase: REVIEW |
| QA | Testing | Code, test cases, acceptance criteria | Test results, bugs found | Phase: QA |
| Security | Audit | Code, architecture | Security report, risks found | Phase: SECURITY |
| Integrator | Merging & CI/CD | Code, tests, approvals | Merged code, deployed | Phase: INTEGRATE |
| Designer | UI/UX | Requirements, user flows | Designs, wireframes | Phase: DESIGN (parallel) |
| SpecAgent | Specification | Requirements, context | Specification.md | Phase: INTAKE |
| Researcher | Investigation | Questions, requirements | Research.md, findings | Phase: INTAKE |
| Docs | Documentation | Code, requirements | README, API docs, guides | Phase: RELEASE |
| Orchestrator | Coordination | Project spec, status | Dispatches agents, tracks progress | All phases |

## Dispatch Protocol

### The Orchestrator Loop

```
START SESSION
  ↓
1. Load session/spec.md (user's requirements)
2. Load session/status.json (current workflow state)
3. Determine which agent should work next (based on current_state)
4. Build agent context:
   - Project spec
   - Canvas (current task state)
   - Previous agent results
   - User guidelines/feedback
5. Dispatch agent via runSubagent()
6. Wait for completion (BLOCKING - true seq)
7. Agent updates canvas:
   - Changes task colors
   - Calls canvas-coordinator.py
8. Save agent results to .agents-work/<session>/agent-results/
9. Update status.json (last_agent, timestamp, tasks_completed)
10. Check for gates or user decisions needed
11. Loop back to step 2 (or HALT if at decision gate)
```

### Task Discovery (How Agents Know What to Do)

**Agent receives:**
1. Session spec (project overview)
2. Current canvas state (all tasks, colors)
3. Acceptance criteria for their phase
4. Guidelines from you (stored in status.json)

**Agent logic:**
```
1. Read canvas
2. Find RED tasks in my domain (Coder finds red CODE tasks)
3. Check dependencies: any GRAY blockers? (If yes, skip)
4. Pick one RED task
5. Change color to ORANGE (using canvas-coordinator "start")
6. Do the work
7. When done, change to CYAN (using canvas-coordinator "finish")
```

**Reviewer's special logic:**
```
1. Find ORANGE (code) tasks
2. If status.json has review_strategy == "light":
   - Spot check, change to CYAN
3. If review_strategy == "thorough":
   - Full review, test locally, change to CYAN
4. If review_strategy == "skipme":
   - Automatically approve, change to GREEN
```

### Decision Gates (Where Orchestrator Pauses)

```
✋ INTAKE → SpecAgent produces spec → PAUSE
   [YOU: Approve spec or request changes]

✋ DESIGN → Architect produces design → PAUSE
   [YOU: Approve architecture or send back]

✋ STRATEGY → Orchestrator offers workflows → PAUSE
   [YOU: Choose Standard/Lean/Parallel]
```

At each gate:
- Orchestrator stops dispatching
- Sets status.json: `waiting_for: "user_decision"`
- You review work in Obsidian
- You give feedback or approval
- You run: `python canvas-coordinator.py "session" approve <task-id>`
- Orchestrator resumes

## Interaction Protocol

### Agent → Canvas

**Every agent must:**
1. Read tasks from canvas
2. Claim a RED task: change to ORANGE
3. Do the work
4. Mark done: change to CYAN (awaiting approval)
5. Optionally change to GREEN if self-approved

**Code pattern:**
```python
# Agent runs this
import subprocess

def start_task(session, task_id, agent_name):
    cmd = [
        "python", "canvas-coordinator.py",
        session,
        "start", task_id,
        "--agent", agent_name
    ]
    subprocess.run(cmd)

def finish_task(session, task_id):
    cmd = [
        "python", "canvas-coordinator.py",
        session,
        "finish", task_id
    ]
    subprocess.run(cmd)
```

### You → Canvas

**You can:**
1. Drag cards in Obsidian (change colors manually)
2. Run CLI commands via VSCode tasks
3. Add guidance: edit task descriptions
4. Pause agents: drag ORANGE task back to RED
5. Approve work: drag CYAN to GREEN
6. Respond to gates: run `approve` command

### Canvas → Agents

**Agents periodically check:**
```
RED tasks (ready to work on)
ORANGE tasks (in progress - theirs?)
CYAN tasks (awaiting approval)
GRAY tasks (blocked - can't work)
```

Agents read canvas via:
```bash
# Via CLI
python canvas-coordinator.py "session" show

# Via JSON file
cat Project.canvas | jq
```

## Dependency & Blocking

### How Blocking Works

```
Task A: "Design API" (Architect task)
  ↓ (links to)
Task B: "Implement API" (Coder task)

Status:
- If A is GREEN → B can go to RED and be worked on
- If A is ORANGE or RED → B automatically becomes GRAY
- If B gets dragged to ORANGE while A is not GREEN → System should block
```

### Setting Dependencies

**In Obsidian:**
1. Create task A
2. Create task B
3. Draw link from B to A (means "B depends on A")
4. Canvas-tool detects this and blocks B automatically

**In CLI:**
```bash
python canvas-coordinator.py "session" link B A  # B depends on A
```

## Conflict Resolution

### What if two agents want the same task?

**Solution: First one wins (atomic)**
```
Agent A reads canvas: Task RED
Agent A: "I'll do this"
Agent A: canvas-coordinator start T-001 --agent "coder"
  ✅ Canvas: T-001 is now ORANGE for coder

Agent B reads canvas (stale): Task RED
Agent B: "I'll do this too"
Agent B: canvas-coordinator start T-001 --agent "reviewer"
  ❌ CONFLICT: Task already ORANGE (coder working)
  → System says "Task already in progress" (error)
  → Agent B picks different task

Result: No race condition - first agent to send command wins
```

## Information Flow Diagram

```
                    PROJECT.CANVAS (JSON)
                    ↑         ↑        ↑
           ┌────────┘         │        └────────┐
           │                  │                 │
           ↓                  ↓                 ↓
       OBSIDIAN        AGENTS (11+)      DEVELOPER (you)
       (Visual UI)    (via CLI)          (UI + CLI)
           ↓                  ↓                 ↓
         Watch        canvas-coordinator.py   Drag/Edit
         See colors   Update canvas          Run tasks
         Drag cards   Track in status.json   Approve work
           │                  │                 │
           └────────┬────────┬┴────────┬────────┘
                    │        │        │
                    ↓        ↓        ↓
             .agents-work/<session>/
             ├── status.json (auto-updated)
             ├── agent-results/ (outputs)
             ├── Project.canvas (shared state)
             └── tasks.yaml (reference)
```

## Performance & Scaling

**Sequential execution means:**
- ✅ Simple: No concurrent locks
- ✅ Predictable: One agent at a time
- ⏱ Slower: 11 agents × 2 hours each = 22 hours minimum per project
- ✅ Reliable: No merge conflicts on canvas

**For faster cycles:**
- Lean workflows (skip agents)
- Parallel dispatch (multiple sessions for different features)
- Agent caching (reuse previous results)

## Agent Communication

Agents DON'T talk to each other directly. Instead:

```
Agent A creates output
  ↓
writes to .agents-work/<session>/agent-results/a.md
  ↓
Orchestrator reads .agents-work/<session>/agent-results/a.md
  ↓
Orchestrator provides to Agent B in context
  ↓
Agent B uses that info for their work
```

**Example:**
```
Architect writes: architecture.md
  ↓
Coder receives architecture.md as context
  ↓
Coder asks: "What database should I use?"
  ↓
Coder reads from architecture.md: "PostgreSQL"
  ↓
Coder implements with PostgreSQL
```

---

See also:
- [Architecture](./architecture.md) — System design
- [Canvas Workflow](./canvas-workflow.md) — State transitions
- [Your Role](../developer/your-role.md) — Your part in coordination
