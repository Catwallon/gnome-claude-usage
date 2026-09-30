#!/usr/bin/env bash
set -euo pipefail

uuid="claude-usage@dinomalin"
ext_dir="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions/$uuid"
script="$HOME/.local/bin/claude-usage-statusline"
settings="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/claude-usage"

if ! gnome-extensions disable "$uuid" 2>/dev/null; then
  enabled="$(gsettings get org.gnome.shell enabled-extensions)"
  enabled="${enabled//", '$uuid'"/}"
  enabled="${enabled//"'$uuid', "/}"
  enabled="${enabled//"'$uuid'"/}"
  gsettings set org.gnome.shell enabled-extensions "$enabled"
fi

if [ -f "$settings" ] && [[ "$(jq -r '.statusLine.command // empty' "$settings")" == *claude-usage-statusline ]]; then
  tmp="$(mktemp)"
  jq 'del(.statusLine)' "$settings" >"$tmp"
  mv "$tmp" "$settings"
  echo "Removed the Claude Code status line from $settings"
fi

rm -rf "$ext_dir" "$cache_dir"
rm -f "$script"
echo "Uninstalled. Log out and back in to remove it from the top bar."
