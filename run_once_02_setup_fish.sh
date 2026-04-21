#!/bin/bash

# Define the path where mise installs fish
FISH_PATH="$HOME/.local/share/mise/shims/fish"

# Print a highly visible banner with manual instructions
cat << EOF

==============================================================================
🐟 FISH SHELL INSTALLED SUCCESSFULLY 🐟
==============================================================================

Fish has been installed via mise, but your default shell has NOT been changed 
to prevent breaking system-level scripts.

To start fish temporarily, just type:
  fish

To make fish load automatically on this specific machine, choose ONE method below:

METHOD A: The Rootless "Exec Trick" (Recommended for VMs)
Append the following block to your ~/.bashrc or ~/.zshrc:

if [ -x "$FISH_PATH" ] && [ -n "\$PS1" ]; then
    exec "$FISH_PATH"
fi

------------------------------------------------------------------------------
METHOD B: Change System Login Shell (Requires Sudo)
Run these two commands manually:

echo "$FISH_PATH" | sudo tee -a /etc/shells
chsh -s "$FISH_PATH"

==============================================================================
EOF
