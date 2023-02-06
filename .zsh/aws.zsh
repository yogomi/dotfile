autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

AWS_COMPLETER=$(which aws_completer)
if [ $? = 0 ]; then
  complete -C "${AWS_COMPLETER}" aws
fi
