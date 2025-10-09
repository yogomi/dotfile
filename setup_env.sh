# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .zprofile .zsh .vim .tmux .tmux.conf .tigrc .synergy.conf"

DEIN_INSTALL_SCRIPT="https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh"

git config --global user.name "Makoto Yano"
git config --global user.email "yan133@gmail.com"
git config --global init.defaultBranch main
git config --global core.editor nvim

echo ${PWD}

git submodule init & git submodule update

NEOVIM_SETTINGS_DIR=${HOME}/.config/nvim
if [ -d ${NEOVIM_SETTINGS_DIR} ]; then
  rm -rf ${NEOVIM_SETTINGS_DIR}
fi
ln -sf ${PWD}/neovim-settings ${NEOVIM_SETTINGS_DIR}

mkdir -p ~/.config
for file in ${DOTFILES}
do
    rm -rf ${HOME}/${file}
    ln -sf ${PWD}/${file} ${HOME}/${file}
done

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

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts

# Macだったらbrewで、Linuxだったらaptで必要なものを入れる
if [ "$(uname)" == "Darwin" ]; then
   brew install neovim tmux zsh peco
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   sudo apt update
   sudo apt install -y tmux zsh xclip
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
   sudo rm -rf /opt/nvim-linux-x86_64
   sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

   # aptにも存在するが、文字化けする。
   # 公式から直接入れたほうが良い
   wget https://github.com/peco/peco/releases/download/v0.5.11/peco_linux_amd64.tar.gz
   tar -xzf peco_linux_amd64.tar.gz
   sudo mv peco_linux_amd64/peco /usr/local/bin
fi
