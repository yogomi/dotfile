# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .zprofile .zsh .vim .tmux .tmux.conf .tigrc .nvm .synergy.conf"

DEIN_INSTALL_SCRIPT="https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh"

echo ${PWD}

git submodule init & git submodule update

for file in ${DOTFILES}
do
    rm -rf ${HOME}/${file}
    ln -sf ${PWD}/${file} ${HOME}/${file}
done

mkdir -p .cache/dein
curl ${DEIN_INSTALL_SCRIPT} > /tmp/dein_installer.sh
sh /tmp/dein_installer.sh ~/.cache/dein

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
