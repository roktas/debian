#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

command=${1:-}

case $command in
update)
	cry "Skipping calibre installer on update."
	exit 0
	;;
esac

wget -qO- https://download.calibre-ebook.com/linux-installer.sh | bash -s
