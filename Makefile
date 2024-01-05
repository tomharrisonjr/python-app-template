.DEFAULT_GOAL := help
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Formatting

.PHONY: format-black
format-black:	## black: code formatter
	@black .

.PHONY: format-isort
format-isort:  ## isort: import formatter
	@isort .

.PHONY: format
format: format-black format-isort ## Runs all formatting commands

##@ Linting

.PHONY: lint-black
lint-black:  ## black: code formatter in linting mode
	@black . --check

.PHONY: lint-isort
link-isort:	## isort: import formatter in linting mode
	@isort . --check

.PHONY: lint-flake8
lint-flake8:  ## flake8: linter
	@flake8 .

.PHONY: lint-mypy
lint-mypy:  ## mypy: static type checker
	@mypy .

.PHONY: lint-mypy-report
lint-mypy-report: ## mypy: static type checker with html report
	@mypy ./src --html-report ./mypy-html

.PHONY: lint
lint: lint-black lint-isort lint-flake8 lint-mypy ## Runs all linting commands

##@ Testing

.PHONY: unit-tests
unit-tests:  ## Runs unit tests
	@pytest --doctest-modules

.PHONY: unit-tests-cov
unit-tests-cov:  ## Runs unit tests with verbose output
	@pytest --doctest-modules --cache-clear --cov=src --cov-report term-missing --cov-report html --junitxml=pytest.xml | tee pytest-coverage.txt

.PHONY: unit-tests-cov-fail
unit-tests-cov-fail:  ## Runs unit tests with verbose output and fail on coverage
	@pytest --cov-fail-under=80 --doctest-modules --cache-clear --cov=src --cov-report term-missing --cov-report html --junitxml=pytest.xml | tee pytest-coverage.txt

.PHONY: clean-cov
clean-cov:  ## Cleans up coverage files
	@rm -rf .coverage
	@rm -rf htmlcov
	@rm -rf pytest.xml
	@rm -rf pytest-coverage.txt

##@ Documentation

.PHONY: docs-build
docs-build: ## build documentation locally
	@mkdocs build

.PHONY: docs-deploy
docs-deploy: ## build & deploy documentation to "gh-pages" branch
	@mkdocs gh-deploy -m "docs: update documentation" -v --force

.PHONY: clean-docs
clean-docs: ## remove output files from mkdocs
	@rm -rf site

clean: clean-cov clean-docs ## Cleans up all generated files

##@ Releases

.PHONY: release
release:
	@semantic-release version --changelog --tag --push --vcs-release --push

##@ Docker

build: ## docker build
	@docker build --file Dockerfile --tag project:latest --target production .

run: ## docker run app
	@docker run -p 9000:80 -it --rm project:latest

run-bash: ## docker run with bash
	@docker run -it --rm project:latest /bin/bash

