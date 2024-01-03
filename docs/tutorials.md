# Tutorials

## GitHub
You'll need to create 2 repository variables, and 1 secret in GitHub
* `PYTHON_VERSION` (currently `3.12.1`)
* `POETRY_VERSION` (currently `1.7.1`)
* `GH_TOKEN` (a personal access token as a repository secret, having `repo` scope)
    * Note: `GITHUB_TOKEN` is a built-in secret so cannot be used

## Makefile
* `make` or `make help` to see all the options

## Docker
* **Build**: `docker build --tag project:latest .`
    * or `make build`
* **Run**: `docker run -p 9000:80 -it --rm  project:latest`
    * or `make run`
* **Shell**: `docker run -p 9000:80 -it --rm  project:latest /bin/bash`
    * or `make run-bash` 
* **Web**: [http://localhost:9000](http://localhost:9000)

