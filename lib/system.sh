#!/usr/bin/env bash

os_pretty() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    echo "${PRETTY_NAME:-unknown}"
  else
    echo "unknown"
  fi
}

print_system() {
  section "System"
  kv "Hostname" "$(hostname 2>/dev/null || echo unknown)"
  kv "OS" "$(os_pretty)"
  kv "Kernel" "$(uname -r 2>/dev/null || echo unknown)"
  kv "Architecture" "$(uname -m 2>/dev/null || echo unknown)"
}
