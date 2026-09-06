#!/usr/bin/env bash
set -euo pipefail
# PREFIX supports an unprivileged local install; DESTDIR supports packaging.
prefix=${PREFIX:-/usr/local}
stage=${DESTDIR:-}
[[ $prefix == /* ]] || { echo 'PREFIX must be an absolute path' >&2; exit 2; }
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
target="$stage$prefix/lib/wwan-diag-kit"
install -d "$target/bin" "$target/lib" "$stage$prefix/bin"
install -m 0755 "$source_dir/bin/wwanctl" "$target/bin/wwanctl"
install -m 0644 "$source_dir"/lib/*.sh "$target/lib/"
ln -sfn ../lib/wwan-diag-kit/bin/wwanctl "$stage$prefix/bin/wwanctl"
printf 'Installed wwanctl under %s%s\n' "$stage" "$prefix"
