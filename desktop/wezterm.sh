#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

distro=$(lsb_release -si)
release=$(lsb_release -sr)

file=${TMPDIR:-/tmp}/wezterm.deb
url=https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly."${distro}${release}".deb

warn "Getting nightly build package from $url..."
wget -qO "$file" --show-progress --progress=bar:force "$url"
warn "Installing package..."
apt-get -y install "$file"
rm -f "$file"
