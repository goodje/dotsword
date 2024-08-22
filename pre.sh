#!/bin/sh

# this file defines prefix and assumtions, used for install & zshrc dependencies

export SWORD_PATH=${HOME}/.sword
export SWORD_CUSTOM_PATH=${SWORD_PATH}/custom
# export $SWORD_PATH
# export $SWORD_CUSTOM_PATH
#
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	ostype="linux"
	if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
		os="ubuntu"
	else
		echo "Unsupported Linux distribution"
		exit(1)
	  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
	ostype="macos"
	os="macos"
else
	echo "Unsupported os"
	exit(1)
fi

# -- function
source_include () {
    [[ -f $1 ]] && source $1
}

BASEDIR=$(dirname "$0")

if ! command -v realpath &> /dev/null; then
	realpath() {
		[[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
	}
fi

