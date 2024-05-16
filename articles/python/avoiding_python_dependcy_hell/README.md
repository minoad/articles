# Avoiding Python Dependency Hell

## Introduction

Recently a friend of mine was complaining about an error in their anaconda environment.  I immediatly reccomended switching to a devcontainer or a venv environment.

I realized that many people are not aware of the benefits of using a devcontainer or a venv environment or how to select for versions of python, etc.

## Intent

My intent here is to create an article that will cover environment mangement for modern versions of python.

The final solution will be a python 3.12 project running in either a devcontainer(prefered) and/or a venv environment.
IDE is assumed to be vscode, however the same principles apply to other IDEs.

## Resources

### Textmate Snippets

Below are the snippets used to setup the project.

I would reccomend using a template git repo, but having these aviailable will allow for quick deployment and development.

Snippets are file type dependent.  For instance, python code snippets will work in files with type extension `.py`.  Open a file and look in th3e lower right corner to see the file type interpretted by vscode.

For each snippet, to set them up in vscode:

1. Open the `Command Pallete` and select `Preferences: Configure User Snippets`.
1. Type the name of the file type, (Makefile/toml/devcontainer/dockercompose/etc).  
    * If the type already exists, select it.  
    * If not, select `New Global Snippets file...`.
1. The file will have an existing dictionary {}.  Add the snippet to the dictionary.  If you paste the snippet at the bottom of the file, make sure to add a comma to the end of the previous snippet.

#### pyproject.toml

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
			"[project.scripts]",
			"$1-cli = \"$1-cli:main_cli\"",
			"#Equivilent to `from spam import main_cli; main_cli()`",
			"#Touch $1/__init__.py",
			"# echo 'def main_cli(): pass' >> $1/__init__.py",
			"",
			"[project.gui-scripts]",
			"$1-gui = \"$1-gui:main_cli\"",
			"# echo 'def main_gui(): pass' >> $1/__init__.py",
			"",
			"# Deploy using pip install -e .[all]",
		],
	}
```

#### Makefile

```json
{
	"Python Default Makefile Full": {
		"prefix": "python_default_makefile_full",
		"body": [
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

#### Devcontainer

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

```json
"python-defulat-dockerfile": {
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
