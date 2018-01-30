#! /bin/sh

SWORD_PATH=${HOME}/.sword

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

# todo check distribution version

# ## dependencies
if [[ os = "linux" ]]; then
    # assuming linux distribution is Ubuntu
    sudo apt-get install -y curl wget openssl
elif [[ os = "mac" ]]; then
    echo $1
    xcode-select --install
    # /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    # brew install wget
fi

# options
# todo need classified stuff?

cd $SWORD_PATH
# git fetch origin dawn # todo
# git checkout -B dawn origin/dawn

# zsh https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH
if [[ os = "mac" ]]; then
    echo 1
    # echo "brew install zsh zsh-completions"
    # brew install zsh zsh-completions
elif [[ os = "linux" ]]; then
    # assuming os is ubuntu
    echo "sudo apt-get install -y zsh"
    sudo apt-get install -y zsh
fi

# oh-my-zsh
# curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

grep "source ${SWORD_PATH}/shell.rc" ~/.zshrc
if [[ $? != 0 ]]; then
    sed -i".bak" "/source \$ZSH\/oh-my-zsh.sh/ i \\
source ${SWORD_PATH}/shell.rc\\
\\
" ~/.zshrc
fi

# from coal

sh -c '${SWORD_PATH}/bin/syncfromcoal'

# optional
# tmux, & https://github.com/gpakosz/.tmux.git

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


