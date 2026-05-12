# -*- coding: utf-8 -*-
#!/bin/sh

PWD=`pwd`
BACKUP_DIR=${PWD}/backup
DOTFILES=".vimrc .zshrc .zprofile .zsh .vim .tmux .tmux.conf .tigrc .synergy.conf .claude-ntfy-topic"

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

mkdir -p ~/.vimcache/bak/
mkdir ~/.vimcache/vimswap/
mkdir ~/.vimcache/undo/
mkdir -p ~/.cache/shell

mkdir -p ~/.nvimcache/bak/
mkdir ~/.nvimcache/vimswap/
mkdir ~/.nvimcache/undo/

mkdir -p ${HOME}/bin
ln -sf ${PWD}/bin/* ${HOME}/bin

mkdir -p ~/.claude
mkdir -p ~/.claude-work
mkdir -p ~/.claude-personal
mkdir -p ~/.claude/ide
mkdir -p ~/.claude/projects
ln -sfn ~/.claude/ide ~/.claude-personal/ide
ln -sfn ~/.claude/ide ~/.claude-work/ide
# projectsは個人用と仕事用で分けるのではなく、共通化する
# すでにフォルダとして存在していたら削除してからシンボリックリンクを貼る
if [ -d ~/.claude-personal/projects ]; then
  rm -rf ~/.claude-personal/projects
fi
ln -sfn ~/.claude/projects ~/.claude-personal/projects
if [ -d ~/.claude-work/projects ]; then
  rm -rf ~/.claude-work/projects
fi
ln -sfn ~/.claude/projects ~/.claude-work/projects
curl -fsSL https://claude.ai/install.sh | bash
ln -sf ${PWD}/claude/CLAUDE.md ${HOME}/.claude/CLAUDE.md
ln -sf ${PWD}/claude/CLAUDE.md ${HOME}/.claude-work/CLAUDE.md
ln -sf ${PWD}/claude/CLAUDE.md ${HOME}/.claude-personal/CLAUDE.md
ln -sf ${PWD}/claude/settings.json ${HOME}/.claude/settings.json
ln -sf ${PWD}/claude/settings.json ${HOME}/.claude-work/settings.json
ln -sf ${PWD}/claude/settings.json ${HOME}/.claude-personal/settings.json
if [ -d ~/.claude/skills ]; then rm -rf ~/.claude/skills; fi
ln -sfn ${PWD}/claude/skills ~/.claude/skills
if [ -d ~/.claude-work/skills ]; then rm -rf ~/.claude-work/skills; fi
ln -sfn ${PWD}/claude/skills ~/.claude-work/skills
if [ -d ~/.claude-personal/skills ]; then rm -rf ~/.claude-personal/skills; fi
ln -sfn ${PWD}/claude/skills ~/.claude-personal/skills

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts

# Macだったらbrewで、Linuxだったらaptで必要なものを入れる
if [ "$(uname)" == "Darwin" ]; then
   brew install neovim tmux zsh peco ntfy
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
   sudo apt update
   sudo apt install -y tmux zsh xclip
   ARCH=$(uname -m)
   if [ "${ARCH}" == "aarch64" ]; then
       curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
       sudo rm -rf /opt/nvim-linux-arm64
       sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
   else
       curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
       sudo rm -rf /opt/nvim-linux-x86_64
       sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
   fi

   # aptにも存在するが、文字化けする。
   # 公式から直接入れたほうが良い
   if [ "${ARCH}" == "aarch64" ]; then
       wget https://github.com/peco/peco/releases/download/v0.6.0/peco_0.6.0_linux_arm64.tar.gz
       tar -xzf peco_0.6.0_linux_arm64.tar.gz
   else
       wget https://github.com/peco/peco/releases/download/v0.6.0/peco_0.6.0_linux_amd64.tar.gz
       tar -xzf peco_0.6.0_linux_amd64.tar.gz
   fi
   sudo mv peco /usr/local/bin
fi

NEOVIM_SETTINGS_DIR=${HOME}/.config/nvim
if [ -d ${NEOVIM_SETTINGS_DIR} ]; then
  rm -rf ${NEOVIM_SETTINGS_DIR}
fi
ln -sf ${PWD}/neovim-settings ${NEOVIM_SETTINGS_DIR}

# ntfy経由のClaude通知リスナー（Macのみ）
if [ "$(uname)" == "Darwin" ]; then
  PLIST_SRC="${PWD}/LaunchAgents/com.yan.claude-ntfy-listener.plist"
  PLIST_DST="${HOME}/Library/LaunchAgents/com.yan.claude-ntfy-listener.plist"
  launchctl unload "$PLIST_DST" 2>/dev/null || true
  ln -sf "$PLIST_SRC" "$PLIST_DST"
  launchctl load "$PLIST_DST"
  echo "LaunchAgent com.yan.claude-ntfy-listener をロードしました。"
  echo "SSH接続先サーバーにも ~/.claude-ntfy-topic を作成してください。"
fi
