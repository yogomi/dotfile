#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # SSH経由 → ntfy経由でMacに通知を送る
  NTFY_TOPIC=$(cat "$HOME/.claude-ntfy-topic" 2>/dev/null)
  NTFY_TOPIC="${NTFY_TOPIC:-${NTFY_CLAUDE_TOPIC:-}}"
  if [ -n "$NTFY_TOPIC" ]; then
    curl -s -X POST -d "notify" "https://ntfy.sh/${NTFY_TOPIC}-notify" > /dev/null &
  fi
else
  # ローカルMac → Stopから3分以内は入力待ち通知なので抑制
  stop_last=$(cat /tmp/claude-stop-local-last 2>/dev/null || echo 0)
  now=$(date +%s)
  if [ $((now - stop_last)) -gt 180 ]; then
    afplay /System/Library/Sounds/Submarine.aiff
  fi
fi
