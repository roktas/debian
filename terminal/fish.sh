#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive
command=${1:-}

apt-get -y update && apt-get -y install --no-install-recommends \
	fish                                                    \
        #

case $command in
install)
	chsh -s "$(command -v fish)" "$(sudo -u '#1000' sh -c 'echo $USER')"
	;;
esac
