#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

repo=junegunn/fzf
file=${TMPDIR:-/tmp}/fzf.tar.gz

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("-linux_amd64.tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	warn "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	warn "Installing package..."
	tar -C /usr/local/bin -zxvf "$file" && rm -f "$file"
else
	abort "Installation failed"
fi
