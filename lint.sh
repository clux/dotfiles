#!/usr/bin/env bash
find . -maxdepth 1 -type f -name ".*" \
      | grep -vE "iface|gitconfig|intrc|yml|temp" \
      | xargs shellcheck
