#! /bin/sh

# this file defines prefix and assumtions, used for install & zshrc dependencies

SWORD_PATH=${HOME}/.sword
SWORD_CUSTOM_PATH=${SWORD_PATH}/custom
# export $SWORD_PATH
# export $SWORD_CUSTOM_PATH

# ## todo check distribution version
case `uname -s` in
    Darwin*)
        os=mac
        ;;
    Linux*)
        os=linux
        ;;
    # CYGWIN*, MINGW*, MSYS*, ..
    *)
        echo "doesn't support your operating system."
        exit -1
esac

export os

# -- function
source_include () {
    [[ -f $1 ]] && source $1
}
