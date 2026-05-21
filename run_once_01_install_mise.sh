#!/bin/bash
echo "Installing mise..."
curl https://mise.run | sh

echo "Installing global tools via mise..."
# Ensure the path is temporarily available for the script
export PATH="$HOME/.local/share/mise/bin:$PATH"

# Setup GitHub authentication to avoid rate limits during installation
mise x gh -- gh auth login

mise install -y
