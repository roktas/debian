#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

if [[ ${1:-} == update ]]; then
	! command -v flatpak 2>/dev/null || sudo -u '#1000' flatpak update

	exit 0
fi

apt-get -y install --no-install-recommends \
	alacritty                          \
	flameshot                          \
	flatpak                            \
	fonts-spleen                       \
	ghostty                            \
	regexxer                           \
	remmina                            \
	remmina-plugin-rdp                 \
	ulauncher                          \
	wl-clipboard                       \
	xournalpp                          \
	#

if ! apt-get install -y --no-install-recommends avahi-daemon; then
	case $(systemd-detect-virt 2>/dev/null || true) in
	lxc)
		# Workaround for https://github.com/lxc/lxd/issues/2948
		if [[ -f /etc/avahi/avahi-daemon.conf ]]; then
			sed -e '/^rlimit-nproc=/ s/^/#/' -i /etc/avahi/avahi-daemon.conf
			warn 'Workaround for LXC applied'
		fi
		systemctl restart avahi-daemon
		;;
	esac
fi

apt-get install -y --no-install-recommends \
	avahi-utils                        \
	libnss-mdns                        \
	#

flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --system flathub com.github.PintaProject.Pinta

