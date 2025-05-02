# TODO: Understand better what everything does

ARG INSTALLER_VENV_PATH=/build/.venv

FROM python:3.12-slim AS base

FROM base AS installer
ARG INSTALLER_VENV_PATH

ENV POETRY_VERSION="2.1.2" \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PATH="${INSTALLER_VENV_PATH}/bin:$PATH"

RUN python -m venv ${POETRY_HOME} \
    && ${POETRY_HOME}/bin/pip install --no-cache-dir poetry==${POETRY_VERSION}

WORKDIR /build

RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=poetry.lock,target=poetry.lock \
    sh -c '${POETRY_HOME}/bin/poetry install --no-root --only main \
    && rm -rf {POETRY_CACHE_DIR}'

FROM base AS runner
ARG INSTALLER_VENV_PATH
ARG WORKDIR=/app

ENV PATH="${WORKDIR}/.venv/bin:$PATH" \
    DOCKER_USER=appuser \
    DOCKER_GROUP=appuser \
    UID=1001 \
    GID=1001

RUN groupadd -g "$GID" "$DOCKER_GROUP" && \
    useradd -l -u "$UID" -g "$DOCKER_GROUP" -s /bin/sh -m "$DOCKER_USER"

COPY --from=installer $INSTALLER_VENV_PATH $WORKDIR/.venv

WORKDIR $WORKDIR
COPY src src

USER "$DOCKER_USER"
EXPOSE 8080

ENTRYPOINT ["python", "-m", "uvicorn", "src.api:app", "--host", "0.0.0.0", "--port", "8080"]