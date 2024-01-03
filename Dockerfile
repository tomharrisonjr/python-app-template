FROM python:3.12.1-slim as base

ENV POETRY_VERSION=1.7.1
ENV GUNICORN_VERSION=20.1.0

WORKDIR /app

RUN apt-get -y update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends \
    curl; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ENV PIP_ROOT_USER_ACTION=ignore

RUN pip install --upgrade pip

FROM base AS builder

RUN pip install "poetry==$POETRY_VERSION"

COPY ["pyproject.toml", "poetry.lock", "README.md", "./"]
COPY src/ src/

# build wheel
RUN poetry build --format wheel

FROM base AS production

RUN pip install "gunicorn==$GUNICORN_VERSION"

COPY --from=builder /app/dist/*.whl ./
RUN pip install ./*.whl

COPY main.py .

EXPOSE 80
CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:80", "--workers", "1", "--worker-class", "uvicorn.workers.UvicornWorker" ]
