# copilotを起動するウィジェットを定義
copilot-widget() {
  BUFFER="copilot"
  zle accept-line
}
zle -N copilot-widget

# Ctrl+Hにバインド
bindkey '^h' copilot-widget
