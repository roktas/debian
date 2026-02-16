#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive
command=${1:-}

case $command in
update)
	warn "Skipping crystal installer on update."
	exit 0
	;;
esac

wget -qO- https://crystal-lang.org/install.sh | bash -s -- --channel=nightly

apt-get -y install --no-install-recommends \
        libgmp-dev                         \
        libssl-dev                         \
        libxml2-dev                        \
        libyaml-dev                        \
        libz-dev                           \
        #
