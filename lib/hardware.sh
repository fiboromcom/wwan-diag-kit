#!/usr/bin/env bash

print_hardware() {
  section "USB WWAN-ish devices"

  if have lsusb; then
    lsusb 2>/dev/null \
      | grep -Ei 'fibocom|quectel|sierra|ericsson|qualcomm|gobi|huawei|zte|novatel|telit|wwan|mobile|broadband|modem|2cb7|1199|05c6|0bdb|12d1|19d2|1bc7' \
      || echo "No obvious WWAN USB devices found by simple filter."
  else
    echo "lsusb not installed"
  fi

  section "PCI network-ish devices"

  if have lspci; then
    lspci -nn 2>/dev/null \
      | grep -Ei 'network|wireless|wwan|cellular|modem|communication' \
      || echo "No obvious PCI network/modem devices found by simple filter."
  else
    echo "lspci not installed"
  fi
}

print_final_summary() {
  section "Summary"

  local modem_count
  local gsm_count

  modem_count="$(mm_modem_count)"
  gsm_count="$(nm_gsm_device_count)"

  kv "Modems detected" "${modem_count}"
  kv "NM GSM devices" "${gsm_count}"

  if [[ "${modem_count}" -gt 0 ]]; then
    kv "Result" "WWAN hardware detected by ModemManager"
  elif [[ "${gsm_count}" -gt 0 ]]; then
    kv "Result" "GSM device visible to NetworkManager, but no ModemManager modem parsed"
  else
    kv "Result" "No active WWAN modem detected"
  fi
}
