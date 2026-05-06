# Development Notes

This project is a lightweight Python application. There is no separate build
step outside dependency installation, and the primary runtime command is
Streamlit.

## Repository Layout

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

## Local Development Loop

1. Activate the virtual environment.
2. Set `GARDENAI_API_KEY`.
3. Run the app:

```powershell
python -m streamlit run client.py
```

4. Edit Python files or documentation.
5. Restart Streamlit if code changes do not reload automatically.

## Dependency Management

Dependencies are listed in `requirements.txt`. The file currently contains a
full package list with pinned versions. Install it with:

```powershell
python -m pip install -r requirements.txt
```

When updating dependencies, verify that Streamlit still starts and that OpenAI
tool calls continue to work with the installed `openai` package version.

## Manual Validation

There is no automated test suite in the current repository. For documentation
or small code changes, use these checks:

```powershell
python -m pip install -r requirements.txt
python -m streamlit run client.py
```

Then verify:

- The app starts without import errors.
- `data/native_plants_AL_MI_v_1.csv` loads successfully.
- The browser opens at http://localhost:8501.
- A valid `GARDENAI_API_KEY` is present before testing model responses.

## Documentation Validation

For documentation-only changes:

- Confirm all documentation links resolve within the repository.
- Confirm Mermaid diagrams use fenced `mermaid` code blocks.
- Confirm Windows commands use PowerShell or Command Prompt syntax explicitly.
- Confirm Docker commands expose container port `8501` to the host.

## Configuration

`api_call.py` loads environment variables through `python-dotenv` and then reads
`GARDENAI_API_KEY`.

Recommended local configuration:

```text
GARDENAI_API_KEY=your-openai-api-key
```

Do not commit `.env` files or real API keys.

## Data Notes

`data_connector.load_data` reads the CSV from `./data/` at application startup.
The current function accepts `path` and `file_name` arguments, but always uses
`native_plants_AL_MI_v_1.csv` internally. Keep documentation and examples aligned
with that file until the loader is generalized.
