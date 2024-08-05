# syntax=docker/dockerfile:1

ARG GIT_TAG=${GIT_TAG:-master}

ARG PYTHON_VERSION=3.10.12

FROM python:${PYTHON_VERSION}-slim AS base

# Set environment variables
ENV PIP_NO_CACHE_DIR=yes \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    HOME=/app \
    RESET_INTERVAL=300 \
    PATH="/usr/local/bin:${PATH}" \
    CONFIG_FILE=/config/config.conf

# Install system dependencies
RUN apt-get update && apt-get install -y \
    mktorrent \
    flac \
    lame \
    sox \
    #busybox \
    #git \
    #patch \
    #build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set up the work directory
WORKDIR ${HOME}

COPY ../. .

# Copy the patch file
COPY fix-no-flacs.patch ${HOME}/orpheusbetter-crawler/

# Apply the patch and install orpheusbetter along with its dependencies
RUN cd ${HOME}/orpheusbetter-crawler && \
    pip install --upgrade pip setuptools wheel && \
    pip install . && \
    pip install packaging mutagen requests mechanize MechanicalSoup

# Create necessary directories
RUN mkdir -p ${HOME}/.orpheusbetter /config /tmp /torrents /downloads /output

# Create version file
RUN grep -oP '__version__ = "\K[^"]+' ${HOME}/orpheusbetter-crawler/data/_version.py > ${HOME}/.orpheusbetter/.version

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]