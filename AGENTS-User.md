# AGENTS.md
# Guidance for AI agents in .../AppData/Roaming/Code/User

## Overview

This directory contains VS Code user settings managed across multiple environments (personal and work) with manual branch synchronization. The configuration is complex and requires careful handling to avoid conflicts and premature application of changes.

## Repository Structure

### Version-Controlled Files
The following files and directories are tracked in git:
- `settings.json` - Main VS Code settings
- `keybindings.json` - Custom keyboard shortcuts
- `tasks.json` - Task definitions
- `Makefile` - Build/maintenance automation
- `README.md` - Documentation
- `settings-bootstrapper.json` - Bootstrap configuration
- `AGENTS.md` - This file (AI agent guidance)

### Ignored Content
Everything else in this directory is `.gitignore`d, including:
- `snippets/` - Maintained in a separate GitHub repo and synced into place during environment setup. Unlike the main configuration files, snippets do not require multi-branch management or complex reconciliation. Standard git push/pull operations and basic conflict resolution are sufficient for snippet maintenance.
- `globalStorage/`
- `History/`
- `workspaceStorage/`
- Extension-specific files
- Other VS Code generated content

## Critical Rules

### 1. JSON Sorting Requirement
**ALL JSON files MUST be kept sorted** to minimize noise in diffs when comparing branches.

- Sort settings alphabetically by key at all levels
- Maintain consistent formatting (4-space indentation)
- This is critical for clean branch comparisons and merges

### 2. Edit Location Protocol
**DO NOT edit settings.json directly in this directory during reconciliation work.**

Why: Changes to `settings.json` are immediately picked up by the hosting VS Code environment, which can cause premature reactions and instability since we're using VS Code itself to edit the settings.

**Workflow:**
1. Perform change reconciliation in a **separate directory** (not `~/AppData/Roaming/Code/User`)
2. Push changes to GitHub from the separate directory
3. Pull changes back into `~/AppData/Roaming/Code/User` when ready

### 3. Branch Synchronization Strategy

**Multi-Environment Setup:**
- Maintain separate branches for personal and work environments
- Each environment may have parameters that are problematic for other environments
- Manual synchronization is required between branches

**Synchronization Process:**
1. Changes can be made in ANY environment
2. When synchronizing:
   - Identify environment-specific settings that should NOT be merged
   - Carefully reconcile differences
   - Ensure JSON sorting is maintained
   - Test in target environment after merge

### 4. Environment-Specific Considerations

When reviewing or modifying settings, be aware that:
- Some settings may be work-specific (paths, proxies, enterprise tools)
- Some settings may be personal-environment-specific
- Always ask or note when a setting appears environment-dependent

## AI Agent Responsibilities

When assisting with this configuration:

### Before Making Changes
1. **Identify the current environment** (personal vs work)
2. **Determine if editing in the right location** (separate dir vs live dir)
3. **Check if changes are environment-agnostic** or need branch-specific handling

### When Editing JSON Files
1. **Always maintain alphabetical sorting** of keys
2. **Preserve existing formatting style** (4-space indentation)
3. **Validate JSON syntax** before completing changes
4. **Provide before/after context** to show sorting is maintained

### When Synchronizing Branches
1. **List differences** between branches first
2. **Identify environment-specific settings** that should remain separate
3. **Propose merge strategy** before executing
4. **Verify sorting** after merge operations

### Best Practices
- **Ask clarifying questions** about environment-specific settings
- **Explain the impact** of changes before applying them
- **Suggest testing steps** after significant changes
- **Document non-obvious decisions** in commit messages or comments

## Workflow Examples

### Example: Adding a New Setting

```bash
# 1. Work in separate directory (not the live VS Code User directory)
cd ~/vscode-config-staging

# 2. Edit settings.json - add new setting
# 3. Sort JSON file
# 4. Commit and push

git add settings.json
git commit -m "Add new setting: editor.fontSize"
git push origin main

# 5. Pull into live directory when ready
cd ~/AppData/Roaming/Code/User
git pull origin main
```

### Example: Reconciling Branch Differences

```bash
# 1. In separate directory
cd ~/vscode-config-staging

# 2. Compare branches
git diff work-branch..personal-branch settings.json

# 3. Identify environment-specific settings
# 4. Cherry-pick or merge selectively
# 5. Re-sort JSON files
# 6. Test, commit, push
```

## Tools and Automation

### JSON Sorting Script
Use `settings.json-sort.sh` to ensure consistent sorting:
```bash
./settings.json-sort.sh settings.json
```

### Makefile Targets
Check `Makefile` for available automation commands.

## Common Pitfalls to Avoid

1. ❌ **Don't edit settings.json in live directory during reconciliation**
2. ❌ **Don't forget to sort JSON after making changes**
3. ❌ **Don't merge environment-specific settings across branches**
4. ❌ **Don't push without testing in target environment**
5. ❌ **Don't assume all settings are universal**

## Questions to Ask

When uncertain, ask the user:
- "Is this setting environment-specific (work vs personal)?"
- "Should I work in a separate directory for this change?"
- "Do you want this change in all branches or specific ones?"
- "Should I sort the JSON file after this change?"

## Future Goals

The main objective is to **transition manual maintenance to AI-assisted processes**, but workflows are still being refined. Document new patterns and procedures as they emerge.

---

**Last Updated:** January 2026
**Maintained By:** AI agents and user collaboration
