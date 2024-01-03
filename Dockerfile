FROM python:3.12.1-slim

RUN apt-get -y update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends \
    curl; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# install poetry
ENV POETRY_VERSION=1.7.1
ENV GUNICORN_VERSION=20.1.0

RUN pip install "poetry==$POETRY_VERSION"

RUN pip install gunicorn==$GUNICORN_VERSION

# copy application
COPY ["pyproject.toml", "poetry.lock", "README.md", "main.py", "./"]
COPY ["src/", "src/"]

# build wheel
RUN poetry build --format wheel

# install wheel
RUN pip install dist/*.whl

EXPOSE 80

CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:80", "--workers", "1", "--worker-class", "uvicorn.workers.UvicornWorker" ]
