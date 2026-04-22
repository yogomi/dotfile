#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # SSH経由 → ntfy経由でMacに通知を送る
  NTFY_TOPIC=$(cat "$HOME/.claude-ntfy-topic" 2>/dev/null)
  NTFY_TOPIC="${NTFY_TOPIC:-${NTFY_CLAUDE_TOPIC:-}}"
  if [ -n "$NTFY_TOPIC" ]; then
    curl -s -X POST -d "stop" "https://ntfy.sh/${NTFY_TOPIC}-stop" > /dev/null &
  fi
else
  # ローカル → afplayで直接鳴らす
  afplay /System/Library/Sounds/Glass.aiff
fi
