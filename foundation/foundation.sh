#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

case $(lsb_release -si) in
Debian|debian)
	codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

	# Add backports repository
	grep -wq "$codename-backports" /etc/apt/sources.list || cat >/etc/apt/sources.list.d/backports.list <<-EOF
		deb http://deb.debian.org/debian $codename-backports main contrib non-free
	EOF
	# Prefer backports
	cat >/etc/apt/preferences.d/backports <<-EOF
		Package: *
		Pin: release o=$codename-backports
		Pin-Priority: 1000
	EOF
	;;
esac

# Disable downloading translations
cat >/etc/apt/apt.conf.d/99notranslations <<-EOF
	Acquire::Languages "none";
EOF

# Do not install recommended or suggested packages by default
cat >/etc/apt/apt.conf.d/01norecommends <<-EOF
	APT::Install-Recommends "false";
	APT::Install-Suggests "false";
EOF

apt-get -y update && apt-get -y upgrade && apt-get -y install --no-install-recommends \
	bzip2                      \
	curl                       \
	git                        \
	gnupg                      \
	jq                         \
	libarchive-tools           \
	lsb-release                \
	make                       \
	rsync                      \
	software-properties-common \
	ssh                        \
	unzip                      \
	wget                       \
	xz-utils                   \
	zstd                       \
	#
