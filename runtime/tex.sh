#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

# Install basic TeX environment
apt-get -y install --no-install-recommends \
	context                            \
	context-modules                    \
	lmodern                            \
	pandoc                             \
	texlive-extra-utils                \
	texlive-fonts-recommended          \
	texlive-lang-european              \
	texlive-latex-extra                \
	texlive-xetex                      \
	#
