#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

timezone=${timezone:-'Europe/Istanbul'}

conffile=/etc/timezone
confscript=/var/lib/dpkg/info/tzdata.config

IFS=$'/' read -r area zone <<<"$timezone"

debconf-set-selections <<-EOF
	tzdata tzdata/Areas select $area
	tzdata tzdata/Zones/$area select $zone
EOF

echo "$timezone" >"$conffile"

# Bugs in tzdata script prevents reconfiguring timezone
cp -a -f "$confscript" "$confscript.bak"
cat >"$confscript" <<-EOF
	#!/bin/sh
	exit 0
EOF

dpkg-reconfigure -f noninteractive tzdata

# Remove workaround
mv -f "$confscript.bak" "$confscript"
