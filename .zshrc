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

DIRSTACKSIZE=100
setopt AUTO_PUSHD
zstyle ':completion:*' menu select
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:descriptions' format '%BCompleting%b %U%d%u'

### History ###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt share_history
setopt hist_reduce_blanks

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

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles
PATH=${HOME}/bin:${HOME}/.tmux/bin:$PATH
