#!/bin/bash
source ../psql-mcp.env

# Uncomment lines and set api key values
# MAKE SURE YOU DO NOT CHECK THEM INTO GITHUB!!
#export OPENAI_API_KEY=
#export TAVILY_API_KEY=

ALL_ENV_VARS_SET=true
if [[ "$OPENAI_API_KEY" == "" ]]; then
  echo "OPENAI_API_KEY is unset."
  ALL_ENV_VARS_SET=false
fi
if [[ "$TAVILY_API_KEY " == "" ]]; then
  echo "TAVILY_API_KEY is unset."
  ALL_ENV_VARS_SET=false
fi
if [[ $ALL_ENV_VARS_SET == false ]]; then
  echo "Set env vars with valid API keys to run demo."
  exit -1
fi

echo "Updating python dependencies..."
poetry update
echo "Starting LangGraph agent..."
poetry run python lg-psql.py
