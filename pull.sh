#!/bin/bash

# This script is used to pull local modifications to the dotfiles repository.

CURRENT_DIR="$(dirname "$(realpath "$0")")"

cp ~/.config/mise/config.toml "$CURRENT_DIR/dot_config/mise/config.toml"