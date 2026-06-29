#!/usr/bin/env bash

nm_gsm_device_count() {
  if ! have nmcli; then
    echo "0"
    return
  fi

  nmcli -t -f DEVICE,TYPE device status 2>/dev/null \
    | awk -F: '$2=="gsm"{count++} END {print count+0}'
}

print_networkmanager() {
  section "NetworkManager devices"

  if ! have nmcli; then
    echo "nmcli not installed"
    return
  fi

  nmcli device status 2>&1 || true

  section "NetworkManager GSM connections"

  local gsm
  gsm="$(nmcli -t -f NAME,UUID,TYPE,DEVICE connection show 2>/dev/null \
    | awk -F: '$3=="gsm"{print}')"

  if [[ -z "${gsm}" ]]; then
    echo "No GSM connection profiles found."
    return
  fi

  echo "${gsm}" | while IFS=: read -r name uuid _type device; do
    kv "Name" "${name}"
    kv "UUID" "${uuid}"
    kv "Device" "${device:---}"
    echo
  done
}
