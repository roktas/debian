#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

wget -qO- https://packages.microsoft.com/keys/microsoft.asc |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg

cat >/etc/apt/sources.list.d/vscode.list <<-EOF
	deb https://packages.microsoft.com/repos/code stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	code                                                    \
        #
