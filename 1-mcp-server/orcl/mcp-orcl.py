# mcp-mysql.py
import os, sys, logging
from pathlib import Path
from fastmcp import FastMCP
from typing import List, Dict, Any
import oracledb

# Setup logging to new/overwritten logfile with loglevel
Path("./logs").mkdir(parents=True, exist_ok=True)
logfile = f"./logs/mcp-orcl.log"
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


# Replace with your actual wallet details and credentials
wallet_dir = "/Users/Jody.Hunt/Downloads"
db_user = "admin"
db_password = "foo"
wallet_password = "bar"
dsn_alias = "ORACLE_TIGR_ORACLE"

class DatabaseConnector:
    def __init__(self):
        self.connect()

    def connect(self):
        print(f"Connecting to database using dsn: {dsn_alias}")
        logging.debug(f"Connecting to database using dsn: {dsn_alias}")
        try:
            self.connection = oracledb.connect(
                user=db_user,
                password=db_password,
                dsn=dsn_alias,
                config_dir=wallet_dir,
                wallet_location=wallet_dir,
            )
            print("Successfully connected to Oracle Database using wallet!")
            self.cursor = self.connection.cursor()
        except oracledb.Error as e:
            print(f"Error connecting to Oracle Database: {e}")
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
db_connector = DatabaseConnector()


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
#    _check_env("MCP_HTTP_PORT")
#    psql_port = int(os.environ.get("MCP_HTTP_PORT"))
    mcp.run(transport="http", port=8050)
