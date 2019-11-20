#! /bin/sh

SWORD_PATH=${HOME}/.sword
. $SWORD_PATH/pre.sh

cd $SWORD_PATH
git submodule init
git submodule update

# options
# todo need classified stuff?
# sh -c '${SWORD_PATH}/bin/syncfromcoal'

# timestamp
sudo ln -snf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

# ## dependencies
if [[ os = "linux" ]]; then
    # assuming linux distribution is Ubuntu
    sudo apt update
    sudo apt-get install -y curl wget openssl sysstat \
        build-essential cmake python3-dev \
        libncurses5-dev libncursesw5-dev libpq-dev \
        mongodb-clients redis-tools liblzo2-dev \
        htop

elif [[ os = "mac" ]]; then
    xcode-select --install
    which brew
    # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    # brew install wget
fi

# zsh
# https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH
if [[ os = "mac" ]]; then
    echo "brew install zsh zsh-completions"
    brew install zsh zsh-completions
elif [[ os = "linux" ]]; then
    # assuming os is ubuntu
    echo "sudo apt-get install -y zsh"
    sudo apt-get install -y zsh
fi

# oh-my-zsh
if [[ -x $(which zsh) ]]; then
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

    grep "source ${SWORD_PATH}/shell.rc" ~/.zshrc
    if [[ $? != 0 ]]; then
        sed -i".bak" "/source \$ZSH\/oh-my-zsh.sh/ i \\
source ${SWORD_PATH}/shell.rc\\
\\
" ~/.zshrc
    fi
fi

# Python
echo 'python stuff, pip, pip3 and virtualenv'

if [[ !(-x $(which pip)) ]]; then
    sudo apt-get install -y python-pip
fi

if [[ !(-x $(which pip3)) ]]; then
    sudo apt-get install -y python3-pip
fi

if [[ !(-x $(which virtualenv)) ]]; then
    sudo apt-get install -y python-pip
fi

# optional

# tmux
# https://github.com/gpakosz/.tmux.git
if [[ os = "linux" ]]; then
    # assuming linux distribution is Ubuntu
    sudo apt-get install -y tmux
elif [[ os = "mac" ]]; then
    brew install tmux
fi

if [[ $? != 0 ]]; then
    exit $?
fi

if [[ -e ~/.tmux.conf ]]; then
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi

if [[ -e ~/.tmux.conf.local ]]; then
    mv ~/.tmux.conf.local ~/.tmux.conf.local.bak
fi
ln -s ${SWORD_PATH}/dottmux/.tmux.conf ~/.tmux.conf
ln -s ${SWORD_PATH}/dottmux/.tmux.conf.local ~/.tmux.conf.local

# vim
# airline
# powerline

# git

# pip sudo easy_install pip
# python3, virtualenv
# jq
# wgets

# if mac
# brew
# endif mac

# utils
# mdp

