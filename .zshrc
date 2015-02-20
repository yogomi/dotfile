# Created by newuser for 4.3.17


export EDITOR=vim
export LANG=ja_JP.UTF-8
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

DIRSTACKSIZE=100
setopt AUTO_PUSHD
zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

#補完候補がないときは、より曖昧検索パワーを高める
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}  r:|[._-]=*'
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
alias v=vim
case "${OSTYPE}" in
darwin*)
    alias lsusb='system_profiler SPUSBDataType'
    alias ls='ls -G'
    ;;
linux*)
    alias ls='ls --color=auto'
    ;;
esac

# google search<<<
function google() {
  local str opt
  if [ $# != 0 ]; then
    for i in $*; do
      str="$str+$i"
    done
    str=`echo $str | sed 's/^\+//'`
    opt='search?num=50&hl=ja&lr=lang_ja'
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt
}
#>>>

if which peco > /dev/null; then
    echo 'use peco'
    source ~/.zsh/.zrc.peco.zsh
    function _insert_pecopipe() {
        LBUFFER=${LBUFFER}" | peco"
    }
    zle -N _insert_pecopipe
    bindkey '^[^[' _insert_pecopipe
else
    echo 'no peco'
fi


source ${HOME}/.zsh/modules/zsh-context-sensitive-alias/csa.zsh
csa_init

# コンテキストを更新する関数
function my_context_func {
	local -a ctx
	# Git リポジトリの中にいるなら git コンテキストを追加
	if [[ -n `git rev-parse --git-dir 2> /dev/null` ]]; then
		ctx+=git
	fi
	# Mercurial リポジトリの中にいるなら hg コンテキストを追加
	if [[ -n `hg root 2> /dev/null` ]]; then
		ctx+=hg
	fi
	if [[ -e Rakefile ]]; then
		ctx+=rake
	fi
	if [[ -e Gemfile ]]; then
		ctx+=bundler
	fi

	# コンテキストをセット
	# 同名のエイリアスが複数のコンテキストで定義されている場合、
	# 配列変数 ctx 内の*より後ろ*にあるコンテキストのエイリアスが優先される
	csa_set_context $ctx
}

# コンテキストを更新する関数が cd のたびに呼ばれるようにする
chpwd_functions+=my_context_func

# csalias <context> <alias> <command>
csalias git sm 'git submodule'

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

eval "$(rbenv init -)"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
PATH=${HOME}/bin:${HOME}/.rbenv/bin:/usr/local/Qt-5.3.1/bin:$PATH:${HOME}/.tmux/bin:$PATH
