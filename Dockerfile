FROM python:3.12.2

COPY --from=ghcr.io/astral-sh/uv:0.11.9 /uv /uvx /bin/

COPY . /app/

WORKDIR /app

ENV PATH="/app/.venv/bin:$PATH"

RUN uv sync --frozen --no-dev

EXPOSE 8501

ENTRYPOINT ["streamlit", "run", "client.py", "--server.port=8501", "--server.address=0.0.0.0"]
