# Load mise
if test -f ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
else if test -f ~/.local/share/mise/bin/mise
    ~/.local/share/mise/bin/mise activate fish | source
end

# Load starship
if test -f ~/.config/starship.toml
    starship init fish | source
end

export PATH="/opt/homebrew/bin:$PATH"