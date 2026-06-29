#!/usr/bin/env bash

have() {
  command -v "$1" >/dev/null 2>&1
}

section() {
  printf '\n%s\n' "$1"
  printf '%s\n' "$(printf -- '-%.0s' {1..60})"
}

kv() {
  printf '%-24s %s\n' "$1" "${2:-unknown}"
}

print_banner() {
  printf 'wwan-diag-kit %s\n' "${WWAN_DIAG_VERSION}"
  printf '%s\n' 'read-only Linux WWAN diagnostics'
}

redact_stream() {
  sed -E \
    -e 's/([Ii][Mm][Ee][Ii]|equipment id|equipment identifier)[[:space:]:=]+[0-9]{10,20}/\1: <redacted>/g' \
    -e 's/([Ii][Mm][Ss][Ii])[[:space:]:=]+[0-9]{10,20}/\1: <redacted>/g' \
    -e 's/([Ii][Cc][Cc][Ii][Dd]|sim identifier)[[:space:]:=]+[0-9]{10,25}/\1: <redacted>/g'
}

run_or_note() {
  local cmd="$1"
  shift

  if have "${cmd}"; then
    "${cmd}" "$@" 2>&1 || true
  else
    echo "Command not found: ${cmd}"
  fi
}
