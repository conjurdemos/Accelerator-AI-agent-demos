# mcp-mysql.py
import os, sys, logging
from pathlib import Path
from fastmcp import FastMCP
from typing import List, Dict, Any
from pymssql import connect

# Setup logging to new/overwritten logfile with loglevel
Path("./logs").mkdir(parents=True, exist_ok=True)
logfile = f"./logs/mcp-mssql.log"
logfmode = "w"  # w = overwrite, a = append
# Log levels: NOTSET DEBUG INFO WARN ERROR CRITICAL
loglevel = logging.DEBUG
# Cuidado! DEBUG will leak secrets!
logging.basicConfig(
    filename=logfile, encoding="utf-8", level=loglevel, filemode=logfmode
)

def _check_env(var: str):
    if not os.environ.get(var):
        print(f"Required env var {var} is not set.", file=sys.stderr)
        sys.exit(-1)
    else:
        return os.getenv(var)

USER = _check_env("DB_USERNAME")
PASSWORD = _check_env("DB_PASSWORD")
HOST = _check_env("DB_HOST")
PORT = _check_env("DB_PORT")
DATABASE = _check_env("DB_DATABASE")
config = {
    "database": f"{DATABASE}",
    "user": f"{USER}",
    "password": f"{PASSWORD}",
    "host": f"{HOST}",
    "port": int(PORT),
}

class DatabaseConnector:
    def __init__(self, config):
        self.config = config
        self.connect()

    def connect(self):
        print(f"Connecting as user {self.config['user']} to db server at {self.config['host']}")
        logging.info(f"Connecting as user {self.config['user']} to db server at {self.config['host']}")
        logging.debug(f"Database: {self.config['database']}, Password: {self.config['password']}, Port: {self.config['port']}")
        try:
            self.connection = connect(
                server=self.config['host'],
                user=self.config['user'],
                password=self.config['password'],
                database=self.config['database'],
                port=self.config['port']
            )
            self.cursor = self.connection.cursor()
        except Exception as e:
            print(f"Error connecting to the database: {e}")
            logging.error(f"Error connecting to the database: {e}")
            sys.exit(-1)

    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        self.connect()
        self.cursor.execute(query)
        columns = [desc[0] for desc in self.cursor.description]
        results = []
        for row in self.cursor.fetchall():
            results.append({columns[i]: row[i] for i in range(len(columns))})
            logging.debug(f"Query result row: {row}")
        self.connection.close()
        return results

mcp = FastMCP("DatabaseTools")
db_connector = DatabaseConnector(config)

@mcp.tool()
def run_sql_query(query: str) -> List[Dict[str, Any]]:
    """Execute a SQL query on the database and return results"""
    try:
        print(f"Executing query: {query}")
        return db_connector.execute_query(query)
    except Exception as e:
        print(f"Error executing query: {e}")
        return {"error": str(e)}


if __name__ == "__main__":
    _check_env("MCP_HTTP_PORT")
    mssql_port = int(os.environ.get("MCP_HTTP_PORT"))
    mcp.run(transport="http", port=mssql_port)
