# Architecture

`wwan-diag-kit` starts as a diagnostics-only project.

## Principles

1. Observe first.
2. Change nothing.
3. Prefer readable summaries.
4. Preserve raw evidence in bundles.
5. Handle missing tools and missing modems gracefully.
6. Keep repair/bootstrap logic out of v0.1.

## Command surface

- `wwanctl inspect`
- `wwanctl bundle`
- `wwanctl version`

## Layout

```text
bin/
  wwanctl

lib/
  common.sh
  system.sh
  services.sh
  networkmanager.sh
  modemmanager.sh
  hardware.sh
  bundle.sh
```

## Future ideas

- JSON output
- fixture replay
- issue-template integration
- hardware profile classification
- separate bootstrap/repair tools built on top of diagnostics
