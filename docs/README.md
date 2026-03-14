# Documentation Index

Welcome to the girlfriendweb multi-agent system documentation.

## 📍 Quick Navigation

### 🚀 Getting Started
Start here if you're new to the system.
- [Quickstart](./getting-started/quickstart.md) — 5-minute setup guide
- [First Session](./getting-started/first-session.md) — Your first project
- [Initial Setup](./getting-started/setup.md) — Environment configuration

### 👤 For Developers (You)
Your complete guide to controlling the system.
- [Your Role](./developer/your-role.md) — What you can do and your authority
- [Your Powers](./developer/your-powers.md) — Complete list of capabilities
- [Quick Reference](./developer/quick-reference.md) — Cheat sheet (bookmark this!)
- [Your Workflow](./developer/workflow.md) — Daily workflow patterns

### 📚 Reference Documentation
Deep dive into how the system works.
- [System Architecture](./reference/architecture.md) — How everything fits together
- [Canvas Workflow](./reference/canvas-workflow.md) — State machine and color meanings
- [Canvas Commands](./reference/canvas-commands.md) — Complete CLI reference
- [Agent Coordination](./reference/agent-coordination.md) — How agents work together

### 🤖 Agent Documentation
Information about agents and their integration.
- [Agent Index](./agents/index.md) — All available agents
- [Canvas Coordinator](./agents/canvas-coordinator.md) — Session-aware CLI tool
- [Agent Integration](./agents/integration.md) — How agents interact with the system

### 📂 Session Management
Everything about sessions and tracking.
- [Session Setup](./sessions/session-setup.md) — Creating and initializing sessions
- [Session Structure](./sessions/session-structure.md) — Folder layout and artifacts
- [Status Tracking](./sessions/status-tracking.md) — How progress is recorded

### ❓ Troubleshooting
When things don't work as expected.
- [Common Issues](./troubleshooting/common-issues.md) — FAQ and solutions
- [Debugging](./troubleshooting/debugging.md) — How to debug problems

---

## 📊 Documentation Organization

```
docs/
├── getting-started/          # For new users
│   ├── quickstart.md
│   ├── first-session.md
│   └── setup.md
│
├── developer/                 # For you (the developer)
│   ├── your-role.md
│   ├── your-powers.md
│   ├── quick-reference.md
│   └── workflow.md
│
├── reference/                 # System deep-dives
│   ├── architecture.md
│   ├── canvas-workflow.md
│   ├── canvas-commands.md
│   └── agent-coordination.md
│
├── agents/                    # Agent-specific docs
│   ├── index.md
│   ├── canvas-coordinator.md
│   └── integration.md
│
├── sessions/                  # Session management
│   ├── session-setup.md
│   ├── session-structure.md
│   └── status-tracking.md
│
└── troubleshooting/           # Help & debugging
    ├── common-issues.md
    └── debugging.md
```

---

## 🎯 By Use Case

### "I'm new to this system"
→ Read: [Quickstart](./getting-started/quickstart.md) → [Your Role](./developer/your-role.md)

### "I want to start a new project"
→ Read: [First Session](./getting-started/first-session.md) → [Session Setup](./sessions/session-setup.md)

### "I need to know what I can do"
→ Read: [Your Powers](./developer/your-powers.md) → [Quick Reference](./developer/quick-reference.md)

### "I'm confused about how something works"
→ Read: [System Architecture](./reference/architecture.md) → [Canvas Workflow](./reference/canvas-workflow.md)

### "Something isn't working"
→ Read: [Common Issues](./troubleshooting/common-issues.md)

### "I want to understand agents"
→ Read: [Agent Index](./agents/index.md) → [Agent Coordination](./reference/agent-coordination.md)

---

## 🗂️ File Organization Rules

- **Filenames:** Always `snake_case.md` (not camelCase or UPPERCASE)
- **Organization:** By audience/purpose, not implementation detail
- **Cross-references:** Use relative markdown links `[text](../path/file.md)`
- **No duplication:** Link to main source, don't repeat content

---

## ✅ What Each Section Contains

### getting-started/
For onboarding new developers and first-time setup.
- How to install/configure
- How to create first session
- Basic workflow walkthrough

### developer/
Complete guide to YOUR role and capabilities.
- What you control
- Your decision points
- Your daily workflow
- Command reference

### reference/
Technical deep-dives and system architecture.
- System design
- State machines
- Detailed protocols
- Complete command reference

### agents/
Information specific to agent integration.
- How agents receive tasks
- What each agent does
- Integration points

### sessions/
Session management and tracking.
- How to create sessions
- Session structure
- How progress is tracked

### troubleshooting/
Help when things go wrong.
- Common problems
- Solutions
- Debugging approaches

---

## 📌 Important Files Outside docs/

These stay in their original locations (NOT in docs/):

- `.github/copilot-instructions.md` — Project-level coding conventions
- `.github/agents/` — Individual agent specs (maintained by Orchestrator)
- `.agents-work/session-template/` — Template for new sessions
- `.vscode/tasks.json` — VSCode task definitions
- `Project.canvas` — The shared canvas file
- `canvas-coordinator.py` — CLI tool
- `init-session.ps1` — Session initialization script

---

## 🔗 How to Link Between Docs

From `docs/getting-started/quickstart.md` to `docs/developer/your-role.md`:
```markdown
See [Your Role](../developer/your-role.md) for complete details.
```

From `docs/reference/architecture.md` to `docs/developer/quick-reference.md`:
```markdown
Quick summary: [Quick Reference](../developer/quick-reference.md)
```

Always use relative paths starting with `./` or `../`.

---

## 🚀 Getting Started Right Now

1. Read this index (you're reading it!)
2. Go to [Quickstart](./getting-started/quickstart.md)
3. Then read [Your Role](./developer/your-role.md)
4. Bookmark [Your Quick Reference](./developer/quick-reference.md)
5. Start your first session with [First Session](./getting-started/first-session.md)

**Everything else will make sense after that! 🎉**
