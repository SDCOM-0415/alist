FROM python:3.11.10-alpine3.20
LABEL maintainer='<author>'
LABEL version='0.0.0-dev.0-build.0'

# Install necessary packages
RUN apk add --no-cache \
    libc-dev \
    libffi-dev \
    gcc \
    wget \
    unzip

# Download and unzip the GitHub repository
RUN set -e; \
    DOWNLOAD_URL="https://codeload.github.com/crazypeace/huashengdun-webssh/zip/refs/heads/master"; \
    echo "Downloading from: $DOWNLOAD_URL"; \
    wget "$DOWNLOAD_URL" -O /tmp/webssh.zip || (echo "Download failed. URL may be incorrect." && exit 1); \
    unzip /tmp/webssh.zip -d /tmp && \
    mv /tmp/huashengdun-webssh-master /code && \
    rm /tmp/webssh.zip

WORKDIR /code

# Install Python dependencies
RUN pip install -r requirements.txt --no-cache-dir

# Remove unnecessary packages
RUN apk del gcc libc-dev libffi-dev wget unzip

# Set up user and permissions
RUN addgroup webssh && \
    adduser -Ss /bin/false -g webssh webssh && \
    chown -R webssh:webssh /code

EXPOSE 8888/tcp

USER webssh

CMD ["python", "run.py"]
