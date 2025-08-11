#!/bin/bash
if [[ "$(uname)" == "Linux" ]]; then
  echo "MCP Inspector only works on MacOS (requires a browser)"
  exit -1
fi

echo "Killing any running inspector..."
INSP_PIDS=$(ps -ax | grep modelcontextprotocol | grep -v grep | awk '{print $1}')
if [[ "$INSP_PIDS" != "" ]]; then
  for pid in $INSP_PIDS; do
    kill -9 $pid
  done
fi
mkdir -p logs
echo; echo
echo "Installing and executing mcp-inspector. This may take a bit."
echo "When started, use these values to connect to the MCP server:"
echo "   Transport type: Streamable HTTP"
echo "   URL: http://localhost:$PSQL_MCP_HTTP_PORT/mcp"
echo "Click the Connect button, then the Tools tab (top middle), then List Tools"
echo "Click on run_sql_query tool and you can enter SQL queries in the right window."
echo "   For example: \"select * from pets;\""
echo; echo
nohup npx @modelcontextprotocol/inspector > mcp-inspector.log 2>&1 &
