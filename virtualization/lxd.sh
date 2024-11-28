#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --install-suggests \
        lxd                           \
        #

adduser "$(sudo -u '#1000' sh -c 'echo $USER')" lxd || true
