#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

abort() { warn "$@"; exit 1; }
quit()  { warn "$@"; exit 0; }
warn()  { echo "$*" >&2;     }

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
