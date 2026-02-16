#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	autoconf                           \
	automake                           \
	bison                              \
	libbz2-dev                         \
	libcurl4-openssl-dev               \
	libdb-dev                          \
	libevent-dev                       \
	libffi-dev                         \
	libgdbm-dev                        \
	libgeoip-dev                       \
	libglib2.0-dev                     \
	libjpeg-dev                        \
	libkrb5-dev                        \
	liblzma-dev                        \
	libmagickcore-dev                  \
	libmagickwand-dev                  \
	libncurses5-dev                    \
	libncursesw5-dev                   \
	libpng16-16                        \
	libpng-dev                         \
	libpq-dev                          \
	libreadline-dev                    \
	libtool                            \
	libvips-dev                        \
	libwebp-dev                        \
	libxml2                            \
	libxslt1-dev                       \
	libyaml-dev                        \
	patch                              \
	#
