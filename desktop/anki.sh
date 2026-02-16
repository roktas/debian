#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	libxcb-cursor0                     \
	#

repo=ankitects/anki

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("-linux-qt6.tar.zst")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file="${TMPDIR:-/tmp}"/anki.zst
	dest="${TMPDIR:-/tmp}"/anki

	warn "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"

	warn "Installing package..."
	rm -rf "$dest" && mkdir -p "$dest"
	tar -C "$dest" --use-compress-program=unzstd -xvf "$file" --strip-components=1
	cd "$dest" && ./install.sh && rm -rf "$dest"
else
	abort "Installation failed"
fi
