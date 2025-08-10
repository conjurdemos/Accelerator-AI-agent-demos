# MCP DB Demos
These demos show various ways agents can connect to a PostgreSQL (Psql) database. It installs a local Psql server for testing. It can also use a proxied connection through CyberArk Secure Infrastructure Access (SIA) if you have one configured. By default it
uses the local Psql server. All configurations are governed by the main config file:
- psql-mcp.env
You can change defaults and add your CyberArk tenant values for SIA connections.
<br>
All the demos work with both the local Psql DB and Psql DBs through CyberArk SIA, determined by the LOCAL_DB boolean variable in psql-mcp.env.
<br>
The Claude Code and LangGraph demos require Anthropic, OpenAI and Tavily accounts and API keys. Only the Tavily account is free. The other demos do not require accounts or API keys.

## 0-setup 
- 0-setup.sh - Installs common system dependencies
    - poetry package manager
    - Docker engine (not desktop)
    - Pulls Psql server & client Docker images
    - Install Node.js
    - Starts & initializes local PostgreSQL DB
- start-psql-db.sh - Starts & initializes local PostgreSQL DB
- _stop-db.sh - Stops and removes DB client & server containers
- *.sql - SQL scripts for initializing DB
- _install-docker.sh - Installs Docker engine for Linux
<br>
The *.sql scripts can also be used to initialize cloud dbs.

## 1-mcp-server
Starts/stops MCP server (and MCP Inspector on MacOS)
- 0-run-server.sh - Starts the MCP Psql Server with http access
  - _stop-server.sh - Kills the MCP server
- 1-start-mcp-inspector.sh - Starts MCP Inspector on MacOS
  - _stop-inspector - Kills the MCP Inspector

## 2-self-hosted
Runs a self-hosted LLM as agent for MCP server
- 0-setup.sh - Installs Ollama, go and builds mcphost
- 1-run-mcphost.sh
  - Starts Ollama server, downloads llama3.2:1b model and runs mcphost client using local LLM
  - Connects to MCP Psql server over http using config in: mcphost-mcp-psql.json

## 3-claude-desktop
Unpacks a Claude Desktop Extension (MacOs only). Assumes you have Claude Desktop installed. If not, go here: https://claude.ai/download
- 0-config-mcp-ext-for-claude-desktop.sh
  - Unzips psql-mcp.dxt extension zipfile
  - Modifies psql-dxt/manifest.json to reference main config file psql-mcp.env
To import the extension into Claude Desktop
  - Navigate in menu: Claude -> Settings -> Extensions -> Advanced Settings
  - Under "Extension Developer" click "Install unpacked extension..."
  - Navigate to psql-dxt directory and click Open and Install when asked.
  - Click on Extensions in the left menu.
The extension takes a few seconds to load. The screen will change to show the psql-mcp extension is enabled. It will initially show this error:
> Permissions
>> Error: Unable to connect to extension server. Please try disabling and re-enabling the extension.
<br>
Just wait a few more seconds and it should change to show the run_sql_query tool is enabled.<br>
<br>
The extension runs its own MCP Psql server connected via stdio. So it will work even
if the HTTP MCP server is not running. You can start a new conversation (File -> New Conversation) and use natural language to query the database. The model is strikingly good at learning the DB schema and generating complex SQL queries including multi-table joins.

## 4-claude-code
Installs Claude Code and configures it for the MCP Psql server.
- 0-setup.sh - Adds Psql MCP server config to Claude Code (Requires Anthropic/Claude account)
- 1-start-claude-code.sh - just runs claude. It will prompt you for your account info.

## 5-langgraph
Runs LangGraph agent that uses native LangChain classes (no MCP server) to connect to Psql DBs (Requires OpenAI and Tavily accounts with API keys).