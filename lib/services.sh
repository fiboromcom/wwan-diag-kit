#!/usr/bin/env bash

service_state() {
  local svc="$1"

  if have systemctl; then
    systemctl is-active "${svc}" 2>/dev/null || echo "unknown"
  else
    echo "systemctl unavailable"
  fi
}

service_enabled() {
  local svc="$1"

  if have systemctl; then
    systemctl is-enabled "${svc}" 2>/dev/null || echo "unknown"
  else
    echo "systemctl unavailable"
  fi
}

print_services() {
  section "Services"
  kv "NetworkManager" "$(service_state NetworkManager.service)"
  kv "NetworkManager enabled" "$(service_enabled NetworkManager.service)"
  kv "ModemManager" "$(service_state ModemManager.service)"
  kv "ModemManager enabled" "$(service_enabled ModemManager.service)"

  if have nmcli; then
    kv "NetworkManager version" "$(nmcli --version 2>/dev/null | head -n1)"
  else
    kv "NetworkManager version" "nmcli not installed"
  fi

  if have mmcli; then
    kv "ModemManager version" "$(mmcli --version 2>/dev/null | head -n1)"
  else
    kv "ModemManager version" "mmcli not installed"
  fi
}

print_rfkill() {
  section "RFKill"

  if have rfkill; then
    rfkill list 2>&1 || true
  else
    echo "rfkill not installed"
  fi
}
