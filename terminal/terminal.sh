#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	rclone                             \
	qalc                               \
	units                              \
	#

mkdir -p /etc/profile.d && cat >/etc/profile.d/ssh_environment.sh <<'EOF'
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	for d in /etc/environment.d "${XDG_CONFIG_HOME:-$HOME/.config}"/environment.d; do
		if [ -d "$d" ]; then
			for c in "$d"/*.conf; do
				. "$c"
			done
		fi
	done

	unset d c
fi
EOF

mkdir -p /etc/fish/conf.d && cat >/etc/fish/conf.d/ssh_environment.fish <<'EOF'
if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"
	set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME "$HOME"/.config

	for d in /etc/environment.d "$XDG_CONFIG_HOME"/environment.d
		test -d "$d"; or continue

		for c in "$d"/*.conf
			test -r "$c"; or continue

			# Adapted from MIT licensed code from https://github.com/oh-my-fish/plugin-foreign-env
			# Copyright (c) 2015 Derek Willian S

			bash -c "set -a && . '$c' && env -0 >&31" 31>| while read -l -z var
				set -l kv (string split -m 1 = $var); or continue
				contains $kv[1] _ SHLVL PWD; and continue
				string match -rq '^BASH_.*%%$' $kv[1]; and continue

				if not set -q $kv[1]; or test "$$kv[1]" != $kv[2]; or not set -qx $kv[1]
					set -gx $kv
				end
			end
		end
	end
end
EOF
