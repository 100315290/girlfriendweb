# Canvas Workflow Details

In-depth guide to canvas states, transitions, and how to work with canvas colors.

## Task States (Colors)

| Color | State | Meaning | Who can change |
|-------|-------|---------|---------------|
| 🟣 Purple | Proposed | Suggested task, not approved | Anyone (but developer must make final decision) |
| 🔴 Red | Ready | Approved and waiting to start | Agents (→ Orange when start), Developer |
| 🟠 Orange | Working | In progress | Agent or Developer working on it |
| 🔵 Cyan | Review | Awaiting review or approval | Reviewers (if working), Developer (for approval) |
| 🟢 Green | Done | Completed and approved | Final approval by Developer |
| ⬜ Gray | Blocked | Blocked by dependencies | Auto-managed; clears when dependencies clear |

## Task Lifecycle

```
CREATE
  ↓
  🟣 Purple (Someone proposes task)
  ↓ [Developer reviews]
  🔴 Red (Developer approves starting)
  ↓ [Someone starts work]
  🟠 Orange (In progress)
  ├─ [Pause] → 🔴 Red
  ├─ [Abandon] → 🟣 Purple
  └─ [Finish working] → 🔵 Cyan (Awaiting review/approval)
      ↓ [Reviewer examines]
      🟠 Orange (Reviewing)
      └─ [Finish review] → 🔵 Cyan (Ready for approval)
        ↓ [Developer says OK]
        🟢 Green (Done!)
```

## Blocking & Dependencies

**Gray (Blocked) State:**
- Auto-triggered when a task has unmet dependencies
- Dependencies are **links** in canvas between tasks
- When dependency goes 🟢 Green → blocks clear automatically
- Cannot start blocked task (orange) until block clears

**How to block:**
1. Create link from dependent task → blocking task
2. Canvas-coordinator automatically sets to 🔵 Gray if blocker not green

**How to unblock:**
1. Complete blocker task (→ 🟢 Green)
2. System auto-clears block
3. Dependent task returns to previous state

## Workflows (Decision Points)

### Standard Workflow
```
DESIGN → APPROVE → PLAN → CODE → REVIEW → QA → SECURITY → INTEGRATE → RELEASE → DONE

Color sequence per task:
Purple (proposed) 
  → Red (design approved)
  → Orange (coding)
  → Cyan (review pending)
  → Orange (reviewing)
  → Cyan (approval pending)
  → Green (approved)
```

### Lean Workflow (for simple changes)
```
INTAKE → PLAN → CODE → INTEGRATE → RELEASE → DONE

Skips: DESIGN, APPROVAL, QA, SECURITY
Color sequence per task:
Purple (proposed)
  → Red (ready)
  → Orange (coding)
  → Cyan (review)
  → Green (done)
```

### Parallel Workflow (for independent features)
```
FEATURE-A TRACK:          FEATURE-B TRACK:        FEATURE-C TRACK:
Design → Code → Review    Design → Code → Review  Design → Code → Review
  ↓                         ↓                       ↓
  └─────────────── INTEGRATE ───────────────┘
       ↓
    RELEASE → DONE
```

- Multiple features work in parallel ✅
- Each has own color sequence
- Integrate gate when all features ready (links between them)

## Color Change Commands

```bash
# Check current state
python canvas-coordinator.py "dev-session" show T-001

# Change to RED (ready to work)
python canvas-coordinator.py "dev-session" ready T-001

# Change to ORANGE (start working)
python canvas-coordinator.py "dev-session" start T-001

# Pause (back to RED)
python canvas-coordinator.py "dev-session" pause T-001

# Change to CYAN (awaiting review/approval)
python canvas-coordinator.py "dev-session" finish T-001

# Change to GREEN (approved, done)
# Manual: Drag in Obsidian or use agent approval
# Command: (through acceptance logic or manual drag)

# Block task (typically automatic, but manual if needed)
python canvas-coordinator.py "dev-session" block T-001
```

## Practical Examples

### Example 1: You Approve Design
```
Design document in PURPLE (Proposed)
You review in Obsidian
  ↓
You drag card to RED (Ready)
  ↓
Coder sees RED, starts working
  ↓
Coder changes to ORANGE (Working)
```
**Canvas shows:** Design RED → Coder starts → Design ORANGE

### Example 2: Code Review & Approval
```
Code task in ORANGE (Coder working)
Coder finishes, changes to CYAN (Awaiting Review)
  ↓
Reviewer sees CYAN, starts review
  ↓
Reviewer changes to ORANGE (Reviewing)
  ↓
Reviewer finishes, changes to CYAN (Awaiting Approval)
  ↓
You see CYAN, review reviewer's comments
  ↓
You drag to GREEN (Approved, Done)
```
**Canvas shows task progression:** ORANGE → CYAN → ORANGE → CYAN → GREEN

### Example 3: Blocked Task (Dependency)
```
TASK-B depends on TASK-A

Initial: TASK-A = RED, TASK-B = RED

TASK-A starts: RED → ORANGE

System detects TASK-B has unmet dependency
TASK-B auto-changes: RED → GRAY (Blocked)

You see in Obsidian:
  TASK-B is GRAY (can't start it)

TASK-A completes: ORANGE → CYAN → GREEN

System clears block:
  TASK-B: GRAY → RED (now you can start it)
```

### Example 4: You Work Yourself
```
Agent finishes a task, changes to CYAN
You review and decide to improve it
  ↓
You drag to ORANGE (You're working on it)
  ↓
System records in status.json: developer_work: ["TASK-001"]
  ↓
You finish improving, change to CYAN
  ↓
You approve your own work: drag to GREEN
```
**Canvas shows:** CYAN → ORANGE (you) → CYAN → GREEN

## Best Practices

✅ **Use links for dependencies** — Don't rely on task names; create visual links  
✅ **Drag vs command** — Either is fine; Obsidian drag is visual, commands are scriptable  
✅ **Color means state** — Everyone looks at Obsidian, color is universal language  
✅ **One task per card** — Don't bundle multiple items in one card  
✅ **Descriptive titles** — Include ticket/issue number if applicable  
✅ **Group by phase** — Organize cards into Design/Code/Review/Release groups  
✅ **Links show workflow** — A → B → C helps visualize progression  

## Troubleshooting

**Task stuck in ORANGE?**
- Agent might have abandoned it
- Check status.json for last_agent and timestamp
- Manually drag to RED if you want to reassign

**Task went to GRAY unexpectedly?**
- Check for blocking links
- Ensure blocker task is actually needed
- Change blocker to GREEN or remove link

**Color not changing in VSCode?**
- Obsidian watches file for changes
- Refresh Obsidian or check Project.canvas file
- Commands work even if Obsidian hasn't updated yet

---

See also:
- [Architecture](./architecture.md) — System design
- [Agent Coordination](./agent-coordination.md) — How agents interact
- [Developer Reference](../developer/quick-reference.md) — Quick commands
