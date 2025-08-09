#!/bin/bash
source ../psql-mcp.env
# LLM api keys
export OPENAI_API_KEY=$(keyring get cybrid openaiapi)
# Tool api keys
export TAVILY_API_KEY=$(keyring get cybrid tavilyapi)
echo "Updating python dependencies..."
poetry update
echo "Starting LangGraph agent..."
poetry run python lg-psql.py
