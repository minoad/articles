# Avoiding Python Dependency Hell

## Introduction

Recently a friend of mine was complaining about an error in their anaconda environment.  I immediately recommended switching to a devcontainer or a venv environment.

I realized that many people are not aware of the benefits of using a devcontainer or a venv environment or how to select for versions of python, etc.

## Intent

My intent here is to create an article that will cover environment management for modern versions of python.

The final solution will be a python 3.12 project running in either a devcontainer(preferred) and/or a venv environment.
IDE is assumed to be vscode, however the same principles apply to other IDEs.

## Setup

### Windows

1. Install [Windows Terminal](https://aka.ms/terminal).
1. Install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install)
    1. WSL can get greedy for memory.  I use the following to limit it to 5GB.  Check your task manager to see your availbe memory.  Here is my example.
    Create the file `$HOME/.wslconfig` and add the following:

    ```conf
    [wsl2]
    memory=5GB
    ```

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
1. Install [Visual Studio Code](https://code.visualstudio.com/)
1. Setup openssh for windows.  This is required for the remote development extension pack.  [Instructions](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
1. Setup windows (this is if using git-bash.  I would still recommend getting openssh going as well) [ssh key for github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
1. Add ssh to github.  [Instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
    1. Install [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
    1. Install [Python Extension Pack](https://marketplace.visualstudio.com/items?itemName=donjayamanne.python-extension-pack)
    1. Install [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
    1. Install [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)

## Resources

### Textmate Snippets

Below are the snippets used to setup the project.

I would recommend using a template git repo, but having these aviailable will allow for quick deployment and development.

Snippets are file type dependent.  For instance, python code snippets will work in files with type extension `.py`.  Open a file and look in th3e lower right corner to see the file type interpreted by vscode.

For each snippet, to set them up in vscode:

1. Open the `Command Palette` and select `Preferences: Configure User Snippets`.
1. Type the name of the file type, (Makefile/toml/devcontainer/dockercompose/etc).  
    * If the type already exists, select it.  
    * If not, select `New Global Snippets file...`.
1. The file will have an existing dictionary {}.  Add the snippet to the dictionary.  If you paste the snippet at the bottom of the file, make sure to add a comma to the end of the previous snippet.

#### Makefile

On Windows, ensure make is installed.  This can be done by installing [Chocolatey](https://chocolatey.org/install) and running `choco install make` from an elevated terminal.
Start with the make file.  Once this pasted in execute `make setup_project`.

```json
{
	"Python Default Makefile Full": {
		"prefix": "python_default_makefile_full",
		"body": [
        ".PHONY: setup_project",
        "setup_project:",
        "\tmkdir .devcontainer",
        "",
		".PHONY: build",
		"build:",
		"\tpip install -e .",
		"",
		".PHONY: docker_clean",
		"docker_clean:",
		"\tdocker image prune --all -f",
		"\tdocker container prune -f",
		"\tdocker volume prune -f --all",
		"\tcd .devcontainer && docker-compose down --rmi all --volumes --remove-orphans",
		"",
		".PHONY: mypy",
		"mypy:",
		"\tmypy --ignore-missing-imports documentanalysis/",
		"",
		".PHONY: test",
		"test:",
		"\tpytest test/",
		"",
		".PHONY: coverage",
		"coverage:  ## Run tests with coverage",
		"\tcoverage erase",
		"\tcoverage run -m pytest",
		"\tcoverage report -m",
		"",
		".PHONY: lint",
		"lint: pylint flake8 black mypy",
		"",
		".PHONY: pylint",
		"pylint:",
		"\tpylint --max-line-length=120 documentanalysis/",
		"",
		".PHONY: flake8",
		"flake8:",
		"\tflake8 --max-line-length=120 --ignore=E266,E402,F841,F401,E302,E305 .",
		"",
		".PHONY: checklist",
		"checklist: lint typehint test"
		],
		"description": "Create a full Makefile"
  }
}
```

#### pyproject.toml

Next we need to create the pyproject file.

This snippet includes a project name variable.  Use the tab key to move between variables.

```json
"pyproject.toml": {
		"prefix": "pyproject",
		"body": [
			"[build-system]",
			"requires = [\"setuptools >= 61.0\"]",
			"build-backend = \"setuptools.build_meta\"",
			"[project]",
			"name = \"$1\"",
			"version = \"0.1.0\"",
			"description = \"$2.\"",
			"requires-python = \">=3.12\"",
			"license = { file = \"LICENSE.txt\" }",
			"keywords = [\"template\",]",
			"authors = [{ name = \"Micah Norman\", email = \"minoad@gmail.com\" }]",
			"maintainers = [{ name = \"Micah Norman\", email = \"minoad@gmail.com\" }]",
			"dependencies = [",
			"\t'httpx'",
			"]",
			"",
			"[project.optional-dependencies]",
			"dev = [",
			"\t\"debugpy\",",
			"\t\"pylint\",",
			"\t\"toml\",",
			"\t\"yapf\",",
			"\t\"colorama\",",
			"\t\"isort\",",
			"\t\"black\",",
			"\t\"mypy\",",
			"\t\"mypy-extensions\",",
			"]",
			"test = [\"pytest < 5.0.0\", \"pytest-cov[all]\"]",
			"cli = [\"click\", \"rich\"]",
			"all = [\"$1[test, dev, cli]\"]",
			"",
			"[project.urls]",
			"homepage = \"https://example.com\"",
			"documentation = \"https://readthedocs.org\"",
			"repository = \"https://github.com/minoad/$1\"",
			"changelog = \"https://github.com/minoad/$1/CHANGELOG.md\"",
			"",
			"[tool.mypy]",
			"warn_unreachable = true",
			"show_error_codes = true",
			"show_column_numbers = true",
			"[tool.pytest.ini_options]",
			"addopts = \"--strict-config --strict-markers\"",
			"",
			"[tool.isort]",
			"profile = \"black\"",
			"",
			"[tool.black]",
			"line-length = 120",
			"target-version = ['py312']",
			"include = '\\.pyi?$'",
			"preview = true",
			"",
			"[tool.pylint.format]",
			"max-line-length = \"120\"",
			"",
			"[tool.pylint.'MESSAGES CONTROL']",
			"max-line-length = 120",
			"",
			"#[project.scripts]",
			"#$1-cli = \"$1-cli:main_cli\"",
			"#Equivalent to `from spam import main_cli; main_cli()`",
			"#Touch $1/__init__.py",
			"# echo 'def main_cli(): pass' >> $1/__init__.py",
			"",
			"#[project.gui-scripts]",
			"#$1-gui = \"$1-gui:main_cli\"",
			"# echo 'def main_gui(): pass' >> $1/__init__.py",
			"",
			"# Deploy using pip install -e .[all]",
		],
	}
```

#### Devcontainer

Create file devcontainer/devcontainer.json

##### .devcontainer/devcontainer.json

```json
"python-default-Devcontainer": {
		"prefix": "python-default-devcontainer",
		"body": [
		"{",
			"\t\"dockerComposeFile\": \"docker-compose.yml\",",
			"    \"service\": \"devcontainer\",",
			"    \"workspaceFolder\": \"/workspaces/${localWorkspaceFolderBasename}\",",
			"\t\"customizations\": {",
			"\t\t\"vscode\": {",
			"\t\t\t\"extensions\": [",
			"\t\t\t\t\"dbaeumer.vscode-eslint\",",
			"\t\t\t\t\"ms-azuretools.vscode-docker\",",
			"\t\t\t\t\"tamasfe.even-better-toml\",",
			"\t\t\t\t\"ms-python.python\",",
			"\t\t\t\t\"ms-python.isort\",",
			"\t\t\t\t\"mikoz.black-py\",",
			"\t\t\t\t\"ms-python.autopep8\",",
			"\t\t\t\t\"gruntfuggly.todo-tree\",",
			"\t\t\t\t\"ms-python.pylint\",",
			"\t\t\t\t\"ms-python.flake8\",",
			"\t\t\t\t\"donjayamanne.python-extension-pack\",",
			"\t\t\t\t\"ms-python.mypy-type-checker\",",
			"\t\t\t\t\"ms-vscode.makefile-tools\",",
			"\t\t\t\t\"analytic-signal.preview-tiff\",",
			"\t\t\t\t\"jebbs.plantuml\",",
			"\t\t\t\t\"ms-vscode.makefile-tools\",",
			"\t\t\t\t\"davidanson.vscode-markdownlint\"",
			"\t\t\t]",
			"\t\t}",
			"\t},",
			"\t\"postCreateCommand\": \"make build\"",
		"}"
		],
		"description": "Create a devcontainer.json file"
	}
```

##### .devcontainer/docker-compose.yml

I am leaving a commented out section for a database.  This is a common use case, but not always needed.

Create file .devcontainer/docker-compose.yml

```json
"Python Default Docker Compose": {
		"prefix": "python_default_docker_compose",
		"body": [
		"version: '3.8'",
		"services:",
		"  devcontainer:",
		"    build:",
		"      context: .",
		"      dockerfile: Dockerfile",
		"    volumes:",
		"      - ../..:/workspaces:cached",
		"    network_mode: service:db",
		"    command: sleep infinity",
		"",
		"#   db:",
		"#     image: postgres:latest",
		"#     restart: unless-stopped",
		"#     volumes:",
		"#       - postgres-data:/var/lib/postgresql/data",
		"#     environment:",
		"#       POSTGRES_PASSWORD: postgres",
		"#       POSTGRES_USER: postgres",
		"#       POSTGRES_DB: postgres",
		"",
		"#   mongo:",
		"#     image: mongo",
		"#     restart: always",
		"#     environment:",
		"#       MONGO_INITDB_ROOT_USERNAME: root",
		"#       MONGO_INITDB_ROOT_PASSWORD: example",
		"",
		"#   mongo-express:",
		"#     image: mongo-express",
		"#     restart: always",
		"#     ports:",
		"#       - 8081:8081",
		"#     environment:",
		"#       ME_CONFIG_MONGODB_ADMINUSERNAME: root",
		"#       ME_CONFIG_MONGODB_ADMINPASSWORD: example"
		],
		"description": "Create a Docker Compose file"
	}
```

##### .devcontainer/Dockerfile

Create file .devcontainer/Dockerfile.

```json
"python-default-dockerfile": {
		"prefix": "python-default-dockerfile",
		"body": [
			"# set base image (host OS)",
			"FROM python:3.12",
			"",
			"# set the working directory in the container",
			"WORKDIR /workspaces/plat-analysis",
			"",
			"# RUN wget http://www.mirbsd.org/~tg/Debs/sources.txt/wtf-bookworm.sources",
			"# RUN mv wtf-bookworm.sources /etc/apt/sources.list.d/",
			"RUN apt update",
			"RUN apt install -y tesseract-ocr libtesseract-dev libpoppler-cpp-dev poppler-utils ffmpeg libsm6 libxext6"
			],
		"description": "Create a Dockerfile"
	}
```

## Preparing for devcontainer

Once this is done, open the command palette and type `Remote-Containers: Reopen in Container`.

Initially this will throw an error TODO: Fix this.
This is because the python project is not yet setup.

To quickly setup a usable project that will install, do the following.

1. Create a directory with the project name.
1. Create a file `__init__.py` in the directory.
1. Add the following to that init file.

```python
def main_cli() -> int:
    return 0


def main_gui() -> int:
    return 0
```

1. Create a file called `main.py` at the top level directory.
1. Add the following to that file.

```python
#!/usr/bin/env python
import sys

def main() -> int:
    print("test")
    return 0


if __name__ == "__main__":
    sys.exit(main())
```

## Starting the devcontainer

Once ready, open up a terminal in vscode and type `make build`.  This installs your module as a module in python in the container.  The power here is that you do not need to be concerned with pathing as the -e flag installs the module in editable mode.  This mode uses a symlink to the source code.

You can view your running containers by typing `docker ps`.
