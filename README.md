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

## Scope

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
sudo ./install.sh
wwanctl inspect
```

The installer puts the launcher and libraries under `/usr/local/lib/wwan-diag-kit`
and links `/usr/local/bin/wwanctl` to the launcher.

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

## Development

Run `python3 tests/check.py` for installation and identifier-redaction checks using synthetic data.
