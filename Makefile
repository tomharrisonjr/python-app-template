format-black:
	@black .

format-isort:
	@isort .

lint-black:
	@black . --check

link-isort:
	@isort . --check

lint-flake8:
	@flake8 .

lint-mypy:
	@mypy ./src

lint-mypy-report:
	@mypy ./src --html-report ./mypy-html

format: format-black format-isort

lint: lint-black lint-isort lint-flake8 lint-mypy
