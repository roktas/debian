#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

latest=$(
	warn "Getting latest Go version name..."
	wget -qO- "https://go.dev/VERSION?m=text" | head -n 1
)
[[ -n $latest ]] || abort "No version information found"
version=${latest#go}

file="${TMPDIR:-/tmp}"/go.tar.gz
dest=/opt/go/$version
conf=/etc/environment.d/go.conf

warn "Getting Go $version..."
wget -qO "$file" --show-progress --progress=bar:force https://go.dev/dl/"$latest".linux-amd64.tar.gz

warn "Installing package..."
rm -rf "$dest" && mkdir -p "$dest"
tar -C "$dest" -zxvf "$file" --strip-components=1 && rm -f "$file"

for prog in "$dest"/bin/*; do
	ln -sf -t /usr/local/bin "$prog"
done

mkdir -p "${conf%/*}" && cat >"$conf" <<-CONF
	GOPATH=/opt/go/$version
	GOBIN=/usr/local/bin
CONF
