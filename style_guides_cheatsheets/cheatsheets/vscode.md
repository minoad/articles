# Vscode cheats and quick reference

## ctrl-x|c not working with vim/nvim?

Add the following to your settings.json file (shift-ctrl-p: json):

```json
"vim.handleKeys": {
        "<C-c>": false,
        "<C-x>": false,
        "<D-c>": false,
    },
```

## Default makefile configurations

```json
"makefile.configurations": [
        {"name": "Default",
         "makeArgs": []},
         {"name": "Print make version",
         "makeArgs": ["--version"]
        }
    ],
```

## Windows copy relative path giving wrong slashes?

```json
"explorer.copyRelativePathSeparator": "/",
```

## Ripgrep (rg.exe) going nuts?

```json
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true,
        "**/*.code-search": true,
        "**/venv": true,
        "venv/**": true,
        ".mypy_cache/**": true,
        ".pytest_cache/**": true,
        "**/.git": true,
        "**/.svn": true,
        "**/.hg": true,
        "**/CVS": true,
    },
```

## Python default interpreter

This should never be used, but leaving it here for reference.

```json
    "python.defaultInterpreterPath": ".venv/bin/python",
```

## Python dotenv support

```json
    "python.envFile": "${workspaceFolder}/.env",
```

## Activate your environment by default in terminal

```json
    "python.terminal.activateEnvInCurrentTerminal": true,
```

## Need a path added to python analysis real quickly?

You should rarely if ever need this.  Prefer using editable pip install in a virtual environment or a devcontainer.

```json
"python.venvFolders": [
        "venv/",
        ".venv/"
],
"python.analysis.extraPaths": [
    "./modules/"
],
"python.autoComplete.extraPaths": [
    "venv/lib/python3.11/site-packages"
],
```

## Terminal setup

```json
    "terminal.integrated.profiles.windows": {
        "wsl-Ubuntu": {
            "path": "wsl.exe",
            "args": ["-d", "Ubuntu"]
        },
        "powershell": {
            "path": "pwsh.exe",
            "args": [
                "-noexit",
                "-file",
            ]
        }
    },
    "terminal.integrated.defaultProfile.windows": "PowerShell",
    "terminal.integrated.profiles.osx": {
        "bash": {
            "path": "/bin/zsh",
            "args": [
                "-l"
            ],
            "icon": "terminal-bash"
        },
        "zsh": {
            "path": "zsh",
            "args": [
                "-l"
            ]
        },
        "fish": {
            "path": "fish",
            "args": [
                "-l"
            ]
        },
        "tmux": {
            "path": "tmux",
            "icon": "terminal-tmux"
        },
        "pwsh": {
            "path": "pwsh",
            "icon": "terminal-powershell"
        }
    },
    "terminal.integrated.defaultProfile.osx": "zsh",
```
