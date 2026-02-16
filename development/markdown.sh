#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

warn "Installing Markdown Language Server..."

repo=artempyanykh/marksman

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("-linux-x64")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file="${TMPDIR:-/tmp}"/marksman
	dest=/usr/local/bin

	warn "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"

	warn "Installing package..."
	chmod +x "$file" && mv "$file" "$dest"
else
	abort "Installation failed"
fi
