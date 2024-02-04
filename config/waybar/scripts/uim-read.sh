#!/usr/bin/env bash
set -euo pipefail

pattern="${HOME}/.uim.d/fep/getmode-*"
# shellcheck disable=SC2206
files=( $pattern )
status=$(( ($(cat "${files[0]}")) % 3))

case "$status" in
  1)
    icon="あ"
    alt="hiragana"
    class="alert"
    ;;
  2)
    icon="ア"
    alt="katakana"
    class="alert"
    ;;
  *)
    icon="ー"
    alt="uim-fep off"
    class="active"
    ;;
esac
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}' \
  "$icon" "$alt" "$alt" "$class"
