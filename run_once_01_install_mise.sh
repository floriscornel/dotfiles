#!/bin/bash
echo "Installing mise..."
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
else
    echo "mise is already installed, skipping."
fi

echo "Installing global tools via mise..."
# Ensure the path is temporarily available for the script
export PATH="$HOME/.local/share/mise/bin:$PATH"

# Setup GitHub authentication to avoid rate limits during installation
# if `mise x gh -- gh auth status` output does not contain  `Active account: true` then run `mise x gh -- gh auth login` to authenticate with GitHub
if ! mise x gh -- gh auth status 2>&1 | grep -q "Active account: true"; then
  mise x gh -- gh auth login
fi

mise install -y
