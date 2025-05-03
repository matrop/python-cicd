# Summary:
# This Dockerfile uses a multi-stage build to separate the building and running dependencies which keeps the resulting image slim
# 1) Setup the installer stage and install poetry in an isolated virtual environment
# 2) Let poetry create a new virtual environment and install all necessary packages into it
# 3) Setup the runner stage and copy the ready-to-use virtual environment from step 2) into it
# 4) Create a non-root user to run the main container process
# 5) Run the python code

# These paths define the directory in which the venv for our project will be build
# The installer stage will populate the venv and install necessary packages via Poetry
# The runner stage will copy the ready-to-use venv over to the runner directory
ARG INSTALLER_PATH=/build
ARG INSTALLER_VENV_PATH=${INSTALLER_PATH}/.venv

FROM python AS base

# This is the first stage where we handle the installation process of necessary python dependencies
FROM base AS installer
ARG INSTALLER_PATH
ARG INSTALLER_VENV_PATH

# Setup Poetry directories explicitly
# Instruct Poetry to setup a virtual environment and place it into the project directory (i.e. INSTALLER_PATH)
ENV POETRY_VERSION="2.1.2" \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PATH="${INSTALLER_VENV_PATH}/bin:$PATH"

# Create a new venv and install poetry into it to isolate it from the rest of the system
RUN python -m venv ${POETRY_HOME} \
    && ${POETRY_HOME}/bin/pip install --no-cache-dir poetry==${POETRY_VERSION}

WORKDIR ${INSTALLER_PATH}

# Mount poetry-related files from the project into the container. This way poetry knows what packages to install
# COPY would also be suitable here, but (TODO)
# After that, instruct Poetry to install only the main (i.e. no dev) dependencies and clear the cache
# Most importantly: The dependencies are installed into the INSTALLER_VENV_PATH, since we instructed Poetry to 
# build a venv and do it in the project directory (POETRY_VIRTUALENVS_* variables). 
# The newly created .venv directory is now ready to use for the runner stage
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=poetry.lock,target=poetry.lock \
    ${POETRY_HOME}/bin/poetry install --no-root --only main \
    && rm -rf {POETRY_CACHE_DIR}

FROM base AS runner
ARG INSTALLER_VENV_PATH
ARG WORKDIR=/app

ENV PATH="${WORKDIR}/.venv/bin:$PATH" \
    DOCKER_USER=appuser \
    DOCKER_GROUP=appuser \
    UID=1001 \
    GID=1001

# Security best practice: Do not run the main container process as root but as an ordinary user
RUN groupadd -g "$GID" "$DOCKER_GROUP" && \
    useradd -l -u "$UID" -g "$DOCKER_GROUP" -s /bin/sh -m "$DOCKER_USER"

# Fetch the ready-to-use venv from the installer stage without the overhead of Poetry, etc. -> Multi-Stage build are really powerful
COPY --from=installer $INSTALLER_VENV_PATH $WORKDIR/.venv

WORKDIR $WORKDIR
COPY src src

USER "$DOCKER_USER"
EXPOSE 8080

ENTRYPOINT ["python", "-m", "uvicorn", "src.api:app", "--host", "0.0.0.0", "--port", "8080"]