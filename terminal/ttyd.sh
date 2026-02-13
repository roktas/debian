#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

repo=tsl0922/ttyd
file=ttyd

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("x86_64")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file="${TMPDIR:-/tmp}"/"$file"
	dest=/usr/local/bin

	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"

	cry "Installing package..."
	chmod +x "$file" && mv "$file" "$dest"
else
	die "Installation failed"
fi
