#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	adequate                           \
	apt-utils                          \
	autopkgtest                        \
	build-essential                    \
	cowbuilder                         \
	debconf-i18n                       \
	debconf-utils                      \
	dput-ng                            \
	git-buildpackage                   \
	piuparts                           \
	#

apt-get -y install \ # with recommends
	devscripts \
	#
