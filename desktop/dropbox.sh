#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

url='https://www.dropbox.com/download?dl=packages/debian/dropbox_2023.09.06_amd64.deb'
file=${TMPDIR:-/tmp}/dropbox.deb

wget -qO "$file" --show-progress --progress=bar:force "$url" 
apt-get -y install --no-install-recommends \
	python3-gpg                        \
	"$file"                            \
	#
rm -f "$file"

cat <<-EOF
	Complete Dropbox setup later as normal user:

	    echo y | dropbox start -i && dropbox autostart y
EOF
