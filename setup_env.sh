# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc"

echo ${PWD}

for file in ${DOTFILES}
do
    ln -sf ${PWD}/${file} ${HOME}/${file}
done
