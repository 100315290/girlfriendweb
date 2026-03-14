# Agent Directory

Complete roster of all 11+ agents that work in the multi-agent system, their roles, and how they interact with you.

## The 11 Core Agents

### 1. Orchestrator
**Role:** System conductor  
**Responsibility:** Dispatch agents in correct order, manage workflow state, track progress  
**When active:** All phases  
**Key decisions:** Which agent to dispatch next, when to pause for your approval  
**Interaction with you:** Pauses at gates, waits for your response  

### 2. SpecAgent
**Role:** Specification writer  
**Responsibility:** Create detailed spec from your requirements  
**When active:** Phase INTAKE  
**Inputs:** Your rough requirements, project context  
**Outputs:** spec.md with requirements, acceptance criteria, constraints  
**Interaction with you:** You review spec, request changes or approve  

### 3. Researcher
**Role:** Investigation specialist  
**Responsibility:** Research unfamiliar technologies, best practices, solutions  
**When active:** Phase INTAKE (parallel to SpecAgent)  
**Inputs:** Questions, requirements  
**Outputs:** research.md with findings, recommendations, references  
**Interaction with you:** Provides research context before design phase  

### 4. Architect
**Role:** System designer  
**Responsibility:** Create high-level architecture, design patterns, technology choices  
**When active:** Phase DESIGN  
**Inputs:** spec.md, research findings, existing codebase analysis  
**Outputs:** architecture.md with system design, tech stack, data models, integration points  
**Interaction with you:** You review design, approve or request revisions  

### 5. Designer
**Role:** UI/UX specialist  
**Responsibility:** Create wireframes, design mockups, user flows  
**When active:** Phase DESIGN (parallel to Architect if frontend work)  
**Inputs:** spec.md, user stories, requirements  
**Outputs:** wireframes.md, design mockups, user journey diagrams  
**Interaction with you:** You review designs, approve style direction  

### 6. Planner
**Role:** Task breakdown specialist  
**Responsibility:** Break architecture into concrete, assignable tasks  
**When active:** Phase PLAN  
**Inputs:** architecture.md, design mockups (if applicable)  
**Outputs:** tasks.yaml with task list, dependencies, acceptance criteria, time estimates  
**Interaction with you:** Tasks appear in canvas as RED cards  

### 7. Coder
**Role:** Implementation specialist  
**Responsibility:** Write code, implement features, write tests  
**When active:** Phase IMPLEMENT (main loop)  
**Inputs:** tasks.yaml, architecture.md, design, acceptance criteria  
**Outputs:** Code, test cases, commits  
**Canvas interaction:** Picks RED tasks → ORANGE (working) → CYAN (done)  
**Interaction with you:** You can pause, request changes, work alongside  

### 8. Reviewer
**Role:** Code quality specialist  
**Responsibility:** Review code, check for style, standards, correctness  
**When active:** Phase REVIEW (after Coder)  
**Inputs:** Coder's code, acceptance criteria, coding standards  
**Outputs:** review.md with findings, approval or requests for changes  
**Canvas interaction:** Picks ORANGE (code waiting) → ORANGE (reviewing) → CYAN (done)  
**Interaction with you:** Major issues escalated to you  
**Strategies:** Light (spot-check), Thorough (full review), SkipMe (auto-approve)  

### 9. QA
**Role:** Testing specialist  
**Responsibility:** Test code against acceptance criteria, find bugs  
**When active:** Phase QA  
**Inputs:** Code, test cases, acceptance criteria  
**Outputs:** qa-findings.json with test results, bugs found, status  
**Canvas interaction:** Picks ORANGE → CYAN (waits for approval)  
**Interaction with you:** Blocking bugs sent back to Coder; non-blocking logged  

### 10. Security
**Role:** Security auditor  
**Responsibility:** Audit code for security risks, compliance issues  
**When active:** Phase SECURITY  
**Inputs:** Code, architecture, external dependencies  
**Outputs:** security-report.md with risks, recommendations  
**Canvas interaction:** Can block release if critical risks found  
**Interaction with you:** Critical issues need your approval to override  

