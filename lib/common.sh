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
  # Handle both human-readable labels and mmcli --output-keyvalue keys.
  # Preserve the label but replace quoted or unquoted identifier values.
  sed -E \
    -e "s/((imei|imsi|iccid|equipment[ ._-]*(id|identifier)|sim[ ._-]*(properties[ ._-]*)?identifier)[[:space:]]*[:=][[:space:]]*)['\"]?[0-9]{10,25}['\"]?/\\1<redacted>/gI"
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
