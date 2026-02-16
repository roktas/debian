#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

# Install all important and standard packages
# - avoid gnupg-agent pulling pinentry-gtk2 on jessie
# - avoid reportbug-gtk having bogus standard priority
apt-get -y install --no-install-recommends dctrl-tools
grep-aptavail --no-field-names --show-field Package    \
	--field Priority --regex 'important\|standard' \
	--and --not                                    \
	--field Package --regex 'reportbug-gtk' |
	xargs apt-get -y install --no-install-recommends pinentry-curses
apt-get purge -y dctrl-tools

apt-get -y install --no-install-recommends \
	bsdmainutils                       \
	dnsutils                           \
	dosfstools                         \
	ed                                 \
	file                               \
	htop                               \
	iputils-tracepath                  \
	lshw                               \
	mc                                 \
	plocate                            \
	moreutils                          \
	ncdu                               \
	net-tools                          \
	procps                             \
	rclone                             \
	recode                             \
	socat                              \
	syslinux                           \
	telnet                             \
	tree                               \
	unzip                              \
	zip                                \
	#
