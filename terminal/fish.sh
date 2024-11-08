#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

distro=$(lsb_release -si)
release=$(lsb_release -sr)
repo=${distro}_${release}

wget -qO- https://download.opensuse.org/repositories/shells:fish:release:3/"$repo"/Release.key |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/fish.gpg
cat >/etc/apt/sources.list.d/fish.list <<-EOF
	deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/$repo/ /
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	fish                                                    \
        #

chsh -s "$(command -v fish)" "$(sudo -u '#1000' sh -c 'echo $USER')"
