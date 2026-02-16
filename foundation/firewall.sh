#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

firewall_allow_always=${firewall_allow_always:-"ssh http https"}
firewall_allow_services=${firewall_allow_services:-}

apt-get -y install --no-install-recommends \
	ufw                                \
	#

# Workaround for IPV6 problem in LXC containers
# https://askubuntu.com/questions/664668/ufw-not-working-in-an-lxc-container/664669
if [[ $(systemd-detect-virt 2>/dev/null || true) =~ lxc ]]; then
	sed -i 's/IPV6=yes/IPV6=no/' /etc/default/ufw
fi

for service in $firewall_allow_always $firewall_allow_services; do
	ufw allow "$service"
done

if [[ -n ${firewall_enable:-} ]]; then
	ufw enable
else
	systemctl disable ufw
fi
