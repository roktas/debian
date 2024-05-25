#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	build-essential                    \
	exiftool                           \
	file                               \
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
