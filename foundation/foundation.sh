#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

if [[ ${1:-} == update ]]; then
	apt-get -y update
	apt-get -y upgrade

	exit 0
fi

codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

case $(lsb_release -si) in
Debian|debian)
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

# Install Griffo repositories
wget -qO- https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/griffo.gpg
cat >/etc/apt/sources.list.d/griffo.list <<-EOF
	deb https://debian.griffo.io/apt $codename main
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
	ssh                        \
	unzip                      \
	wget                       \
	xz-utils                   \
	zstd                       \
	#
