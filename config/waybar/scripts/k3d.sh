#!/bin/bash
set -euo pipefail

# Module that displays k3d tooltip on a k3s svg with cluster info
active="$(k3d cluster list -ojson | jq '.[] | select(.serversRunning == 1) | .name' -rj)"
inactive="$(k3d cluster list -ojson | jq '.[] | select(.serversRunning == 0) | .name' -rj)"

if [ -n "$active" ]; then
  class="active"
  #pods="$(kubectl --context="${active}" get pods --no-headers | choose "0:2" | column -t)"
  if [ -n "$inactive" ]; then
    alt="active: ${active}, inactive: ${inactive}"
  else
    alt="active: ${active}"
  fi
  text=" "
elif [ -n "${inactive}" ]; then
  alt="inactive: ${inactive}"
  class="inactive"
  text="" # hide when inactive - can't toggle on anyway so have it as an indicator only
else
  alt=""
  class="disused"
  text="" # always hide when no clusters foundy
fi

# NB: Currently not passing on keymap name (CSS classes sufficient for 2 layouts)
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
	"$text" "$alt" "$alt" "$class"
