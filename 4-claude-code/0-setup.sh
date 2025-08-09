#!/bin/bash

source ../psql-mcp.env

if [[ "$(which claude)" == "" ]]; then
  npm install -g @anthropic-ai/claude-code
fi

<<END_COMMENTS
Usage: claude mcp add [options] <name> <commandOrUrl> [args...]
Add a server
Options:
  -s, --scope <scope>          Configuration scope (local, user, or project) (default:
                               "local")
  -t, --transport <transport>  Transport type (stdio, sse, http) (default: "stdio")
  -e, --env <env...>           Set environment variables (e.g. -e KEY=value)
  -H, --header <header...>     Set HTTP headers for SSE and HTTP transports (e.g. -H
                               "X-Api-Key: abc123" -H "X-Custom: value")
  -h, --help                   Display help for command
END_COMMENTS

claude mcp add 	--scope local		\
		--transport http	\
		psql-api		\
		http://127.0.0.1:$PSQL_MCP_HTTP_PORT/mcp/
