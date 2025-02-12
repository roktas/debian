#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

user=$(sudo -u '#1000' sh -c 'echo $USER')

if [[ -n $user ]] && [[ $user != vagrant ]]; then
	file=/etc/sudoers.d/$user

	install -d /etc/sudoers.d && cat >"$file" <<-EOF
		$user ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/apt-get, /usr/bin/dpkg, /usr/sbin/poweroff, /usr/sbin/reboot
	EOF

	chmod 0440 "$file"
fi
