#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	pylint                             \
	python3-venv                       \
	#

cry "Installing a Python Language Server..."

repo=astral-sh/ruff
file=${TMPDIR:-/tmp}/ruff.tar.gz
prog=ruff

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("x86_64-unknown-linux-gnu.tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	cry "Installing package..."
	tar -C /usr/local/bin -zxvf "$file" --strip-components=1 --wildcards "*/$prog" && rm -f "$file"
else
	die "Installation failed"
fi
