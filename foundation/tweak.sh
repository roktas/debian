#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

tweak_keep_motd=${tweak_keep_motd:-}
tweak_kernel_logs=${tweak_kernel_logs:-'3 4 1 4'}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

# Tweak user
adduser "$(sudo -u '#1000' sh -c 'echo $USER')" adm || true

# Tweak sshd
#   - Prevent DNS resolution (speed up logins)
#   - Keep long SSH connections running, especially for assets precompilation
#   - Accept pass_* environment variables
#   - Disable last login messages (optionally)
{
	cat <<-EOF
		UseDNS no
		AllowAgentForwarding yes
		ClientAliveInterval 60
		ClientAliveCountMax 60
		AcceptEnv LANG LC_* pass_*
	EOF
	[[ -n $tweak_keep_motd ]] || echo PrintLastLog no
} | fix /etc/ssh/sshd_config
! command -v systemctl 2>/dev/null || systemctl restart ssh

# Tweak sudo
#   - Keep SSH_* environment variables
echo 'Defaults env_keep += "SSH_*"' >/etc/sudoers.d/ssh
chmod 0440 /etc/sudoers.d/ssh

# Tweak motd
if [[ -z $tweak_keep_motd ]]; then
	for f in /etc/pam.d/login /etc/pam.d/sshd; do
		[[ -f $f ]] || continue
		sed -e '/session.*motd/ s/^#*/#/' -i "$f"
	done
	rm -f /etc/motd
fi

# Remove 5s grub timeout to speed up booting
if [[ -f /etc/default/grub ]]; then
	sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
	! command -v update-grub 2>/dev/null || update-grub
fi

# Setup kernel log levels
[[ -z $tweak_kernel_logs ]] || sysctl -w kernel.printk="$tweak_kernel_logs" ||
warn "sysctl exit code $? is suppressed"

# No speaker
[[ -d /etc/modprobe.d ]] && echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf
