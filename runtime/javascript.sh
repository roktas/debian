#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

cry "Installing Nodejs..."

repo=nodejs/node

version=$(
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name'
)
version=${version%%.*}
version=${version/v/}

wget -qO- https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/node.gpg
cat >/etc/apt/sources.list.d/node.list <<-EOF
	deb https://deb.nodesource.com/node_${version}.x nodistro main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	nodejs                                                  \
        #

cry "Updating and setting up Npm..."

npm config set prefix /usr/local
npm install -g npm@latest

cry "Installing Yarn..."

wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg |
	gpg --dearmor --batch --yes -o /etc/apt/trusted.gpg.d/yarn.gpg

cat >/etc/apt/sources.list.d/yarn.list <<-EOF
	deb https://dl.yarnpkg.com/debian/ stable main
EOF

apt-get -y update && apt-get -y install --no-install-recommends \
	yarn                                                    \
        #

cry "Installing Bun..."

repo=oven-sh/bun

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test("-linux-x64.zip")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file="${TMPDIR:-/tmp}"/bun.zip
	dest=/usr/local/bin

	apt-get -y update && apt-get -y install --no-install-recommends \
		libarchive-tools # for bsdtar

	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"

	cry "Installing package..."
	bsdtar xvf "$file" --strip-component=1 -C "$dest" && rm -f "$file"
else
	die "Installation failed"
fi
