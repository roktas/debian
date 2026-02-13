#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

url=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
file="${TMPDIR:-/tmp}"/nvim.tar.gz
pack="nvim-linux-x86_64"
dest="/usr/local"

wget -O "$file" "$url"

cry "Installing nvim to $dest..."
tar -xf "$file"
install "$pack"/bin/nvim "$dest"/bin/nvim
cp -R "$pack"/lib "$dest"/
cp -R "$pack"/share "$dest"/
rm -rf "$pack" "$file"

cry "Setting up alternatives..."
nvim=$(command -v nvim)
update-alternatives --install /usr/bin/editor editor "$nvim" 60
update-alternatives --set editor "$nvim"
