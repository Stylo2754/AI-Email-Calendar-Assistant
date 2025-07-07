FROM python:3.11-slim

WORKDIR /app

# Install poetry and langgraph CLI in one layer for efficiency
RUN pip install --no-cache-dir poetry langgraph-cli \
    && rm -rf /root/.cache/pip

# Copy only pyproject.toml, poetry.lock, and README.md first to leverage Docker cache
COPY pyproject.toml poetry.lock* README.md ./

# Install dependencies into the system's python environment
ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/tmp/poetry-cache'
RUN poetry install --no-ansi --only main \
    && rm -rf $POETRY_CACHE_DIR

# Copy the rest of the application code
COPY eaia/ ./eaia/
COPY scripts/ ./scripts/
COPY langgraph.json .

# The default port for the langgraph server
EXPOSE 8000

# The command to run the application using the langgraph CLI on port 8000 for local use
CMD ["langgraph", "up", "--port", "8000"] 