#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	imagemagick                        \
	optipng                            \
	#

flatpak install --system flathub org.inkscape.Inkscape
flatpak install --system flathub org.gimp.GIMP
