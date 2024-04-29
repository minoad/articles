.PHONY: install_core_dependencies
install_core_dependencies:
	. venv/bin/activate && python -m pip install --upgrade pip && python -m pip install .

.PHONY: install_dev_dependencies
install_dev_dependencies:
	. venv/bin/activate && python -m pip install .[dev]

.PHONY: install
install: install_core_dependencies install_dev_dependencies

.PHONY: mypy
mypy:
	mypy --ignore-missing-imports documentanalysis/

.PHONY: test
test:
	pytest test/

.PHONY: coverage
coverage:  ## Run tests with coverage
	coverage erase
	coverage run -m pytest
	coverage report -m

.PHONY: lint
lint: pylint flake8 black mypy

.PHONY: pylint
pylint:
	pylint --max-line-length=120 documentanalysis/

.PHONY: flake8
flake8:
	flake8 --max-line-length=120 --ignore=E266,E402,F841,F401,E302,E305 .

.PHONY: checklist
checklist: lint typehint test

.PHONY: black
black:
	black --preview -l 120 .

.PHONY: clean
clean:
	find . -type f -name "*.pyc" | xargs rm -fr
	find . -type d -name __pycache__ | xargs rm -fr