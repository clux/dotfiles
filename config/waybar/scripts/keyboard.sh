#!/bin/bash
set -euo pipefail

icon="\uf11c"
preferred="Colemak"

# NB: Either pick .main == true in .keyboards[], or hardcode:
#keyboard="fnatic-gear-fnatic-gear-ministreak-keyboard"
#keymap=$(hyprctl devices -j | jq -r ".keyboards[] | select(.name == \"$keyboard\") | .active_keymap")

keymap=$(hyprctl devices -j | jq -r ".keyboards[] | select(.main == true) | .active_keymap")
keyboard=$(hyprctl devices -j | jq -r ".keyboards[] | select(.main == true) | .name")

# 1. pick parenthesised value (if exists) to disambiguate language
# 2. remove punctuation, and pick first word (usually first word is a sufficient identifier)
text=$(echo "$keymap" | awk -F'[()]' '{print $2}' | tr -d '[:punct:]' | awk '{print $1}')
alt="$text on $keyboard"

# CSS highlight when using preferred keymap
if [ "$text" = "$preferred" ]; then
  class="active"
else
  class="alert"
fi

# NB: Currently not passing on keymap name (CSS classes sufficient for 2 layouts)
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
	"$icon" "$alt" "$alt" "$class"
