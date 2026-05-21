#!/bin/bash

# This script is used to pull local modifications to the dotfiles repository.

CURRENT_DIR="$(dirname "$(realpath "$0")")"

cp ~/.config/fish/config.fish "$CURRENT_DIR/dot_config/fish/config.fish"
cp ~/.config/fish/fish_plugins "$CURRENT_DIR/dot_config/fish/fish_plugins"
cp ~/.config/mise/config.toml "$CURRENT_DIR/dot_config/mise/config.toml"
cp ~/.config/pitchfork/config.toml "$CURRENT_DIR/dot_config/pitchfork/config.toml"
cp ~/.config/starship.toml "$CURRENT_DIR/dot_config/starship.toml"