#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --install-suggests \
        lxd                           \
        #

adduser "$(sudo -u '#1000' sh -c 'echo $USER')" lxd || true
