#!/bin/bash


# If running in zellij on linux under X, save the window for refocus keybinds
if [ -n "${ZELLIJ_SESSION_NAME}" ] && [ ! -f /tmp/wraise ]; then
  xdotool getactivewindow > /tmp/wraise
  # F1 keybind in cinnamon hits toggle_terminal
  # Mac uses Hammerspoon to do the same thing
fi

# hotkey can bind to: /bin/zsh -c 'source x-term-toggle.sh && terminal_toggle'
# expects alacritty to have been started first
terminal_toggle() {
  local -r terminal_id="$(cat /tmp/wraise)"
  # Check if it is active (stored in hex on a root prop)
  local -r active_id="$((16#$(xprop -root _NET_ACTIVE_WINDOW | choose 4 | cut -d'x' -f2)))"
  if [ $active_id -eq $terminal_id ]; then
    xdotool windowminimize "${terminal_id}"
  else
    wmctrl -ia "${terminal_id}"
  fi
}
