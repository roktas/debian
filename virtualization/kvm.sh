#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
        bridge-utils                       \
        libvirt-clients                    \
        libvirt-daemon                     \
        libvirt-daemon-system              \
        qemu-kvm                           \
        qemu-system                        \
        qemu-system-gui                    \
        qemu-utils                         \
        virt-manager                       \
        virtinst                           \
        #

adduser "$(sudo -u '#1000' sh -c 'echo $USER')" libvirt || true
adduser "$(sudo -u '#1000' sh -c 'echo $USER')" libvirt-qemu || true
adduser "$(sudo -u '#1000' sh -c 'echo $USER')" kvm || true
