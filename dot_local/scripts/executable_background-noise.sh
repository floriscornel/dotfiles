#!/bin/bash

# Control macOS Comfort Sounds (background noise) via `defaults`.
#
# Usage:
#   bm                    Toggle on/off
#   bm on                 Enable
#   bm off                Disable
#   bm up                 Increase volume by one step
#   bm down               Decrease volume by one step
#   bm <n>                Set volume to n percent (1-100)
#   bm volume up|down|<n>  Same as above (explicit form)

DOMAIN="com.apple.ComfortSounds"
VOLUME_STEP="0.1"

is_enabled() {
    [ "$(defaults read "$DOMAIN" comfortSoundsEnabled 2>/dev/null)" = "1" ]
}

restart_daemon() {
    killall heard 2>/dev/null || true
}

enable() {
    echo "Enabling Comfort Sounds"
    defaults write "$DOMAIN" comfortSoundsEnabled -bool true
    restart_daemon
}

disable() {
    echo "Disabling Comfort Sounds"
    defaults write "$DOMAIN" comfortSoundsEnabled -bool false
    restart_daemon
}

toggle() {
    if is_enabled; then
        disable
    else
        enable
    fi
}

# Write a clamped 0.0-1.0 volume and report the result.
apply_volume() {
    local new="$1"
    defaults write "$DOMAIN" relativeVolume -float "$new"
    restart_daemon
    awk -v v="$new" 'BEGIN { printf "Comfort Sounds volume: %d%%\n", v * 100 + 0.5 }'
}

bump_volume() {
    local direction="$1"
    local current
    current=$(defaults read "$DOMAIN" relativeVolume 2>/dev/null || echo "0.5")

    apply_volume "$(awk -v cur="$current" -v step="$VOLUME_STEP" -v dir="$direction" 'BEGIN {
        v = (dir == "up") ? cur + step : cur - step;
        if (v > 1) v = 1;
        if (v < 0) v = 0;
        printf "%.4f", v;
    }')"
}

set_volume_pct() {
    local pct="$1"
    if ! [[ "$pct" =~ ^[0-9]+$ ]] || [ "$pct" -lt 1 ] || [ "$pct" -gt 100 ]; then
        echo "Volume must be an integer between 1 and 100" >&2
        exit 1
    fi
    is_enabled || enable
    apply_volume "$(awk -v p="$pct" 'BEGIN { printf "%.4f", p / 100 }')"
}

# Route a volume sub-argument (up/down/integer).
do_volume() {
    case "$1" in
        up)   bump_volume up ;;
        down) bump_volume down ;;
        *)    set_volume_pct "$1" ;;
    esac
}

case "$1" in
    "")          toggle ;;
    on)          enable ;;
    off)         disable ;;
    up|down)     bump_volume "$1" ;;
    volume)      do_volume "$2" ;;
    [0-9]*)      set_volume_pct "$1" ;;
    *)
        echo "Usage: bm [on|off|up|down|<1-100>|volume up|down|<1-100>]" >&2
        exit 1
        ;;
esac
