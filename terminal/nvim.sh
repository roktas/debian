#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

url=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
file="${TMPDIR:-/tmp}"/nvim.tar.gz
pack="nvim-linux-x86_64"
dest="/usr/local"

wget -O "$file" "$url"

warn "Installing nvim to $dest..."
tar -xf "$file"
install "$pack"/bin/nvim "$dest"/bin/nvim
cp -R "$pack"/lib "$dest"/
cp -R "$pack"/share "$dest"/
rm -rf "$pack" "$file"

warn "Setting up alternatives..."
nvim=$(command -v nvim)
update-alternatives --install /usr/bin/editor editor "$nvim" 60
update-alternatives --set editor "$nvim"
