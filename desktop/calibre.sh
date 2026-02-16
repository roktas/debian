#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

command=${1:-}

case $command in
update)
	warn "Skipping calibre installer on update."
	exit 0
	;;
esac

wget -qO- https://download.calibre-ebook.com/linux-installer.sh | bash -s
