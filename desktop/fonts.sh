#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	fonts-cascadia-code                \
	fonts-firacode                     \
	fonts-inconsolata                  \
	fonts-powerline                    \
	fonts-prociono                     \
	fonts-quicksand                    \
	#
