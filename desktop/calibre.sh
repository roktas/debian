#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

wget -qO- https://download.calibre-ebook.com/linux-installer.sh | bash -s
