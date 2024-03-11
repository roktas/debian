#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

wget -qO- https://crystal-lang.org/install.sh | bash -s -- --channel=nightly

apt-get -y install --no-install-recommends \
        libgmp-dev                         \
        libssl-dev                         \
        libxml2-dev                        \
        libyaml-dev                        \
        libz-dev                           \
        #
