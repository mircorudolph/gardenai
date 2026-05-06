# Usage Guide

GardenAI provides a chat interface for native plant recommendations. The user
describes garden conditions and plant preferences, and the assistant returns
matching plants from the local dataset.

## Supported Geography

The current dataset supports:

- Alabama (`AL`)
- Michigan (`MI`)

For other states, the assistant should explain that plant data is only available
for Alabama and Michigan.

## Supported Garden Inputs

The tool schema in `tools.json` extracts these fields:

| Field | Supported values |
| --- | --- |
| `state` | US state abbreviation; recommendations currently depend on `AL` or `MI`. |
| `habit` | `tree`, `herb`, `shrub`, `grass/grass-like`, `vine`, `cactus/succulent`, `fern`. |
| `duration` | `perennial`, `annual`, `biennial`. |
| `sun` | `sun`, `shade`, `part-shade`. |
| `water` | `dry`, `moist`, `wet`. |
| `other` | Free-text additional preference. |

The app can handle partial information. Empty or unspecified fields are passed
through as empty strings and should be presented as unspecified in the final
answer.

## Example Prompts

```text
I live in Alabama and my garden is sunny, dry, and shaded. I prefer trees.
```

```text
I am looking for an annual herb for the same garden instead of a tree.
```

```text
I live in Michigan, have moist soil, and want a perennial shrub for part shade.
```

```text
I live in Pittsburgh.
```

## Expected Behavior

- Matching plants are returned as a numbered list.
- The response should reflect the structured garden information used for the
  search.
- If no plants match, the response should explain that no plants could be
  retrieved from the dataset for the provided information.
- If the OpenAI API key is missing or invalid, the UI displays a generic error
  and details are printed in the terminal running the app.

## Resetting a Conversation

Use the `Reset` button in the Streamlit UI. This clears `st.session_state`, which
reloads the data and restores the initial system and assistant messages.
