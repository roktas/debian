#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

apt-get -y install --no-install-recommends \
	archivemount                       \
	fuse-zip                           \
	vifm                               \
	#
