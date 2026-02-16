#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

apt-get -y install --no-install-recommends \
	gcc                                \
	git                                \
	libglib2.0-dev                     \
        libsecret-1-0                      \
	libsecret-1-dev                    \
	libsecret-tools                    \
	make                               \
	tig                                \
	#

warn "Building Git Credential Helper..."

cd /usr/share/doc/git/contrib/credential/libsecret && make
git config --system credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

warn "Installing Github CLI..."

wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/gh.gpg
cat >/etc/apt/sources.list.d/gh.list <<-EOF
	deb https://cli.github.com/packages stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	gh                                                      \

warn "Installing lazygit..."

repo=jesseduffield/lazygit
file=${TMPDIR:-/tmp}/lazygit.tar.gz
prog=lazygit

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("linux_x86_64.tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	warn "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	warn "Installing package..."
	tar -C /usr/local/bin -zxvf "$file" "$prog" && rm -f "$file"
else
	abort "Installation failed"
fi

warn "Installing git-cc..."

repo=SKalt/git-cc
file=${TMPDIR:-/tmp}/git-cc.deb

if url=$(
	warn "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("_linux_amd64.deb")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	warn "Getting latest package $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	warn "Installing package..."
	apt-get -y install "$file" && rm -f "$file"
else
	abort "Installation failed"
fi
