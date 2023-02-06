# Created by newuser for 4.3.17

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
PATH=${HOME}/bin:${HOME}/.rbenv/bin:${HOME}/Qt/5.12.4/clang_64/bin:$PATH:${HOME}/.tmux/bin:$PATH

export EDITOR=vim
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export AUTOFEATURE=true
bindkey -e

setopt auto_cd
setopt correct
setopt magic_equal_subst
setopt prompt_subst
setopt notify
setopt equals

RPROMPT='[%d]'

### complement ###
autoload -U compinit;
compinit
setopt auto_list
setopt auto_menu
setopt list_packed
setopt list_types

typeset -ga chpwd_functions

# 補完方法の設定 指定した順番に実行
### _oldlist 前回の補完結果を再利用する。
### _complete: fpath補完
### _expand: globや変数の展開を行う
### _match: globを展開しないで候補の一覧から補完する。
### _history: ヒストリのコマンドも補完候補とする。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer \
    _oldlist _complete _expand _match _history _ignored _approximate _prefix

## sudo時にはsudo用のパスも使う。
zstyle ':completion:sudo:*' environ PATH="$SUDO_PATH:$PATH"

DIRSTACKSIZE=100
setopt AUTO_PUSHD
zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

#補完候補がないときは、より曖昧検索パワーを高める
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
##zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}  r:|[._-]=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache true

# 詳細な情報を使う。
zstyle ':completion:*' verbose yes
# 補完リストをグループ分けする
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:warnings' format 'No matches for: %d'
## via cdd formaat
zstyle ':completion:*:descriptions' format '%BCompleting%b %F{yellow}%U%d%u'
zstyle ':completion:*' list-separator '-->'
# ../ などとタイプしたとき、現在いるディレクトリを補完候補に出さない
zstyle ':completion:*' ignore-parents parent pwd ..

autoload -Uz is-at-least
if is-at-least 4.3.11; then
  autoload -U chpwd_recent_dirs cdr
  chpwd_functions+=chpwd_recent_dirs
  zstyle ":chpwd:*" recent-dirs-max 500
  zstyle ":chpwd:*" recent-dirs-default true
  zstyle ":completion:*" recent-dirs-insert always
fi

### History ###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt share_history
setopt hist_reduce_blanks
setopt hist_save_no_dups

# enable cdr {{{
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true
# }}}

### Ls Color ###
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=34;01:ln=36;01:so=32:pi=33:ex=32;01:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# ls自動で色がつく
export CLICOLOR=true
# 補完候補に色をつける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Prompt ###
autoload -U colors; colors


alias g=git
alias nv=nvim
alias sl=ls
case "${OSTYPE}" in
darwin*)
    alias lsusb='system_profiler SPUSBDataType'
    alias ls='ls -G'
    ;;
linux*)
    alias ls='ls --color=auto'
    ;;
esac

if which nvim > /dev/null; then
    echo 'use nvim as vim'
    alias vim=nvim
fi

alias ll='ls -alh'

if which peco > /dev/null; then
    echo 'use peco'
    source ~/.zsh/zrc.peco.zsh
    function _insert_pecopipe() {
        LBUFFER=${LBUFFER}" | peco"
    }
    zle -N _insert_pecopipe
    bindkey '^[^[' _insert_pecopipe
else
    echo 'no peco'
fi

if which python3 > /dev/null; then
    source ~/.zsh/zrc.python3.zsh
else
    echo 'no python3'
fi

#docker
alias goat="docker --tlsverify --tlscacert=${HOME}/.docker/certs-for-goat/ca.pem --tlscert=${HOME}/.docker/certs-for-goat/cert.pem --tlskey=${HOME}/.docker/certs-for-goat/key.pem -H=red-goat.japaneast.cloudapp.azure.com:2376"
alias yacker="docker -H tcp://10.41.17.251:2376"
alias ycompose="docker-compose -H tcp://10.41.17.251:2376"

source ${HOME}/.zsh/modules/zsh-context-sensitive-alias/csa.zsh
csa_init

# コンテキストを更新する関数
function my_context_func {
	local -a ctx
	# Git リポジトリの中にいるなら git コンテキストを追加
	if [[ -n `git rev-parse --git-dir 2> /dev/null` ]]; then
		ctx+=git
	fi

	# コンテキストをセット
	# 同名のエイリアスが複数のコンテキストで定義されている場合、
	# 配列変数 ctx 内の*より後ろ*にあるコンテキストのエイリアスが優先される
	csa_set_context $ctx
}

function groot() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `git rev-parse --show-toplevel`
  fi
}

alias prt="groot"

function vixit() {
  if [ -n "${VIM}" ]; then
    exit
  else
    echo 'Not shell in vim'
  fi
}

# コンテキストを更新する関数が cd のたびに呼ばれるようにする
chpwd_functions+=my_context_func

# csalias <context> <alias> <command>
csalias git sm 'git submodule'

export PATH="$HOME/.rbenv/bin:$PATH:/sbin:/usr/sbin"
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

eval "$(rbenv init -)"
case ${OSTYPE} in
  darwin*)
    source ~/.zsh/darwin/*
    ;;
  linux*)
    ;;
esac

# node.js
source ~/.zsh/zrc.node.js.zsh
export PATH="/usr/local/sbin:./node_modules/.bin:$PATH"

# go
export GOPATH=$HOME/.gopath
export GOROOT=$( go env GOROOT )
export PATH=$GOPATH/bin:$PATH

# android sdk
export PATH=${HOME}/Library/Android/sdk/tools:${HOME}/Library/Android/sdk/platform-tools:${PATH}
export ANDROID_HOME=${HOME}/Library/Android/sdk
export ANDROID_NDK_HOME=${HOME}/workspace/sdk/android-ndk-r16b

# google cloud
export PATH=${HOME}/workspace/sdk/google-cloud-sdk/bin:${PATH}

# flutter
export PATH=${HOME}/workspace/sdk/flutter/bin:${PATH}

# aws
source ~/.zsh/aws.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rust
export PATH="$HOME/.cargo/bin:${PATH}"
