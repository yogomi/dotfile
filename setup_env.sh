# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .zprofile .zsh .vim .tmux .tmux.conf .tigrc .nvm"

NEOBUNDLE_GIT_URL="git://github.com/Shougo/neobundle.vim"
NEOBUNDLE_DIST_DIR="${PWD}/.vim/bundle/neobundle.vim"

echo ${PWD}

git submodule init & git submodule update

for file in ${DOTFILES}
do
    rm -rf ${HOME}/${file}
    ln -sf ${PWD}/${file} ${HOME}/${file}
done

mkdir -p .vim/bundle
git clone ${NEOBUNDLE_GIT_URL} ${NEOBUNDLE_DIST_DIR}

mkdir -p ~/.vimcache/bak/
mkdir ~/.vimcache/vimswap/
mkdir ~/.vimcache/undo/
mkdir -p ~/.cache/shell

mkdir -p ${HOME}/bin
ln -sf ${PWD}/bin/* ${HOME}/bin
