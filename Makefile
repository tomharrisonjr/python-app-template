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
	@mypy ./src

.PHONY: lint-mypy-report
lint-mypy-report: ## mypy: static type checker with html report
	@mypy ./src --html-report ./mypy-html

.PHONY: lint
lint: lint-black lint-isort lint-flake8 lint-mypy ## Runs all linting commands
