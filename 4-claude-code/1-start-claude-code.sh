#!/bin/bash
# Global Protect certs are self-signed and the node.js
# client will not connect using them.
# This is a workaround for that.
# It is not recommended for production use.
# It is only for development purposes.
# Do not use this in production environments.
# (above caveats suggested by Copilot :))
if [[ "$(uname)" == "Darwin" ]]; then
  export NODE_TLS_REJECT_UNAUTHORIZED=0
fi

claude
