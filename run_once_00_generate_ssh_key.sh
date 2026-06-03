#!/bin/bash

KEY_PATH="$HOME/.ssh/id_ed25519"

if [ -f "$KEY_PATH" ]; then
    echo "SSH key already exists at $KEY_PATH, skipping generation."
    exit 0
fi

echo "No SSH key found at $KEY_PATH, generating a new ed25519 key..."
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "$(whoami)@$(hostname)"
echo "SSH key generated at $KEY_PATH"

# Initialize ~/.ssh/config with default settings if it doesn't exist
SSH_CONFIG="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG" ]; then
    echo "Creating default SSH config at $SSH_CONFIG"
    cat <<EOL > "$SSH_CONFIG"
Host *
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile $KEY_PATH
	User root
	SetEnv TERM=xterm-256color
EOL
    chmod 600 "$SSH_CONFIG"
else
    echo "SSH config already exists at $SSH_CONFIG, skipping creation."
fi