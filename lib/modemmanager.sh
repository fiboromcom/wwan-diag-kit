#!/usr/bin/env bash

modem_ids() {
  if ! have mmcli; then
    return 0
  fi

  mmcli -L 2>/dev/null \
    | awk -F/ '/Modem\// {print $NF}' \
    | awk '{print $1}' \
    | sed '/^$/d'
}

mm_modem_count() {
  modem_ids | wc -l | tr -d ' '
}

print_modemmanager() {
  section "ModemManager modems"

  if ! have mmcli; then
    echo "mmcli not installed"
    return
  fi

  local ids
  ids="$(modem_ids)"

  if [[ -z "${ids}" ]]; then
    echo "No modems detected by ModemManager."
    return
  fi

  local id
  for id in ${ids}; do
    echo
    echo "Modem ${id}"
    echo "~~~~~~~~"
    mmcli -m "${id}" 2>&1 | redact_stream | sed -n '
      /manufacturer:/Ip
      /model:/Ip
      /revision:/Ip
      /device:/Ip
      /drivers:/Ip
      /plugin:/Ip
      /primary port:/Ip
      /ports:/Ip
      /equipment id:/Ip
      /state:/Ip
      /power state:/Ip
      /access tech:/Ip
      /signal quality:/Ip
      /operator name:/Ip
      /registration:/Ip
      /packet service state:/Ip
      /bearer paths:/Ip
      /sim path:/Ip
    ' || true
  done
}
