#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

wget -qO- https://packages.microsoft.com/keys/microsoft.asc |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/microsoft.gpg

cat >/etc/apt/sources.list.d/vscode.list <<-EOF
	deb https://packages.microsoft.com/repos/code stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	code                                                    \
        #
