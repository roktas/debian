#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

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

cry "Building Git Credential Helper..."

cd /usr/share/doc/git/contrib/credential/libsecret && make
git config --system credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

cry "Installing Github CLI..."

wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/gh.gpg
cat >/etc/apt/sources.list.d/gh.list <<-EOF
	deb https://cli.github.com/packages stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	gh                                                      \

cry "Installing git-cc..."

repo=SKalt/git-cc
file=${TMPDIR:-/tmp}/git-cc.deb

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("_linux_amd64.deb")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	cry "Getting latest package $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	cry "Installing package..."
	apt-get -y install "$file" && rm -f "$file"
else
	die "Installation failed"
fi
