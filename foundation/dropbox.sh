#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

file=${TMPDIR:-/tmp}/dropbox.deb
url='https://www.dropbox.com/download?dl=packages/debian/dropbox_2026.01.15_amd64.deb'

warn "Getting latest package from $url..."
wget -qO "$file" --show-progress --progress=bar:force "$url"
warn "Installing package..."
apt-get -y install --no-install-recommends \
	python3-gpg                        \
	"$file"                            \
	#
rm -f "$file"
