#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive


wget -qO- https://dl.google.com/linux/linux_signing_key.pub |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/google.gpg

cat >/etc/apt/sources.list.d/chrome.list <<-EOF
	deb http://dl.google.com/linux/chrome/deb/ stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	google-chrome-stable                                    \
        #

rm -f /etc/apt/sources.list.d/google-chrome.list
