# wwan-diag-kit

`wwan-diag-kit` is a read-only Linux WWAN diagnostics toolkit.

It collects and summarises WWAN state from:

- ModemManager
- NetworkManager
- rfkill
- USB and PCI enumeration
- systemd service state
- routing and DNS state
- relevant journal logs

## v0.1.0 scope

This release observes only.

It does **not**:

- unlock radios
- reset modems
- restart services
- modify NetworkManager profiles
- alter APNs
- change power management
- attempt repair

## Usage

Run from the repo:

```bash
chmod +x bin/wwanctl
./bin/wwanctl inspect
./bin/wwanctl bundle
./bin/wwanctl version
```

Optionally install locally:

```bash
sudo install -m 0755 bin/wwanctl /usr/local/bin/wwanctl
wwanctl inspect
```

## Commands

### `wwanctl inspect`

Prints a human-readable diagnostic summary.

### `wwanctl bundle`

Creates a timestamped diagnostic bundle:

```text
wwan-diag-bundle-<host>-<timestamp>.tar.gz
```

### `wwanctl version`

Prints the tool version.

## Privacy

The bundle applies basic redaction for common modem identifiers such as IMEI,
IMSI and ICCID.

This is a best-effort first pass, not a guarantee. Always review bundles before
sharing publicly.
