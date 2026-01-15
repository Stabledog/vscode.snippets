# AGENTS.md
# Guidance for AI agents in .../Code/User

## Overview

This directory contains VS Code user settings managed across multiple environments (personal and work) with manual branch synchronization. The configuration is complex and requires careful handling to avoid conflicts and premature application of changes.

- The dir name `.../Code/User` refers to "whatever dir VS Code uses as the parent for `snippets/` in the current environment."
    - The `.../Code/User` dir is referred to as the "HOT dir" in this context, because the user's VS Code auto-loads changes immediately if they occur in the HOT directory.
- VS Code has a variety of ways of choosing the HOT dir depending on system context.

## Repository Structure

### Version-Controlled Files
The following files and directories are tracked in git:
- The settings canonical storage is https://github.com/Stabledog/vscode.settings
- Key files:
    - `AGENTS.md` - This file (AI agent guidance, in the HOT dir it's a actually a symlink to `snippets/AGENTS-User.md`)
    - `settings.json` - Main VS Code settings
    - `keybindings.json` - Custom keyboard shortcuts
    - `tasks.json` - Task definitions
    - `Makefile` - Build/maintenance automation
    - `README.md` - Documentation
    - `settings-bootstrapper.json` - Bootstrap configuration

### Ignored Content
Everything else in the HOT directory is `.gitignore`d, including:
- `snippets/`: This dir is maintained in a separate GitHub repo and synced into place during environment setup. (Unlike the main configuration files, snippets do not require multi-branch management or complex reconciliation. Standard git push/pull operations and basic conflict resolution are sufficient for snippet maintenance.)
    - The snippets canonical storage is https://github.com/Stabledog/vscode.snippets
- `globalStorage/`, `History/`, `workspaceStorage/`: VS Code state files, do not touch
- Extension-specific files
- Other VS Code generated content

## Critical Rules

### 1. JSON Sorting Requirement
**ALL source-controlled JSON files MUST be kept sorted** to minimize noise in diffs when comparing branches.

- Sort settings alphabetically by key at all levels
- Maintain consistent formatting (4-spaces per indent level)
- This is critical for clean branch comparisons and merges

- Use `jq` for json queries / maintenance.  If it is not installed, alert user.  Never try to do a jit-install of `jq`

### 2. HOT dir change protocol
**DO NOT edit settings.json directly in the HOT directory during reconciliation work.**

Why: Changes to `settings.json` in that dir are immediately picked up by the hosting VS Code environment, which can cause premature reactions and instability since we're using VS Code itself to edit the settings.

**Workflow:**
1. Perform settings change reconciliation in a **separate temp directory**
2. Create the temp directory and use `git clone [HOT dir]` to populate it
3. In the HOT dir, add a remote named 'tmp-[random number]' which refers to the temp dir in step 2. This allows us to pull changes from the temp dir back into the HOT dir after reconciliation but before pushing to github.

### 3. Branch Synchronization Strategy

**Multi-Environment Setup:**
- Maintain separate branches for personal and work environments
- Each environment may have parameters that are problematic for other environments
- Manual synchronization is required between branches
- Each branch should have a `dont-merge-settings` file which lists the keys that should not be imported from other branches.
    - Keys are regex patterns like `editor\.vim\.badKey.*`
    - `dont-merge-settings` has one pattern per line.

**Synchronization Process:**
1. Changes can be made in ANY environment
2. When synchronizing:
   - Identify environment-specific settings that should NOT be merged
   - Carefully reconcile differences
   - Ensure JSON sorting is maintained


## AI Agent Responsibilities

When assisting with this configuration:

### When Editing JSON Files
1. **Always maintain alphabetical sorting** of keys
2. **Preserve existing formatting style** (4-space indentation)
3. **Validate JSON syntax** before completing changes



## Workflow Examples

### Example: Adding a New Setting

```bash
# 1. Work in separate directory (not the HOT directory)
> cd ~/$CurTempDir/vscode-settings

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
