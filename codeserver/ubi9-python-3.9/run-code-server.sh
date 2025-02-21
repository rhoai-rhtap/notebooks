#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=$(dirname -- "$0")
source ${SCRIPT_DIR}/utils/*.sh

# Start nginx and fastcgiwrap
run-nginx.sh &
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap 

# Add .bashrc for custom promt if not present
if [ ! -f "/opt/app-root/src/.bashrc" ]; then
  echo 'PS1="\[\033[34;1m\][\$(pwd)]\[\033[0m\]\n\[\033[1;0m\]$ \[\033[0m\]"' > /opt/app-root/src/.bashrc
fi

# Initilize access logs for culling
echo '[{"id":"code-server","name":"code-server","last_activity":"'$(date -Iseconds)'","execution_state":"running","connections":1}]' > /var/log/nginx/vscode.access.log

# Check if code-server exists
if [ ! -f "/opt/app-root/src/.local/share/code-server" ]; then

    # Check internet connection
    if curl -Is http://www.google.com | head -n 1 | grep -q "200 OK"; then
        # Internet connection is available
        echo "Internet connection available. Installing specific extensions."

        # Install specific extensions
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-python.python-2023.14.0.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.jupyter-2023.3.100.vsix
    else
        # No internet connection
        echo "No internet connection. Installing all extensions."

        # Install all extensions
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-python.python-2023.14.0.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.jupyter-2023.3.100.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.jupyter-keymap-1.1.2.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.jupyter-renderers-1.0.17.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.vscode-jupyter-cell-tags-0.1.8.vsix
        code-server --install-extension ${SCRIPT_DIR}/utils/ms-toolsai.vscode-jupyter-slideshow-0.1.5.vsix
    fi
fi

# Start server
start_process /usr/bin/code-server \
  --bind-addr 0.0.0.0:8787 \
  --disable-telemetry \
  --auth none \
  --disable-update-check \
  /opt/app-root/src
