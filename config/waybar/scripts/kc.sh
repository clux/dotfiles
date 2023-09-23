#!/bin/bash
set -euo pipefail

icon="󱃾"
export KUBECONFIG
KUBECONFIG="$(fd . ~/.kube --max-depth 1 --type f | tr '\n' ':')"
context="$(kubectl config current-context)"
ns="$(kubectl config get-contexts | rg "\*" | choose 4)"
class="active"
alt="$context in ${ns}"
text="${icon}  ${context}"

# NB: Currently not passing on keymap name (CSS classes sufficient for 2 layouts)
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
	"$text" "$alt" "$alt" "$class"
