#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	alacritty                          \
	fonts-spleen                       \
	regexxer                           \
	remmina                            \
	remmina-plugin-rdp                 \
	wl-clipboard                       \
	xournalpp                          \
	#

if ! apt-get install -y --no-install-recommends avahi-daemon; then
	case $(systemd-detect-virt 2>/dev/null || true) in
	lxc)
		# Workaround for https://github.com/lxc/lxd/issues/2948
		if [[ -f /etc/avahi/avahi-daemon.conf ]]; then
			sed -e '/^rlimit-nproc=/ s/^/#/' -i /etc/avahi/avahi-daemon.conf
			cry 'Workaround for LXC applied'
		fi
		systemctl restart avahi-daemon
		;;
	esac
fi

apt-get install -y --no-install-recommends \
	avahi-utils                        \
	libnss-mdns                        \
	#
