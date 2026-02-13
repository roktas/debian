#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

# Determine latest Ruby version first.
repo=ruby/ruby
json=$(
	cry "Getting $repo latest information..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest"
)
[[ -n $json ]] || die "No JSON data found for the latest release."

latest_version=$(jq -r '.tag_name // empty' <<<"$json")
latest_version=${latest_version#v}
[[ -n $latest_version ]] || die "No version information found."

installed_version=
if command -v ruby >/dev/null 2>&1; then
	installed_version=$(ruby -e 'print RUBY_VERSION' 2>/dev/null || true)
fi

if [[ -n $installed_version ]] && [[ $installed_version == "$latest_version" ]]; then
	cry "Ruby $installed_version is already up to date."
	exit 0
fi

# Install ruby-install.

repo=postmodern/ruby-install

if url=$(
	cry "Getting $repo latest package URL..."
	wget -qO- "https://api.github.com/repos/$repo/releases/latest" |
	jq -r '.assets[] | select(.name | test(".tar.gz")) | .browser_download_url' |
	grep -v musl |
	head -n 1
) && [[ -n $url ]]; then
	file=${TMPDIR:-/tmp}/ruby-install.tar.gz
	dir=${TMPDIR:-/tmp}/ruby-install

	cry "Getting latest package from $url..."
	wget -qO "$file" --show-progress --progress=bar:force "$url"
	cry "Installing package..."
	rm -rf "$dir" && mkdir -p "$dir"
	tar -C "$dir" -zxvf "$file" --strip-components=1 && rm -f "$file"
	make -C "$dir" install && rm -rf "$dir"
else
	die "Installation failed."
fi

# Install the latest ruby.

root=/opt/ruby

cry "Installing Ruby $latest_version..."
ruby-install --jobs 4 --cleanup --no-reinstall --update --install-dir /opt/ruby/"$latest_version" ruby "$latest_version"

dest="$root"/"$latest_version"

# Create symlinks in a directory in the path to avoid dealing with PATH.
cry "Creating symlinks in PATH..."
for prog in "$dest"/bin/*; do
	ln -sf -t /usr/local/bin "$prog"
done

# For system-wide installations, programs must be in a directory in the PATH.
cry "Setup system-wide Gem..."
mkdir -p "$dest"/etc && cat >"$dest"/etc/gemrc <<-GEMRC
	install: --bindir /usr/local/bin --no-document
	update: --bindir /usr/local/bin --no-document
GEMRC

# For user installations, programs must be in a directory in the PATH.
cry "Setup user-wide Gem..."
sudo -u '#1000' bash -s <<-EOF
	mkdir -p ~/.config/gem
	cat >~/.config/gem/gemrc <<-GEMRC
		install: --user-install --bindir ~/.local/bin --no-document
		update: --user-install --bindir ~/.local/bin --no-document
	GEMRC
EOF

gem update --system && gem update && gem install \
	bundler                                  \
	nokogiri                                 \
	rake                                     \
	#
gem cleanup
