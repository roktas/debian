#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

cry()        { echo -e "$*" >&2;                                                   }
die()        { cry "$@"; exit 1;                                                   }
enter()      { cry "==> $1"; cry ""; builtin pushd "$1" >/dev/null;                }
exe()        { /usr/bin/env bash "$@";                                             }
leave()      { builtin popd >/dev/null;                                            }
notice()     { builtin read -rp "S* " _ >&2;                                       }
run()        { cry "--> $1"; exe "$1.sh" || cry "!!! $(readlink -f "$1")"; cry ""; }

container()  { dockerized || [[ $(systemd-detect-virt -c) != none ]];              }
dockerized() { [[ -e /.dockerenv ]];                                               }
graphical()  { [[ -n ${DISPLAY:-} ]];                                              }
physical()   { ! dockerized && [[ $(systemd-detect-virt) == none ]];               }
virtual()    { ! physical;                                                         }

[[ ${EUID:-} -eq 0   ]] || die "You must be root."

BRANCH=${1:-}
GITHUB=${2:-https://github.com/roktas}

logfile="${TMPDIR:-/tmp}"/"${0##*/}"-"$(date --iso-8601=seconds)".log
exec > >(tee "$logfile") 2>&1

cry "... Preparing provisioning"

if grep -q "^NAME=.*[Dd]ebian" /etc/os-release; then
	codename=$(. /etc/os-release && echo "$VERSION_CODENAME") && cat >/etc/apt/sources.list <<-EOF
		deb http://ftp.tr.debian.org/debian/ $codename main non-free-firmware
		deb http://security.debian.org/debian-security $codename-security main non-free-firmware
		deb http://ftp.tr.debian.org/debian/ $codename-updates main non-free-firmware
	EOF
fi

export DEBIAN_FRONTEND=noninteractive && apt-get -y update && apt-get -y install --no-install-recommends \
	curl                                                                                             \
	git                                                                                              \
	jq                                                                                               \
	libarchive-tools                                                                                 \
	lsb-release                                                                                      \
	unzip                                                                                            \
	xz-utils                                                                                         \
	zstd                                                                                             \
	#

if [[ -t 0 ]]; then
	if [[ -n ${BASH_SOURCE[0]:-} ]]; then
		workdir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && echo "$PWD")
		cd "$workdir"
	fi

	[[ -d foundation ]] || die "Is this the $GITHUB/debian local copy?"
else
	workdir=$(mktemp -p "${TMPDIR:-/tmp}" -d "${0##*/}.XXXXXXXX") || exit
	trap 'err=$? && rm -rf "$workdir" || exit $err' EXIT HUP INT QUIT TERM
	cd "$workdir"
	GIT_CONFIG_NOSYSTEM=1 git clone --filter=blob:none "$GITHUB"/debian ${BRANCH:+--branch="$BRANCH"}
	cd debian
fi

cry "... Provisioning system"

enter foundation
	run foundation

	run standard
	run locale
	run timezone
	run tweak
leave

enter terminal
	run terminal

	run git
	run fish
	run nvim
	run vifm

	run bat
	run direnv
	run fd
	run fzf
	run ripgrep
	run slides
	run sudo
	run ttyd
	run zoxide

	graphical || run tmux
leave

enter runtime
	run runtime

	run go
	run javascript
	run lua
	run markdown
	run ruby
	run python
	run shell
	run tex
leave

! graphical || {
	enter desktop
		run desktop

		run chrome
		run dropbox
		run dropignore
		run fonts
		run graphics
		run laptop
		run obsidian
		run printer
		run vpn
		run vscode
	leave
}

enter virtualization
	run docker
	container  || run virtualbox
	virtual    || run hashicorp
leave

enter foundation
	run clean
leave

if [[ -z ${NO_DOTFILES:-} ]]; then
	cry "... Installing dotfiles"

	sudo -u '#1000' bash -s -- "$GITHUB" "$BRANCH" <<-'EOF'
		xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
		mkdir -p "$xdg_data_home" && cd "$xdg_data_home"
		GIT_CONFIG_NOSYSTEM=1 git clone --filter=blob:none ${1}/dotfiles ${2:+--branch="$2"} && cd dotfiles
		bash install.sh
	EOF
fi

exec &>"$(tty)"
