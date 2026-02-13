#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

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
