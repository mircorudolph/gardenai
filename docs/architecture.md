# Architecture

`gardenai` is a single-process Streamlit application. The browser talks to the
Streamlit server, Streamlit stores chat state in `st.session_state`, and the app
uses OpenAI tool calling to turn user garden preferences into filters for the
local native-plant CSV.

## High-level structure

```mermaid
flowchart LR
    User[Browser user] --> Streamlit[client.py<br/>Streamlit UI]
    Streamlit --> Session[st.session_state<br/>chat history, errors, data]
    Streamlit --> Logic[business_logic.py]
    Logic --> OpenAI[OpenAI Chat Completions]
    Logic --> Data[data_connector.py]
    Data --> CSV[data/native_plants_AL_MI_v_1.csv]
    OpenAI --> Logic
    Logic --> Session
    Session --> Streamlit
```

## Module responsibilities

| File | Responsibility |
| --- | --- |
| `client.py` | Builds the Streamlit UI, initializes session state, loads data, and handles chat/reset callbacks. |
| `business_logic.py` | Sends chat history to OpenAI, handles tool calls, filters plant data, and appends assistant responses. |
| `api_call.py` | Loads `GARDENAI_API_KEY`, reads `tools.json`, and calls OpenAI chat completions. |
| `data_connector.py` | Loads the CSV with pandas and filters it from tool-call arguments. |
| `tools.json` | Defines the function schema OpenAI can use to request plant filtering. |
| `data/native_plants_AL_MI_v_1.csv` | Native plant dataset for Michigan and Alabama. |

## Chat request flow

```mermaid
sequenceDiagram
    participant U as User
    participant C as client.py
    participant B as business_logic.py
    participant A as api_call.py
    participant O as OpenAI
    participant D as data_connector.py

    U->>C: Submit garden details
    C->>C: Append user message to chat history
    C->>B: business_logic(chat_history, df_data)
    B->>A: get_response_openai(chat_history)
    A->>O: Chat completion with tools.json
    O-->>A: Text response or tool call
    A-->>B: Response
    alt Tool call returned
        B->>D: filter_dataframe(df_data, arguments)
        D-->>B: Matching plants
        B->>A: get_response_openai(..., tool_choice="none")
        A->>O: Create final user-facing answer
        O-->>A: Assistant response
    end
    B-->>C: Error or success
    C->>U: Render chat history or error
```

## Runtime and deployment

```mermaid
flowchart TB
    subgraph LocalWindows[Windows CMD local run]
        UV[uv sync --frozen] --> Venv[.venv]
        Venv --> Run[uv run streamlit run client.py]
    end

    subgraph Docker[Docker run]
        Image[Docker image] --> Container[Streamlit container<br/>port 8501]
    end

    Env[GARDENAI_API_KEY] --> Run
    Env --> Container
    Run --> Browser[http://localhost:8501]
    Container --> Browser
```

The local workflow uses `uv sync --frozen` so dependencies come from
`pyproject.toml` and `uv.lock`. The Dockerfile copies `uv` into a Python 3.12
image, runs `uv sync --frozen --no-dev`, exposes port `8501`, and starts
Streamlit on `0.0.0.0`.
