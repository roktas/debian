#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

file=${TMPDIR:-/tmp}/dropbox.deb
url='https://www.dropbox.com/download?dl=packages/debian/dropbox_2023.09.06_amd64.deb'

cry "Getting latest package from $url..."
wget -qO "$file" --show-progress --progress=bar:force "$url"
cry "Installing package..."
apt-get -y install --no-install-recommends \
	python3-gpg                        \
	"$file"                            \
	#
rm -f "$file"
