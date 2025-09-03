#!/bin/bash
if [[ $# < 1 || *"psqlorclmssql" != *"$1"* ]]; then
  echo "Usage: $0 [ psql | orcl | mssql ]"
  echo "Defaulting to psql."
  DBTYPE="psql"
else
  DBTYPE=$1
fi

source ../$DBTYPE-mcp.env

if [[ "$ALL_GOOD" == "false" ]]; then
  echo; echo
  echo "Please fix above issue and retry."
  echo; echo
  exit -1
fi

echo "Killing any running MCP server..."
MCP_PIDS=$(ps -ax | grep mcp | grep py$ | grep -v grep | awk '{print $1}')
if [[ "$MCP_PIDS" != "" ]]; then
  for pid in $MCP_PIDS; do
    kill -9 $pid
  done
fi
echo "Updating Python dependencies..."
poetry update
echo "Starting MCP server in background..."
rm -f mcp-$DBTYPE.log
nohup poetry run python $DBTYPE/mcp-$DBTYPE.py > mcp-$DBTYPE.log 2>&1 &
echo "Waiting for server to startup..."
sleep 15
cat mcp-$DBTYPE.log
