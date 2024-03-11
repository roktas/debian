#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

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
	dnsutils                           \
	dosfstools                         \
	ed                                 \
	file                               \
	htop                               \
	iputils-tracepath                  \
	mc                                 \
	mlocate                            \
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
