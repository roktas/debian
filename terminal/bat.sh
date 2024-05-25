#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

repo=sharkdp/bat
file=${TMPDIR:-/tmp}/bat.deb

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("amd64.deb")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	cry "Installing package..."
	apt-get -y install "$file" && rm -f "$file"
else
	die "Installation failed"
fi
