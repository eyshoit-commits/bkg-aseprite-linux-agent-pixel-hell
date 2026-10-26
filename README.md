# bkg-aseprite-linux-agent-pixel-hell

A Dockerized headless Linux Aseprite project for procedural pixel-art generation and agent-driven sprite/scene creation.

This repo combines the Linux Aseprite runtime from the Docker Aseprite headless project with the procedural sprite pipeline and generation workflow from aseprite-pixel-forge.

## What this repo is for

- Headless Aseprite on Ubuntu 24.04
- Python 3 + Pillow runtime
- Batch-safe CLI rendering for pixel-art generation
- Local container-based development with Docker Compose
- Ready for a forge-style `python3 scripts/forge.py ...` workflow

## Quick start

```bash
docker compose build

docker compose run --rm pixel-hell
```

Or direct build/run:

```bash
docker build -t bkg-aseprite-linux-agent-pixel-hell .
docker run --rm -it -v "$PWD:/workspace" bkg-aseprite-linux-agent-pixel-hell bash -lc "python3 scripts/forge.py doctor"
```

## Included runtime stack

- Ubuntu 24.04 LTS
- Aseprite headless CLI binary
- Python 3 + Pillow
- Required GUI/runtime libs for Aseprite headless

## Expected workflow

Once the generation scripts are added to the repo, the usual flow is:

```bash
python3 scripts/forge.py doctor
python3 scripts/forge.py gen tree --style styles/left-hand-of-god.json --out build/tree --count 24 --seed 1000
python3 scripts/forge.py check build/tree
python3 scripts/forge.py preview build/tree --scale 6 --cols 6
python3 scripts/forge.py export build/tree --out out/tree --pick 1,3 --sheet
```

## Repository intent

This repository is a clean Linux runtime base optimized for sprite generation agents and procedural pixel-art pipelines.

