# Documentation Cleanup Map

Reference for consolidating legacy documentation files into the new `docs/` structure.

## Legacy Files → New Locations

### 1. `MULTIAGENT-ARCHITECTURE.md` (root)
**Status:** Contains system design content  
**Consolidate to:** `docs/reference/architecture.md`  
**Action:** Most content already recreated in architecture.md; check for gaps

### 2. `MULTIAGENT-QUICKSTART.md` (root)
**Status:** Setup and first-run guide  
**Consolidate to:** `docs/getting-started/quickstart.md`  
**Action:** Most content recreated; check for unique tips

### 3. `CANVAS-CHEATSHEET.md` (root)
**Status:** Canvas commands and color reference  
**Consolidate to:** `docs/developer/quick-reference.md` + `docs/reference/canvas-workflow.md`  
**Action:** Commands merged into quick-reference; colors in canvas-workflow

### 4. `DEVELOPER-QUICK-REFERENCE.md` (root)
**Status:** Developer commands and workflow  
**Consolidate to:** `docs/developer/quick-reference.md`  
**Action:** Already consolidated; delete original

### 5. `YES-YOUR-ROLE-IS-INCLUDED.md` (root)
**Status:** Confirmation that developer role is included  
**Consolidate to:** `docs/developer/your-role.md` (context section)  
**Action:** Already consolidated; delete original

### 6. `IMPLEMENTATION-COMPLETE.md` (root)
**Status:** Project completion summary  
**Action:** Convert to reference/archive document or delete  
**Consider:** Keep as historical record in `.archived/` or delete

### 7. `.github/DEVELOPER-ROLE.md`
**Status:** Developer authority documentation  
**Consolidate to:** `docs/developer/your-role.md`  
**Action:** Already consolidated; can delete or archive

### 8. `.agents-work/SESSION-SETUP.md`
**Status:** Session creation and management  
**Consolidate to:** `docs/sessions/session-setup.md`  
**Action:** Already recreated; delete or archive original

## Cleanup Action Plan

### Phase 1: Verification (Before Deleting)
- [ ] Review each legacy file for unique content not in docs/
- [ ] Cross-check examples in legacy files against new docs
- [ ] Ensure all links in docs/ are correct and relative

### Phase 2: Archive (Optional - Keep History)
Create `.archived/` folder for historical reference:
```bash
mkdir -p .archived/legacy-docs
mv MULTIAGENT-ARCHITECTURE.md .archived/legacy-docs/
mv MULTIAGENT-QUICKSTART.md .archived/legacy-docs/
# etc...
```

**Or just delete if not needed.**

### Phase 3: Update Root README (Optional)
Current `README.md` should point to:
- `SYSTEM-OVERVIEW.md` (new entry point)
- `docs/README.md` (full documentation)

### Phase 4: Final Check
- [ ] All internal links still work (test relative paths)
- [ ] No broken references
- [ ] docs/README.md navigation complete
- [ ] VSCode tasks still reference correct files

## Files to Keep (Don't Delete)

These stay in their current locations:
- ✅ `README.md` — Project README (root)
- ✅ `SYSTEM-OVERVIEW.md` — New entry point (root)
- ✅ `canvas-coordinator.py` — Core tool (root)
- ✅ `init-session.ps1` — Setup script (root)
- ✅ `Project.canvas` — Shared canvas (root)
- ✅ `.vscode/tasks.json` — VSCode integration
- ✅ `.github/copilot-instructions.md` — Project conventions
- ✅ `.agents-work/session-template/` — Session template
- ✅ `.Kanvas-main/` — External dependency
- ✅ `.multiagent-stuff/` — External dependency
- ✅ `docs/` — New documentation structure (all files)

## Documentation Consolidation Status

| File | Source | Target | Status |
|------|--------|--------|--------|
| Architecture | MULTIAGENT-ARCHITECTURE.md | docs/reference/architecture.md | ✅ Done |
| Quickstart | MULTIAGENT-QUICKSTART.md | docs/getting-started/quickstart.md | ✅ Done |
| Canvas workflow | CANVAS-CHEATSHEET.md | docs/reference/canvas-workflow.md | ✅ Done |
| Developer reference | DEVELOPER-QUICK-REFERENCE.md | docs/developer/quick-reference.md | ✅ Done |
| Developer role | YES-YOUR-ROLE-IS-INCLUDED.md + DEVELOPER-ROLE.md | docs/developer/your-role.md | ✅ Done |
| Session setup | SESSION-SETUP.md | docs/sessions/session-setup.md | ✅ Done |
| Agent directory | (new) | docs/agents/index.md | ✅ Done |
| Agent coordination | (new) | docs/reference/agent-coordination.md | ✅ Done |
| Troubleshooting | (new) | docs/troubleshooting/common-issues.md | ✅ Done |

## Next Steps

1. **Verify new docs** are complete and accurate
2. **Test all links** in docs/ work correctly (relative paths)
3. **Decide:** Archive legacy files or delete?
   - Archive if: You want historical record or project history matters
   - Delete if: Cleaner slate, only current docs matter
4. **Update links** in any remaining files to point to docs/
5. **Communicate:** Let team know new docs location is docs/

## Example Legacy File Content Still Needed

If you find content in legacy files that's NOT in docs/:
1. Note it here
2. Add to appropriate docs/ file
3. Then delete legacy file

### Checked Files:
- [ ] MULTIAGENT-ARCHITECTURE.md — Need to review
- [ ] MULTIAGENT-QUICKSTART.md — Need to review
- [ ] CANVAS-CHEATSHEET.md — Need to review
- [ ] IMPLEMENTATION-COMPLETE.md — Need to review
- [ ] Other files...

---

**Recommendation:** Delete legacy files now that docs/ is complete. The system is consolidated enough that duplicates cause confusion.
