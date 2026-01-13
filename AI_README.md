# AI_README.md
# Guidance for AI agents in .../AppData/Roaming/Code/User/snippets

## Overview

This directory contains VS Code snippet files for various languages and contexts. Unlike the parent `User/` directory, snippets use a simpler maintenance model with a single GitHub repository and standard git workflows.

## Repository Purpose

This `snippets/` directory serves dual purposes:
1. **Snippet Storage** - VS Code code snippet definitions in JSON format
2. **Maintenance Tools** - Helper scripts and documentation for managing the parent `User/` directory

## Why Snippets Hosts User/ Maintenance Tools

The parent `User/` directory requires complex multi-branch synchronization, which makes it unsuitable for hosting maintenance tools (you can't reliably use tools that themselves need to be synchronized across branches). By hosting maintenance tools here in `snippets/`, we avoid this circular dependency.

## Directory Structure

### Snippet Files
- `*.code-snippets` - Multi-language snippet files
- `*.json` - Language-specific snippet files (e.g., `markdown.json`, `dockerfile.json`)

### AI Documentation
- `AI_README.md` - This file (guidance for snippets directory)
- `AGENTS-User.md` - AI guidance for parent User/ directory (symlinked to `../AGENTS.md`)

### Maintenance Tools
- `maintenance-helper.sh` - Shell functions for common User/ directory maintenance tasks

## Git Workflow

This directory uses standard git operations:
- `git add`, `git commit`, `git push` for changes
- `git pull` to sync updates
- Standard conflict resolution when needed
- No multi-branch reconciliation required

## Snippet File Format

Snippet files are JSON with the following structure:
```json
{
    "Snippet Name": {
        "prefix": "trigger",
        "body": [
            "line 1",
            "line 2"
        ],
        "description": "What this snippet does"
    }
}
```

## AI Agent Responsibilities

### When Working with Snippets
1. **Maintain JSON formatting** - 4-space indentation, valid syntax
2. **Use descriptive names** - Snippet names should clearly indicate purpose
3. **Choose clear prefixes** - Tab triggers should be memorable and non-conflicting
4. **Test snippets** - Verify they work in target language contexts
5. **Keep sorted** - While not as critical as User/ settings, alphabetical order helps

### When Using Maintenance Tools
1. **Check `maintenance-helper.sh`** for available functions before implementing custom solutions
2. **Document new tools** - Add comments explaining purpose and usage
3. **Keep tools general** - Don't hard-code environment-specific paths

## Common Operations

### Adding a New Snippet
1. Identify the appropriate file (language-specific or multi-language)
2. Add snippet with proper JSON structure
3. Test the snippet in VS Code
4. Commit and push: `git add <file> && git commit -m "Add snippet: <name>" && git push`

### Modifying Maintenance Tools
1. Edit `maintenance-helper.sh`
2. Test the function
3. Document any new parameters or behavior
4. Commit and push changes

## Environment Setup

When setting up a new environment:
1. Clone this repository to `~/AppData/Roaming/Code/User/snippets/`
2. Create symlink: `cd .. && mklink AGENTS.md snippets\AGENTS-User.md` (Windows) or `ln -s snippets/AGENTS-User.md AGENTS.md` (Unix)
3. Verify snippets are recognized by VS Code
4. Source maintenance tools if needed: `source snippets/maintenance-helper.sh`

## Notes

- Snippets are immediately available in VS Code after saving
- Changes to snippet files require no VS Code restart
- This directory does not use `.gitignore` as extensively as User/
- Maintenance tools are bash-based but should be Windows-compatible where possible

---

**Last Updated:** January 2026
**Maintained By:** User and AI collaboration
