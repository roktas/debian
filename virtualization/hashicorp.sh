#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

hashicorp_packages=${hashicorp_packages:-vagrant}

export DEBIAN_FRONTEND=noninteractive

codename=$(. /etc/os-release && echo "$VERSION_CODENAME")

wget -qO- https://apt.releases.hashicorp.com/gpg |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/hashicorp.gpg
cat >/etc/apt/sources.list.d/hashicorp.list <<-EOF
	deb https://apt.releases.hashicorp.com $codename main
EOF

# shellcheck disable=2086
apt-get -y update && apt-get -y install --no-install-recommends $hashicorp_packages
