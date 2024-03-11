#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	libxcb-cursor0                     \
	#

repo=ankitects/anki

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("-linux-qt6.tar.zst")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file="${TMPDIR:-/tmp}"/anki.zst
	dest="${TMPDIR:-/tmp}"/anki

	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"

	cry "Installing package..."
	rm -rf "$dest" && mkdir -p "$dest"
	tar -C "$dest" --use-compress-program=unzstd -xvf "$file" --strip-components=1
	cd "$dest" && ./install.sh && rm -rf "$dest"
else
	die "Installation failed"
fi
