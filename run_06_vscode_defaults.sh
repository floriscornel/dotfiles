#!/bin/bash
# Default source/config file types to Visual Studio Code via duti.
#
# Runs on every `chezmoi apply` (alias: cm apply). Handlers are only written
# when LaunchServices actually resolves a managed type to another app, so a
# clean run is silent and costs ~0.1s; drift (from a macOS or app update, or a
# manual "Open With" change) is healed on the next apply.
#
# Mapping:   ~/.config/duti/settings  (duti settings file: app, type, role)
# Re-apply:  duti ~/.config/duti/settings
#
# Verification asks LaunchServices which application it would use for a probe
# file, i.e. the same decision Finder makes. `duti -x <ext>` is NOT used: on
# macOS 26 it reports the handler of a shadow UTI (e.g. .md -> public.markdown,
# owned by Word) rather than the type real files get (net.daringfireball.markdown).
# Entries written as a UTI (e.g. public.plain-text) are checked with `duti -d`.

set -uo pipefail

APP="com.microsoft.VSCode"
APP_PATH="/Applications/Visual Studio Code.app"
SETTINGS="${XDG_CONFIG_HOME:-$HOME/.config}/duti/settings"

[ "$(uname -s)" = "Darwin" ] || exit 0

# chezmoi scripts can start with a minimal PATH; make Homebrew reachable.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

[ -r "$SETTINGS" ] || { echo "vscode-defaults: $SETTINGS missing, skipping" >&2; exit 0; }
[ -d "$APP_PATH" ] || { echo "vscode-defaults: $APP_PATH not installed, skipping" >&2; exit 0; }

if ! command -v duti >/dev/null 2>&1; then
    if command -v brew >/dev/null 2>&1; then
        echo "vscode-defaults: installing duti via Homebrew..."
        if ! HOMEBREW_NO_AUTO_UPDATE=1 brew install duti; then
            echo "vscode-defaults: brew install duti failed, skipping" >&2
            exit 0
        fi
    else
        echo "vscode-defaults: duti not installed and Homebrew not found, skipping." >&2
        echo "vscode-defaults: install duti (https://github.com/moretension/duti), then re-run chezmoi apply." >&2
        exit 0
    fi
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/vscode-defaults.XXXXXX") || exit 0
trap 'rm -rf "$tmpdir"' EXIT
drift="$tmpdir/drift"

cat > "$tmpdir/opener.js" <<'JXA'
ObjC.import('AppKit');
function run(argv) {
  var ws = $.NSWorkspace.sharedWorkspace, out = [];
  for (var i = 0; i < argv.length; i++) {
    var appUrl = ws.URLForApplicationToOpenURL($.NSURL.fileURLWithPath(argv[i]));
    var id = '<none>';
    if (!appUrl.isNil()) {
      var bundle = $.NSBundle.bundleWithURL(appUrl);
      if (!bundle.isNil()) id = ObjC.unwrap(bundle.bundleIdentifier);
    }
    out.push(argv[i].replace(/.*probe\./, '') + '\t' + id);
  }
  return out.join('\n');
}
JXA

entries() { grep -vE '^[[:space:]]*(#|$)' "$SETTINGS"; }

# LaunchServices types an empty file by its extension, which is exactly what we
# want to check for each extension-based entry.
probes=""
while read -r _app token _role; do
    case "$token" in *.*) continue ;; esac
    : > "$tmpdir/probe.$token"
    probes="$probes $tmpdir/probe.$token"
done < <(entries)

# Writes "type<TAB>current owner" for every managed type that is not VS Code.
collect_drift() {
    : > "$drift"
    if [ -n "$probes" ]; then
        osascript "$tmpdir/opener.js" $probes 2>/dev/null |
            awk -F'\t' -v app="$APP" '$2 != app { print }' >> "$drift"
    fi
    while read -r app token _role; do
        case "$token" in *.*) ;; *) continue ;; esac
        cur=$(duti -d "$token" 2>/dev/null)
        [ "$cur" = "$app" ] || printf '%s\t%s\n' "$token" "${cur:-<unset>}" >> "$drift"
    done < <(entries)
    grep -c '^' "$drift"
}

n=$(collect_drift)
[ "$n" -eq 0 ] && exit 0

awk -F'\t' -v app="$APP" '{ printf "vscode-defaults: %-18s %s -> %s\n", $1, $2, app }' "$drift" >&2
echo "vscode-defaults: setting $n file type(s) to VS Code"

# Only the drifted types are written: a blanket `duti $SETTINGS` would also
# re-set types that are already correct and fail on those macOS only knows as
# dynamic UTIs, which cannot be assigned a handler.
while IFS="$(printf '\t')" read -r token _owner; do
    duti -s "$APP" "$token" all >/dev/null 2>&1
done < "$drift"

# LaunchServices refreshes asynchronously, so confirm with a couple of retries
# instead of reporting the not-yet-visible state.
left=$(collect_drift)
attempt=0
while [ "$left" -ne 0 ] && [ "$attempt" -lt 3 ]; do
    sleep 1
    attempt=$((attempt + 1))
    left=$(collect_drift)
done

if [ "$left" -eq 0 ]; then
    echo "vscode-defaults: done"
else
    awk -F'\t' -v app="$APP" '{ printf "vscode-defaults: %-18s still %s\n", $1, $2 }' "$drift" >&2
    echo "vscode-defaults: $left type(s) could not be set; macOS has no settable handler for them." >&2
fi

exit 0
