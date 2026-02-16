#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

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
