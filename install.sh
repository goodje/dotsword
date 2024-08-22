#!/bin/sh

SWORD_PATH=${HOME}/.sword
. $SWORD_PATH/pre.sh

SET_TIMEZONE=0

git submodule init
git submodule update

# options
# todo need classified stuff?
# sh -c '${SWORD_PATH}/bin/syncfromcoal'

# set timezone
if [[ $ostype == "linux" && $SET_TIMEZONE ]]; then
	sudo ln -snf /usr/share/zoneinfo/Asia/Singapore /etc/localtime
fi

if [[ $os == "ubuntu" ]]; then
    sudo apt update
    sudo apt upgrade -y
    sudo apt-get install -y \
        curl wget openssl sysstat \
        build-essential cmake python3-dev \
        libncurses5-dev libncursesw5-dev libpq-dev \
        mongodb-clients redis-tools liblzo2-dev \
        htop ripgrep

    echo "Installing zsh"
    sudo apt-get install -y zsh

elif [[ $os == "macos" ]]; then
    xcode-select --install
    if ! command -v brew &> /dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "brew installing stuff"
    brew install zsh zsh-completions tmux nvim python3 fzf ripgrep
fi

# oh-my-zsh
if command -v zsh &> /dev/null; then
	echo "Intalling ohmyzsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    grep "source ${SWORD_PATH}/shell.rc" ~/.zshrc
    if [[ $? != 0 ]]; then
        sed -i".bak" "/source \$ZSH\/oh-my-zsh.sh/ i \\
source ${SWORD_PATH}/shell.rc\\
\\
" ~/.zshrc
    fi
fi

# install fzf
if [[ $os == "macos" ]]; then
	echo "Installing fzf"
	brew install fzf
elif [[ $os == "ubuntu" ]]; then
	echo "Installing fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install # it will prompt for installation options
fi

# tmux
if [[ -e ~/.tmux.conf ]]; then
	mv ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s ${SWORD_PATH}/tmux/tmux.conf ~/.tmux.conf

# tmux plugin manager
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ $os == "ubuntu" ]]; then
	# Python
	echo 'python stuff, pip, pip3 and virtualenv'

	if [[ !(-x $(which pip3)) ]]; then
		echo "Install python3-pip"
		sudo apt-get install -y python3-pip
	fi
fi

# TODO
# python3 -m pip install --upgrade pip
# pip3 install virtualenv

# python support for vim and nvim
if [[ $os == "macos" ]]; then
	python3 -m pip install --user --upgrade pynvim --break-system-packages
	python3 -m pip install --user --upgrade pyvim --break-system-packages
else
	python3 -m pip install --user --upgrade pynvim
	python3 -m pip install --user --upgrade pyvim
fi

# neovim or nvim
if [[ ! -d ~/.config/nvim ]]; then
	mkdir -p ~/.config/nvim
fi
grep "~/.vimrc" ~/.config/nvim/init.vim > /dev/null 2>&1
if [[ $? != 0 ]]; then
	echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc" >> ~/.config/nvim/init.vim
fi

# golang
if [[ $os == "ubuntu" ]]; then
	# go download page - https://go.dev/dl/
	wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz -O /tmp/go.tar.gz
	tar -C /usr/local -xzf /tmp/go.tar.gz
	export PATH=$PATH:/usr/local/go/bin
	echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.zshrc
	echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
elif [[ $os == "macos" ]]; then
	brew install golang
fi

# nvm
if [[ ! -d ~/.nvm ]]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
	. ~/.zshrc
	nvm install --lts
	nvm use --lts
fi

# workspace
if [[ ! -d ~/workspace ]]; then
	mkdir -p ~/workspace/goodje
	mkdir -p ~/workspace/vendors
fi

# optional

# git

# pip sudo easy_install pip
# python3, virtualenv
# jq
# wgets

# utils
# mdp

