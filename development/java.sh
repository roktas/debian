#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

cry "Installing Java Development Environment..."

apt-get -y install --no-install-recommends \
	default-jdk                        \
	#
