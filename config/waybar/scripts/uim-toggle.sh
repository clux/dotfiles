#!/usr/bin/env bash

if [ -z "$1" ]; then
    pattern="${HOME}/.uim.d/fep/getmode-*"
    # shellcheck disable=SC2206
    files=( $pattern )
    newstatus=$(( ($(cat "${files[0]}") + 1) % 3))
else
    newstatus=$1
fi

echo "${newstatus}" | tee "${HOME}"/.uim.d/fep/setmode-*
