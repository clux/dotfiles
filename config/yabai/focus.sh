#!/bin/sh
set -e

# focus a yabai window from title

# NB: binaries for choose-gui and choose-rust clash on mac
# This requires installing choose-gui unlinked if you have both
# shellcheck disable=SC2086
choose="$(find ${HOMEBREW_CELLAR}/choose-gui/*/bin/choose)"

# snapshot id and names of current active non-sticky windows as json
windows="$(yabai -m query --windows | jq '.[] | select(.["is-sticky"] == false) | [.app, .title, .id]')"

# present just the human readable components to a sized choice gui in the $windows order and return its index
height="$(echo "$windows" | jq length | wc -l)" # number of windows
width="$(echo "$windows" | jq '.[1] | length' | sort -h | tail -n 1)" # longest title

# shellcheck disable=SC2086
index="$(echo "$windows" | jq '[.[0], .[1]] | join(" :: ")' -r | ${choose} -b ff79c6 -w ${width} -n ${height} -i)"

# reverse map the index to the window .id
id="$(echo "$windows" | jq '.[2]' | jq --slurp ".[$index]")"

# focus it
yabai -m window "${id}" --focus
