# Windows Local Setup

These steps assume Windows with Python 3.12 installed. PowerShell examples are
shown first, with Command Prompt alternatives where the syntax differs.

## Prerequisites

- Windows 10 or Windows 11
- Git for Windows
- Python 3.12
- An OpenAI API key

Check the installed versions:

```powershell
git --version
py -3.12 --version
```

If `py -3.12 --version` fails, install Python 3.12 from python.org or the
Microsoft Store, then reopen the terminal.

## Clone the Repository

```powershell
git clone https://github.com/mircorudolph/gardenai.git
cd gardenai
```

## Create and Activate a Virtual Environment

PowerShell:

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks activation scripts, allow scripts for the current user:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
.\.venv\Scripts\Activate.ps1
```

Command Prompt:

```cmd
py -3.12 -m venv .venv
.\.venv\Scripts\activate.bat
```

## Install Dependencies

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

## Configure the API Key

The application reads `GARDENAI_API_KEY`.

PowerShell session variable:

```powershell
$env:GARDENAI_API_KEY = "your-openai-api-key"
```

Command Prompt session variable:

```cmd
set GARDENAI_API_KEY=your-openai-api-key
```

Persistent local `.env` file:

```text
GARDENAI_API_KEY=your-openai-api-key
```

Keep `.env` out of source control because it contains a secret.

## Run the App

```powershell
python -m streamlit run client.py
```

Streamlit normally opens the browser automatically. If it does not, open
http://localhost:8501.

## Stop the App

Press `Ctrl+C` in the terminal that is running Streamlit.

## Common Windows Issues

- `Activate.ps1 cannot be loaded`: run
  `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, then activate again.
- `python is not recognized`: use `py -3.12` or reinstall Python with the
  option to add Python to PATH.
- `ModuleNotFoundError`: confirm the virtual environment is active and rerun
  `python -m pip install -r requirements.txt`.
- OpenAI authentication errors: confirm `GARDENAI_API_KEY` is set in the same
  terminal session that starts Streamlit, or use a `.env` file.
