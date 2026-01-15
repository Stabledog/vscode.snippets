# Snippets in VSCode

## AI agents:  see ./AI_README.md for context

- The `.../User/Code/snippets` folder gets shared and merged between machine branches just like any VSCode user settings

- The `.../User/Code` folder has per-environment branches which must be sync'ed carefully

- The `test*/` folders has various test files

## Branches in the ../User repo
    - Upstream is maintained https://github.com/Stabledog/vscode.settings
    - Each branch supports a particular vscode environment


## DevX Spaces (branch: _reference_)
1. Spaces is a BB internal system like github Codespaces
1. This environment owns the _reference_ branch
1. Spaces does use a conventional file-system .../Code/User dir at all.
    - During Space build, the builder loads content from ~/.vscode/settings.json

## BB + WSL
1. This environment owns _bb.wsl_ branch
1. Because Windows and WSL share a working copy, be extra careful
   about compatibility of settings

## Personal + WSL
1. This environment owns _personal.wsl_ branch
1. Because Windows and WSL share a working copy, be extra careful
   about compatibility of settings




