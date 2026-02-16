#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	build-essential                    \
	libbsd-dev                         \
	libsecret-tools                    \
	libsqlite3-dev                     \
	libssl-dev                         \
	libxml2-dev                        \
	libxslt-dev                        \
	python3-dev                        \
	sqlite3                            \
	zlib1g-dev                         \
	#
