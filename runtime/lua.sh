#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

warn "Installing Lua..."

apt-get -y install --no-install-recommends \
  lua5.4                             \
  #
