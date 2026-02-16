#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

codename=$(. /etc/os-release && echo "$VERSION_CODENAME")
distro=$(lsb_release -si); distro=${distro,,}

wget -qO- https://download.docker.com/linux/"$distro"/gpg |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/docker.gpg
cat >/etc/apt/sources.list.d/docker.list <<-EOF
	deb https://download.docker.com/linux/$distro $codename stable
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
        docker-ce                          \
        docker-ce-cli                      \
        containerd.io                      \
        docker-buildx-plugin               \
        docker-compose-plugin              \
        #

adduser "$(sudo -u '#1000' sh -c 'echo $USER')" docker || true
