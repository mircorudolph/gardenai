# Architecture

GardenAI is a small Streamlit application with a local CSV data source and an
OpenAI chat-completions integration. The core runtime path is:

1. `client.py` renders the Streamlit UI and manages `st.session_state`.
2. `data_connector.py` loads the native plant CSV into a pandas DataFrame.
3. User messages are appended to the chat history.
4. `business_logic.py` sends the chat history to OpenAI through `api_call.py`.
5. OpenAI may call the `retrieve_garden_info` tool defined in `tools.json`.
6. The app filters the DataFrame based on the tool arguments.
7. The filtered plant names are sent back to OpenAI as tool output.
8. OpenAI returns a user-facing response, which Streamlit displays.

## Component Diagram

```mermaid
flowchart LR
    User[User browser] --> Streamlit[client.py<br/>Streamlit UI]
    Streamlit --> Session[st.session_state<br/>chat history, errors, data]
    Streamlit --> Logic[business_logic.py]
    Streamlit --> DataLoad[data_connector.py<br/>load_data]
    DataLoad --> CSV[(data/native_plants_AL_MI_v_1.csv)]
    Logic --> API[api_call.py]
    API --> OpenAI[OpenAI Chat Completions API]
    API --> Tools[tools.json<br/>retrieve_garden_info schema]
    Logic --> Filter[data_connector.py<br/>filter_dataframe]
    Filter --> Session
    Logic --> Session
    Session --> Streamlit
```

## Runtime Sequence

```mermaid
sequenceDiagram
    actor User
    participant UI as client.py / Streamlit
    participant State as st.session_state
    participant Logic as business_logic.py
    participant API as api_call.py
    participant OpenAI as OpenAI API
    participant Data as data_connector.py

    UI->>Data: load_data("./data/", "native_plants_AL_MI_v_1.csv")
    Data-->>UI: pandas DataFrame
    UI->>State: initialize df_data, chat_history, error
    User->>UI: submits garden request
    UI->>State: append user message
    UI->>Logic: business_logic(chat_history, df_data)
    Logic->>API: get_response_openai(chat_history)
    API->>OpenAI: chat.completions.create(messages, tools, model)
    OpenAI-->>API: assistant response or tool call
    API-->>Logic: response

    alt OpenAI requests retrieve_garden_info
        Logic->>Data: filter_dataframe(df_data, tool arguments)
        Data-->>Logic: matching plant rows
        Logic->>State: append assistant tool call and tool result
        Logic->>API: get_response_openai(chat_history, tool_choice="none")
        API->>OpenAI: request final formatted response
        OpenAI-->>API: final assistant message
        API-->>Logic: final response
        Logic->>State: append assistant message
    else OpenAI returns plain assistant message
        Logic->>State: append assistant message
    end

    Logic-->>UI: error or None
    UI->>User: render chat and errors
```

## Data Filtering

```mermaid
flowchart TD
    Args[Tool arguments<br/>state, habit, duration, sun, water, other] --> Copy[Copy source DataFrame]
    Copy --> Columns{Argument key matches<br/>a CSV column?}
    Columns -- No --> Skip[Skip argument]
    Columns -- Yes --> Value{Argument value type}
    Value -- List --> IsIn[Filter with isin]
    Value -- String --> Contains[Case-insensitive contains filter]
    IsIn --> Next[Next argument]
    Contains --> Next
    Skip --> Next
    Next --> Done{More arguments?}
    Done -- Yes --> Columns
    Done -- No --> Result[Filtered DataFrame]
```

## File Responsibilities

| File | Responsibility |
| --- | --- |
| `client.py` | Streamlit layout, chat input, reset button, session state setup, and display rendering. |
| `business_logic.py` | OpenAI response handling, tool-call handling, plant filtering orchestration, and user-facing response generation. |
| `api_call.py` | Environment loading, OpenAI client setup, `tools.json` loading, and chat completion calls. |
| `data_connector.py` | CSV loading and DataFrame filtering helpers. |
| `tools.json` | Tool schema that tells OpenAI how to structure extracted garden information. |
| `data/native_plants_AL_MI_v_1.csv` | Local plant dataset used for recommendations. |

## Environment and Runtime Boundaries

- The browser talks only to Streamlit.
- Streamlit runs locally or inside Docker.
- The app calls OpenAI over the network and requires `GARDENAI_API_KEY`.
- Plant recommendation data is read from the local CSV file.
- No database server is required.
