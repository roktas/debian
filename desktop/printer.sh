#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install         \
	cups               \
	cups-bsd           \
	cups-client        \
	foomatic-db-engine \
	hp-ppd             \
	hplip              \
	openprinting-ppds  \
	printer-driver-all \
	#
