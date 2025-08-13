#!/bin/bash
source ../psql-mcp.env
if [[ "$ALL_GOOD" == "false" ]]; then
  echo; echo
  echo "Please fix above issue and retry."
  echo; echo
  exit -1
fi

echo "Killing any running server..."
MCP_PIDS=$(ps -ax | grep mcp-psql.py | grep -v grep | awk '{print $1}')
if [[ "$MCP_PIDS" != "" ]]; then
  for pid in $MCP_PIDS; do
    kill -9 $pid
  done
fi
echo "Updating Python dependencies..."
poetry update
echo "Starting MCP PostgreSQL server in background..."
rm -f mcp-psql.log
nohup poetry run python mcp-psql.py > mcp-psql.log 2>&1 &
echo "Waiting for server to startup..."
sleep 15
cat mcp-psql.log
