# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .zprofile .zsh .vim .tmux .tmux.conf .tigrc .nvm .synergy.conf .config/nvim"

DEIN_INSTALL_SCRIPT="https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh"

git config --global user.name "Makoto Yano"
git config --global user.email "yan133@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nvim

echo ${PWD}

git submodule init & git submodule update

mkdir -p ~/.config
for file in ${DOTFILES}
do
    rm -rf ${HOME}/${file}
    ln -sf ${PWD}/${file} ${HOME}/${file}
done

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

python -m pip install --user --upgrade pynvim

mkdir -p ~/.vimcache/bak/
mkdir ~/.vimcache/vimswap/
mkdir ~/.vimcache/undo/
mkdir -p ~/.cache/shell

mkdir -p ~/.nvimcache/bak/
mkdir ~/.nvimcache/vimswap/
mkdir ~/.nvimcache/undo/

rm -rf ${HOME}/.zsh/modules/zsh-context-sensitive-alias
git clone https://github.com/uasi/zsh-context-sensitive-alias.git
mv zsh-context-sensitive-alias ${HOME}/.zsh/modules/

mkdir -p ${HOME}/bin
ln -sf ${PWD}/bin/* ${HOME}/bin

wget wget https://github.com/peco/peco/releases/download/v0.5.11/peco_linux_amd64.tar.gz
tar xzf peco_linux_amd64.tar.gz
mv peco_linux_amd64/peco ${HOME}/bin/
rm -rf peco_linux_amd64*
