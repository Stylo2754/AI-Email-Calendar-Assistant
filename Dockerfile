FROM python:3.11-slim

WORKDIR /app

# Install poetry
RUN pip install --no-cache-dir poetry

# Install langgraph CLI
RUN pip install langgraph-cli

# Copy only pyproject.toml and poetry.lock first to leverage Docker cache
COPY pyproject.toml poetry.lock* README.md ./
COPY eaia/ ./eaia/

# Install dependencies into the system's python environment
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --only main

# Copy the rest of the application code
COPY scripts/ ./scripts/
COPY langgraph.json .

# The default port for the langgraph server
EXPOSE 8000

# The command to run the application using the langgraph CLI on port 8000 for local use
CMD ["langgraph", "up", "--port", "8000"] 