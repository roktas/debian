#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive
command=${1:-}

VIRTUALBOX_VERSION=7.2

case $(systemd-detect-virt) in
none)
	codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

	wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc |
		gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/virtualbox.gpg
	cat >/etc/apt/sources.list.d/virtualbox.list <<-EOF
		deb https://download.virtualbox.org/virtualbox/debian $codename contrib
	EOF

	apt-get -y update && apt-get -y install --no-install-recommends \
		linux-headers-"$(uname -r)"                             \
		virtualbox-"$VIRTUALBOX_VERSION"                        \
		#

	if command -v vboxmanage &>/dev/null; then
		warn "Installing Virtualbox extension pack..."

		version=$(vboxmanage --version); version=${version%r*}
		extpack=Oracle_VM_VirtualBox_Extension_Pack-"$version".vbox-extpack
		url=https://download.virtualbox.org/virtualbox/"$version"/"$extpack"
		file=${TMPDIR:-/tmp}/"$extpack"

		wget -qO "$file" --show-progress --progress=bar:force "$url"
		yes | vboxmanage extpack install --replace "$file" && rm -f "$file"
	fi || true

	adduser "$(sudo -u '#1000' sh -c 'echo $USER')" vboxusers

	case $command in
	install)
		sudo -u '#1000' bash -s <<-EOF
			rm -rf ~/"Virtualbox VMs" && vboxmanage setproperty machinefolder ~/Virtualbox
		EOF
		;;
	esac
	;;
oracle)
	apt-get -y update && apt-get -y install --no-install-recommends \
		linux-headers-"$(uname -r)"                             \
		#

	if mount /dev/cdrom /media; then
		if [[ -f /media/VBoxLinuxAdditions.run ]]; then
			warn "Installing/Updating Virtualbox Guest Additions..."

			sh /media/VBoxLinuxAdditions.run --nox11 || true
			umount /media || true
		else
			warn "No Guest Additions found in cdrom"
		fi
	else
		warn "Couldn't mount cdrom"
	fi
	;;
esac
