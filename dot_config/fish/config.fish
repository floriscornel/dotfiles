# Load mise
if test -f ~/.local/bin/mise
    ~/.local/bin/mise activate fish | source
else if test -f ~/.local/share/mise/bin/mise
    ~/.local/share/mise/bin/mise activate fish | source
end

if test -f ~/.config/mise/config.toml
    mise completion fish | source
end

if test -f ~/.config/pitchfork/config.toml
    pitchfork activate fish | source
    pitchfork completion fish | source
end

chezmoi completion fish | source

# Load starship
if test -f ~/.config/starship.toml
    starship init fish | source
end

export PATH="/opt/homebrew/bin:$PATH"

function fish_greeting
    fastfetch
end