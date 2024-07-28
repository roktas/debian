#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

case $(. /etc/os-release && echo "$VERSION_CODENAME") in
bullseye|oldstable) source=focal  ;;
stable|bookworm)    source=lunar  ;;
trixie|sid)         source=mantic ;;
esac

wget -qO- 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9dbb0be9366964f134855e2255f96fcf8231b6dd' |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/neovim.gpg
cat >/etc/apt/sources.list.d/neovim.list <<-EOF
	deb https://ppa.launchpadcontent.net/neovim-ppa/unstable/ubuntu $source main 
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	neovim                                                  \
        #

nvim=$(command -v nvim)
update-alternatives --install /usr/bin/editor editor "$nvim" 60
update-alternatives --set editor "$nvim"
