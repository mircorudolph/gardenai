# GardenAI

GardenAI is a Streamlit application that helps users find native plants for
gardens in Alabama and Michigan. The app combines a local CSV dataset with an
OpenAI chat model and a tool-calling workflow that filters plant records based
on garden conditions.

## Quick Start

### Windows Local Setup

```powershell
git clone https://github.com/mircorudolph/gardenai.git
cd gardenai
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
$env:GARDENAI_API_KEY = "your-openai-api-key"
python -m streamlit run client.py
```

Open the app at http://localhost:8501 if the browser does not open
automatically.

### Docker Setup

```powershell
docker build -t gardenai-app .
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY="your-openai-api-key" gardenai-app
```

The app will be available at http://localhost:8501.

## Documentation

Detailed documentation lives in the dedicated [docs](docs/README.md) folder:

- [Windows setup](docs/windows-setup.md)
- [Docker setup](docs/docker-setup.md)
- [Architecture](docs/architecture.md)
- [Usage guide](docs/usage.md)
- [Development notes](docs/development.md)

## Required Environment Variable

`GARDENAI_API_KEY` must contain a valid OpenAI API key. The application loads
environment variables from the shell and also supports a local `.env` file
through `python-dotenv`.

## Project Structure

```text
.
|-- api_call.py
|-- business_logic.py
|-- client.py
|-- data/
|   `-- native_plants_AL_MI_v_1.csv
|-- data_connector.py
|-- docs/
|-- Dockerfile
|-- requirements.txt
`-- tools.json
```

## Current Data Scope

The included plant dataset supports Alabama (`AL`) and Michigan (`MI`). If a
user asks about another state, the assistant should explain that only Alabama
and Michigan plant data is available.
