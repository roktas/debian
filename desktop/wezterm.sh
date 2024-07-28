#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

distro=$(lsb_release -si)
release=$(lsb_release -sr)

file=${TMPDIR:-/tmp}/wezterm.deb
url=https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly."${distro}${release}".deb

cry "Getting nightly build package from $url..."
wget -qO "$file" --show-progress --progress=bar:force "$url"
cry "Installing package..."
apt-get -y install "$file"
rm -f "$file"
