#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

export DEBIAN_FRONTEND=noninteractive

locale=${locale:-en_US.UTF-8}

if ! echo ':en_US.UTF-8:tr_TR.UTF-8:' | grep -Eq ":$locale:"; then
	die "Unsupported default locale: $locale"
fi

distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")

apt-get -y --no-install-recommends install locales

if [[ $distribution = debian ]]; then
	debconf-set-selections <<-EOF
		locales locales/locales_to_be_generated multiselect tr_TR.UTF-8 UTF-8, en_US.UTF-8 UTF-8
		locales locales/default_environment_locale select $locale
	EOF

	rm -f /etc/locale.gen
	dpkg-reconfigure -f noninteractive locales
elif [[ $distribution = ubuntu ]]; then
	locale-gen tr_TR.UTF-8 en_US.UTF-8
fi

update-locale LANG="$locale"
