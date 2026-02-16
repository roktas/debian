#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	pylint                             \
	#

warn "Installing Python Package/Project Manager..."
curl -LsSf https://astral.sh/uv/install.sh | sudo -u '#1000' bash -s

warn "Installing a Python Language Server..."

repo=astral-sh/ruff
file=${TMPDIR:-/tmp}/ruff.tar.gz
prog=ruff

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	warn "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	warn "Installing package..."
	tar -C /usr/local/bin -zxvf "$file" --strip-components=1 --wildcards "*/$prog" && rm -f "$file"
else
	abort "Installation failed"
fi
