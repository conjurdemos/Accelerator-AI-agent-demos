# MCP DB Demos
These demos show various ways agents can connect to a PostgreSQL (Psql) database. It installs a local Psql database server for testing. It can also use a proxied connection through CyberArk Secure Infrastructure Access (SIA) if you have one configured. By default it uses the local Psql server. All configurations are governed by the main config file: **psql-mcp.env**<br>
You can change defaults and add your CyberArk tenant values for SIA connections.
<br>
The database the server connects to is determined by the LOCAL_DB boolean variable in psql-mcp.env. true -> local DB, false -> remote DB using SIA
<br>
The Claude Code and LangGraph demos require Anthropic, OpenAI and Tavily accounts and API keys. Only the Tavily account is free. The other demos do not require accounts or API keys.

## 0-setup
Start here to install common demo dependencies and start a local Psql DB server.
#### Directory contents
- 0-setup.sh - Installs common system dependencies
    - poetry package manager
    - Docker engine (not desktop)
    - Pulls Psql server & client Docker images
    - Install Node.js
    - Starts & initializes local PostgreSQL DB
- 1-start-psql-db.sh - Starts & initializes local PostgreSQL DB
- _stop-db.sh - Stops and removes DB client & server containers
- db_*.sql - SQL scripts for initializing the local DB
<br>
You can use the psql CLI and the *.sql scripts to initialize cloud dbs.<br>
The local DB is named petclinic and initialized with a simple 3-table schema:

 - pets: name, birth_date
 - type: type
 - owners: first_name, last_name, address, city, telephone

You can try to get the model to generate a multi-table join with the prompt:
> list all pet info in the db including name, type, birthdate and all owner information for each.
The self-hosted llama3.2:1b model fails miserably. The Claude Sonnet 4 model succeeds impressively.

#### Procedure
- Run: 0-setup.sh
- Run: 1-start-psql-db.sh

## 1-mcp-server
Starts/stops MCP HTTP (remote) server (and MCP Inspector on MacOS)
Once the MCP server and DB are started you can run any of the other demos.
#### Directory contents
- 0-run-server.sh - Starts the MCP Psql Server with http access
  - _stop-server.sh - Kills the MCP server
- 1-start-mcp-inspector.sh - Starts MCP Inspector on MacOS
  - _stop-inspector - Kills the MCP Inspector
#### Procedure
- Run: 0-run-server.sh
- Run: 1-start-mcp-inspector
Installs and executes the mcp-inspector. This may take a little while.
When started, use these values to connect to the MCP server:<br>
  - Transport type: Streamable HTTP<br>
  - URL: http://localhost:<port>/mcp (displayed on server startup)
<br>
Click the Connect button, then the Tools tab (top middle), then List Tools.<br>
Click on run_sql_query tool and you can enter SQL queries in the right window.<br>
  - For example: "select * from pets;"<br>
The Inspector is not attached to any LLM so it cannot process natural language prompts.

## 2-self-hosted
Runs a self-hosted LLM in Ollama as an agent for the MCP server.
#### Directory contents
- 0-setup.sh - Installs Ollama, go and builds mcphost
- 1-run-mcphost.sh
  - Starts Ollama server, downloads llama3.2:1b model and runs mcphost client using local LLM
  - Connects to MCP Psql server over http using config in: mcphost-mcp-psql.json
#### Procedure
- Run: 0-setup.sh
- Run: 1-run-mcphost.sh
- Enter: natural language prompts. A simple prompt to get started is "list all pets in the db"<br>
You can browse other Ollama LLM at: https://ollama.com/search and download models with:<br>
>ollama pull _model-name_<br>

Some models are tuned for specific purposes. Larger models tend to work better in general.

## 3-claude-desktop
Implements a Claude Desktop Extension (MacOs only). Assumes you have Claude Desktop installed. If not, go here to install it: https://claude.ai/download
#### Directory contents
- 0-config-mcp-ext-for-claude-desktop.sh
  - Modifies psql-dxt/manifest.json to run _run-server.sh
- _run-server.sh - installs dependencies and runs mcp-psql.py with stdio connection
- mcp-psql.py - the MCP Psql server
- psql-dxt - directory containing manifest template and icon image for the extension
- pyproject.toml - Python dependency manifest
#### Procedure
- Run: 0-config-mcp-ext-for-claude-desktop.sh
- Import the extension into Claude Desktop
  - Navigate in menu: Claude -> Settings -> Extensions -> Advanced Settings
  - Under "Extension Developer" click "Install unpacked extension..."
  - Navigate to psql-dxt directory and click Open and Install when asked.
  - Click on Extensions in the left menu.
The extension takes a few seconds to load. The screen will change to show the psql-mcp extension is enabled. It will initially show this error for ~15 seconds while the server connects to the DB:
> Permissions
>> Error: Unable to connect to extension server. Please try disabling and re-enabling the extension.
<br>
Just wait and it should change to show the run_sql_query tool is enabled.<br>
<br>
Once the extension is loaded you don't need to load it again unless you move or rename something it references (see manifest.json and _run-server.sh). The extension runs its own MCP Psql server connected via stdio. So it will start even if the HTTP MCP server is not running. You can start a new conversation (File -> New Conversation) and use natural language to query the database. The model is strikingly good at learning the DB schema and generating complex SQL queries including multi-table joins.

## 4-claude-code
Installs Claude Code and configures it for the MCP Psql server.
#### Directory contents
- 0-setup.sh - Adds Psql MCP server config to Claude Code (Requires Anthropic/Claude account)
- 1-start-claude-code.sh - just runs claude. It will prompt you for your account info.
#### Procedure
- Run: 0-setup.sh
- Run: 1-start-claude-code.sh

## 5-langgraph
Runs LangGraph process with two agents that use native LangChain classes (no MCP server) to connect to Psql DBs (Requires OpenAI and Tavily accounts with API keys).
#### Directory contents
- 0-run-agent.sh - installs dependencies and runs lg-psql.py
- lg-psql.py - the monolithic process that runs two agents, one for the DB, one for the search engine.
#### Procedure
- Run: 0-run-agent.sh
Once the process finishes startup it will present a "User:" prompt. You can enter natural language prompts and the LangGraph orchestrator will decide how to process it. Depending on how the prompt is worded, it may choose to use the Tavily search engine or the SQL agent. Sometimes you have to include a reference to the database to guide it to use the SQL agent.