if test -f ~/.local/share/mise/bin/mise
    ~/.local/share/mise/bin/mise activate fish | source
end
if test -f ~/.config/starship.toml
    starship init fish | source
end
