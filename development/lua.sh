#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

cry "Installing a Lua Language Server..."

repo=LuaLS/lua-language-server
root=/opt/luals

json=$(
	cry "Getting $repo latest information..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest"
)
[[ -n $json ]] || "No JSON data found for the latest release"

version=$(jq -r '.name' <<<"$json")
[[ -n $version ]] || die "No version information found"

url=$(
	echo "$json" |
	jq -r '.assets[] | select(.name | test("-linux-x64.tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
)
[[ -n $url ]] || die "URL for latest file couldn't detected"

file="${TMPDIR:-/tmp}"/lua-language-server.tar.gz
dest="$root"/"$version"
prog=lua-language-server

cry "Getting latest package from $url..."
wget -qO "$file" --show-progress --progress=bar:force "$url"

cry "Installing package..."
rm -rf "$dest" && mkdir -p "$dest"
tar -C "$dest" -zxvf "$file" && rm -f "$file"

cat >/usr/local/bin/"$prog" <<-EOF
	#!/bin/sh

	exec "$dest/bin/$prog" --logpath="\${XDG_STATE_HOME:-\$HOME/.local/state}/luals" --metapath="\${XDG_STATE_HOME:-\$HOME/.local/state}/luals" "\$@"
EOF
