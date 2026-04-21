#!/bin/bash
echo "Setting fish as the default shell..."

# Get the path to the mise-installed fish
FISH_PATH="$HOME/.local/share/mise/shims/fish"

# Add it to /etc/shells if it's not already there (requires sudo)
if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Change the default shell
sudo chsh -s "$FISH_PATH" "$USER"
