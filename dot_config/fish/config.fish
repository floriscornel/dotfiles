# Cache the output of `cmd...` to a fish file and source it.
# Regenerates only when the cache is missing or older than the binary.
function _cached_init
    set -l tag $argv[1]
    set -l cache $__fish_config_dir/cache/$tag.fish
    set -l bin (command -v $tag)
    if not test -s $cache; or test $cache -ot $bin
        mkdir -p (dirname $cache)
        $argv[2..] >$cache
    end
    source $cache
end

# Write completions for `name` to ~/.config/fish/completions/<name>.fish
# so fish lazy-loads them on first tab-complete instead of every shell.
function _cached_completion
    set -l name $argv[1]
    set -l file $__fish_config_dir/completions/$name.fish
    set -l bin (command -v $name)
    if not test -s $file; or test $file -ot $bin
        mkdir -p (dirname $file)
        $argv[2..] >$file
    end
end

# Ensure mise's install dir is on PATH before any `command -q mise` check.
# Fresh terminals (e.g. Ghostty) launch with a minimal PATH that excludes ~/.local/bin.
test -x ~/.local/bin/mise; and fish_add_path ~/.local/bin
fish_add_path /opt/homebrew/bin
fish_add_path ~/.orbstack/bin
fish_add_path /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

command -q mise; and _cached_init mise mise activate fish
command -q pitchfork; and _cached_init pitchfork pitchfork activate fish

command -q mise; and _cached_completion mise mise completion fish
command -q pitchfork; and _cached_completion pitchfork pitchfork completion fish
command -q chezmoi; and _cached_completion chezmoi chezmoi completion fish

functions -e _cached_init _cached_completion

function fish_greeting
    fastfetch
end
