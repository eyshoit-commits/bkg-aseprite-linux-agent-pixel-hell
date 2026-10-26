# syntax=docker/dockerfile:1

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    libc++1-18 \
    libfontconfig1 \
    libx11-6 \
    libxcursor1 \
    libxext6 \
    libxrandr2 \
    && rm -rf /var/lib/apt/lists/* 

COPY --from=ghcr.io/kidthales/aseprite:v1.3.18.6-headless /opt/aseprite/bin/aseprite /usr/local/bin/aseprite
RUN ln -sf /usr/local/bin/aseprite /usr/local/bin/ase

WORKDIR /workspace
COPY . /workspace

RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir pillow

RUN aseprite --batch --version

CMD ["bash", "-lc", "python3 scripts/forge.py doctor"]
