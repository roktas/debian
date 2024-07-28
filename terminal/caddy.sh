#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

wget -qO- 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/caddy.gpg
cat >/etc/apt/sources.list.d/caddy.list <<-EOF
	deb https://dl.cloudsmith.io/public/caddy/xcaddy/deb/debian any-version main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	xcaddy                                                  \
        #
