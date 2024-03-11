#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	pylint                             \
	python3-numpy                      \
	python3-pandas                     \
	python3-pip                        \
	python3-pylsp                      \
	#