### 11. Integrator
**Role:** CI/CD and merge specialist  
**Responsibility:** Merge code, run CI/CD pipeline, coordinate deployment  
**When active:** Phase INTEGRATE  
**Inputs:** Approved code, test results, deployment config  
**Outputs:** Merged code, CI/CD results, deployment log  
**Canvas interaction:** Picks completed tasks → finalizes → marks CYAN/GREEN  
**Interaction with you:** Deployment gate — you approve final release  

### 12. Docs
**Role:** Documentation specialist  
**Responsibility:** Write README, API docs, user guides, deployment docs  
**When active:** Phase RELEASE  
**Inputs:** Code, architecture, user stories  
**Outputs:** README.md, API.md, DEPLOYMENT.md, user guides  
**Interaction with you:** Final review before release  

---

## Agent Workflows by Phase

### Phase: INTAKE
```
SpecAgent: Create spec from your requirements
      ↓
Researcher: Research technologies & best practices
      ↓
YOU REVIEW & APPROVE
      ↓
Next phase: DESIGN
```

### Phase: DESIGN
```
Architect: Create system design
      ↓ (parallel)
Designer: Create UI mockups (if applicable)
      ↓
YOU APPROVE OR REQUEST CHANGES
      ↓
Next phase: PLAN
```

### Phase: PLAN
```
Planner: Break into tasks
      ↓
YOU CHOOSE WORKFLOW STRATEGY:
  - Standard (all tasks go through Code→Review→QA→Security)
  - Lean (skip Review, QA, Security for simple changes)
  - Parallel (multiple features track in parallel)
      ↓
Next phase: IMPLEMENT
```

### Phase: IMPLEMENT (Loop)
```
FOR EACH TASK:
  Coder: Code task
      ↓
  Reviewer: Review code (strategy-dependent)
      ↓
  QA: Test task
      ↓
  Security: Audit (standard only)
      ↓
  YOU APPROVE TASK (change to GREEN)
      ↓
NEXT TASK or INTEGRATE PHASE
```

### Phase: INTEGRATE
```
Integrator: Merge, CI/CD, coordinate
      ↓
YOU REVIEW & APPROVE FINAL RELEASE
      ↓
Next phase: RELEASE
```

### Phase: RELEASE
```
Docs: Write documentation
      ↓
YOU FINAL REVIEW
      ↓
Session complete (DONE)
```

---

## How Agents Read Your Guidance

Your feedback appears in:

1. **Task descriptions** (in canvas)
   - Agent reads card title/description
   - Sees your notes, acceptance criteria

2. **status.json**
   - Sees developer_decisions
   - Sees gate_tracking and your approvals
   - Reads your_guidelines section

3. **Agent results** (previous agent outputs)
   - Current agent reads what previous agents did
   - Sees your comments/feedback

**Example:**
```
Coder sees in Project.canvas:
  Card "T-001: Implement OAuth login"
  Description: "Use Passport.js, support Google + GitHub, 
               tests must cover both flows"
  
Coder reads status.json:
  developer_decisions: [
    { "timestamp": "...", "action": "use_redis_for_sessions" }
  ]
  
Coder implements based on guidance
```

---

## Special Roles

### Your Role (Developer)
- **What:** You are a super-agent with veto power
- **Special abilities:** Approve/reject work, work yourself, pause agents, give guidance
- **Canvas interaction:** Can set any task to any color
- **Decision gates:** Only YOU can approve final release

### Orchestrator Agent
- **What:** Meta-agent that runs other agents
- **Responsibilities:** Sequence agents, track state, pause for gates
- **Not in workflow:** Doesn't do direct work; coordinates
- **Key decisions:** When to dispatch next agent, when to pause

---

## Adding Custom Agents

The system is extensible. You can add custom agents for your workflows:

```
1. Create new agent following same pattern
2. Register in Orchestrator dispatch sequence
3. Provide clear inputs (spec, tasks, requirements)
4. Agent updates canvas via canvas-coordinator.py
5. Orchestrator dispatches next agent
```

---

See also:
- [Orchestrator Protocol](../reference/agent-coordination.md) — How agents interact
- [Canvas Workflow](../reference/canvas-workflow.md) — Task state machine
- [Your Role](../developer/your-role.md) — Your place in the system
