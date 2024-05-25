#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	tmux                               \
	#

[[ $(systemd-detect-virt) == none ]] || chsh -s "$(command -v tmux)" "$(sudo -u '#1000' sh -c 'echo $USER')"
