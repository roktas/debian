#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry() { echo "$*" >&2;    }
die() { cry "$@"; exit 1; }

gem update --system && gem update && gem install                 \
	debug                                                    \
	minitest                                                 \
	minitest-focus                                           \
	minitest-reporters                                       \
	rubocop                                                  \
	rubocop-md                                               \
	rubocop-minitest                                         \
	rubocop-packaging                                        \
	rubocop-performance                                      \
	rubocop-rake                                             \
	rubocop-rails-omakase                                    \
	ruby-lsp                                                 \
	#
gem cleanup
