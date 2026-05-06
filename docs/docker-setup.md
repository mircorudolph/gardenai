# Docker Setup

The repository includes a `Dockerfile` that builds a Python 3.12 Streamlit
container and exposes the application on port `8501`.

## Prerequisites

- Docker Desktop for Windows, macOS, or Linux
- An OpenAI API key

Verify Docker is available:

```powershell
docker --version
docker info
```

On Windows, start Docker Desktop before running these commands.

## Build the Image

From the repository root:

```powershell
docker build -t gardenai-app .
```

## Run the Container

PowerShell:

```powershell
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY="your-openai-api-key" gardenai-app
```

Command Prompt:

```cmd
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY="your-openai-api-key" gardenai-app
```

Open http://localhost:8501.

## Run with a Local `.env` File

Create a `.env` file in the repository root:

```text
GARDENAI_API_KEY=your-openai-api-key
```

Then run:

```powershell
docker run --rm -p 8501:8501 --env-file .env gardenai-app
```

## Pulling a Published Image

If a published image is available, run:

```powershell
docker pull mircorudolph/gardenai-app
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY="your-openai-api-key" mircorudolph/gardenai-app
```

## Container Behavior

The Dockerfile performs these steps:

1. Starts from `python:3.12.2`.
2. Copies the repository into `/app`.
3. Installs `requirements.txt`.
4. Exposes port `8501`.
5. Runs `streamlit run client.py --server.port=8501 --server.address=0.0.0.0`.

## Troubleshooting

- Port conflict: if port `8501` is already in use, map a different host port:
  `docker run --rm -p 8502:8501 ...`, then open http://localhost:8502.
- Missing API key: pass `-e GARDENAI_API_KEY="..."` or `--env-file .env`.
- Image uses stale files: rebuild with `docker build --no-cache -t gardenai-app .`.
- Docker Desktop is not running: start Docker Desktop and retry `docker info`.
