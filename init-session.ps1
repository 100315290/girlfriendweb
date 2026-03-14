#!/usr/bin/env powershell
<#
.SYNOPSIS
    Initialize a new multi-agent project session

.DESCRIPTION
    Creates session folder structure, initializes status.json, and displays quick-start info

.PARAMETER SessionName
    Name of the session (short slug, e.g., "myproject", "auth-refactor")
    
.EXAMPLE
    .\init-session.ps1 -SessionName "myproject"
    Creates: .agents-work/2026-03-14_myproject/

.NOTES
    Run from girlfriendweb/ directory
#>

param(
    [Parameter(Mandatory=$true, HelpMessage="Session slug (e.g., myproject)")]
    [string]$SessionName
)

# Generate session ID: YYYY-MM-DD_slug
$date = Get-Date -Format "yyyy-MM-dd"
$sessionId = "${date}_${SessionName}"
$sessionPath = ".agents-work/$sessionId"

Write-Host "🚀 Initializing session: $sessionId" -ForegroundColor Cyan

# Create directories
Write-Host "  ├ Creating folders..." -ForegroundColor Gray
$null = mkdir -Force "$sessionPath/agent-results"
$null = mkdir -Force "$sessionPath/research"
$null = mkdir -Force "$sessionPath/design-specs"

# Copy and customize status.json
Write-Host "  ├ Initializing status.json..." -ForegroundColor Gray
$template = Get-Content ".agents-work/session-template/status.json" -Raw | ConvertFrom-Json
$template.session_id = $sessionId
$template.created_at = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
$template | ConvertTo-Json -Depth 10 | Set-Content "$sessionPath/status.json"

# Create empty spec files
Write-Host "  ├ Creating file templates..." -ForegroundColor Gray

# spec.md template
@"
# Project Specification

**Session:** $sessionId

## Goal
[What are we building?]

## Acceptance Criteria
- [ ] AC 1
- [ ] AC 2
- [ ] AC 3

## Non-Goals
- [What are we NOT building?]

## Assumptions
- [What are we assuming?]

## Constraints
- [Technical or business constraints?]
"@ | Set-Content "$sessionPath/spec.md"

# tasks.yaml template
@"
tasks:
  - id: T-001
    group: Planning
    title: Example Task
    description: Replace with real task
    depends_on: []
    status: not-started
    
# Status values: not-started, in-progress, implemented, completed, blocked
"@ | Set-Content "$sessionPath/tasks.yaml"

# acceptance.json template
@"
{
  "project": "$sessionId",
  "acceptance_criteria": [
    {
      "id": "AC-001",
      "description": "First acceptance criterion",
      "check_type": "manual | automated | both"
    }
  ],
  "test_plan": "Describe testing approach",
  "success_metrics": []
}
"@ | Set-Content "$sessionPath/acceptance.json"

Write-Host ""
Write-Host "✅ Session created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Session path: $sessionPath" -ForegroundColor Yellow
Write-Host "📄 Files created:" -ForegroundColor Yellow
Write-Host "  • status.json (auto-tracked)" -ForegroundColor Gray
Write-Host "  • spec.md (fill in requirements)" -ForegroundColor Gray
Write-Host "  • tasks.yaml (fill in task list)" -ForegroundColor Gray
Write-Host "  • acceptance.json (define criteria)" -ForegroundColor Gray
Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit spec.md with your requirements" -ForegroundColor Gray
Write-Host "  2. Ask SpecAgent to refine the spec" -ForegroundColor Gray
Write-Host "  3. Ask Architect to design the system" -ForegroundColor Gray
Write-Host "  4. Ask Planner to create tasks.yaml" -ForegroundColor Gray
Write-Host "  5. Open Project.canvas in Obsidian" -ForegroundColor Gray
Write-Host "  6. Watch tasks turn ORANGE as work progresses" -ForegroundColor Gray
Write-Host ""
Write-Host "📖 Documentation:" -ForegroundColor Cyan
Write-Host "  • MULTIAGENT-QUICKSTART.md" -ForegroundColor Gray
Write-Host "  • CANVAS-CHEATSHEET.md" -ForegroundColor Gray
Write-Host "  • MULTIAGENT-ARCHITECTURE.md" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 You're ready to start!" -ForegroundColor Green
