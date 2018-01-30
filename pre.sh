#! /bin/sh

# this file defines prefix and assumtions, used for install & zshrc dependencies

SWORD_PATH=${HOME}/.sword
SWORD_CUSTOM_PATH=${SWORD_PATH}/custom
# export $SWORD_PATH
# export $SWORD_CUSTOM_PATH

# -- function
source_include () {
    [[ -f $1 ]] && source $1
}

echo 123
