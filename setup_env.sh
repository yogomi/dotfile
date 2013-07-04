# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .vim .tmux.conf"

NEOBUNDLE_GIT_URL="git://github.com/Shougo/neobundle.vim"
NEOBUNDLE_DIST_DIR="${PWD}/.vim/bundle/neobundle.vim"

echo ${PWD}

for file in ${DOTFILES}
do
    rm -f ${HOME}/${file}
    ln -sf ${PWD}/${file} ${HOME}/${file}
done

mkdir -p .vim/bundle
git clone ${NEOBUNDLE_GIT_URL} ${NEOBUNDLE_DIST_DIR}
ln -sf ${PWD}/.vim ${HOME}/.vim