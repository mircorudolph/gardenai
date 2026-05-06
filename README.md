# gardenai

`gardenai` is a Streamlit chat app that recommends native plants for gardens in
Michigan and Alabama. It uses OpenAI chat completions with a local CSV dataset
from the Native Plant Information Network.

## Documentation

- [Documentation index](docs/README.md)
- [Architecture](docs/architecture.md)

## Requirements

- Windows with Command Prompt
- [uv](https://docs.astral.sh/uv/getting-started/installation/)
- Docker Desktop, if you want to run the container
- An OpenAI API key in `GARDENAI_API_KEY`

## Windows CMD setup with uv

Install uv from CMD by running the official Windows installer through
PowerShell:

```cmd
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Restart CMD so the `uv` command is available, then clone and run the app:

```cmd
git clone https://github.com/mircorudolph/gardenai.git
cd gardenai
uv sync --frozen
set GARDENAI_API_KEY=your_openai_api_key
uv run streamlit run client.py
```

Open the Streamlit URL printed in the terminal. By default it is:

```text
http://localhost:8501
```

## Docker setup

Run the published image:

```cmd
docker pull mircorudolph/gardenai-app
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY=your_openai_api_key mircorudolph/gardenai-app
```

Or build and run the image from this repository:

```cmd
docker build -t gardenai .
docker run --rm -p 8501:8501 -e GARDENAI_API_KEY=your_openai_api_key gardenai
```

Then open:

```text
http://localhost:8501
```

## Usage examples

Try a conversation like:

```text
I live in Alabama and my garden is sunny, dry, and shaded. I prefer trees.
```

Then refine the request:

```text
I am looking for a herb for my same garden instead of a tree.
```

The assistant keeps the conversation history and filters the plant dataset again
with the updated preference.

If you ask for an unsupported state:

```text
I live in Pittsburgh.
```

The assistant should explain that plant data is only available for Michigan and
Alabama.

## Configuration

`GARDENAI_API_KEY` is read from the environment. For a persistent local setup,
you can also create a `.env` file in the repository root:

```text
GARDENAI_API_KEY=your_openai_api_key
```

The app currently calls the `gpt-3.5-turbo` model in `api_call.py`.
