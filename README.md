# MCP DB Demos
These demos show various ways agents can connect to a PostgreSQL (Psql) database. It allows you to install a local Psql server for testing and will also use a proxied connection through CyberArk Secure Infrastructure Access (SIA) if you have one configured.

## 0-Setup 
0-setup.sh - Installs common system dependencies
 - poetry package manager
 - Docker engine (not desktop)
 - Pulls Psql server & client Docker images
 - Install Node.js
 - Starts & initializes local PostgreSQL DB
start-psql-db.sh - Starts & initializes local PostgreSQL DB
_stop-db.sh - Stops and removes DB client & server containers
*.sql - SQL scripts for initializing DB
_install-docker.sh - Installs Docker engine for Linux

The *.sql scripts can also be used to initialize cloud dbs.
## 1) Run MCP server w/ Inspector
## 2) Self-hosted everything
- mcphost & ollama
## 3) Claude Code
## 4) LangGraph
## 5) Claude Desktop (MacOs only)
Permissions
Error: Unable to connect to extension server. Please try disabling and re-enabling the extension.