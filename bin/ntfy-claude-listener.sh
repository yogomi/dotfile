#!/bin/bash
# Mac側で常駐してntfy経由のClaude通知を受け取り、afplayで音を鳴らす。
# ~/.claude-ntfy-topic に使用するトピック名（ベース名）を記載する。

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

NTFY_TOPIC=$(cat "$HOME/.claude-ntfy-topic" 2>/dev/null)
NTFY_TOPIC="${NTFY_TOPIC:-${NTFY_CLAUDE_TOPIC:-}}"

if [ -z "$NTFY_TOPIC" ]; then
  echo "エラー: ~/.claude-ntfy-topic が未設定です。" >&2
  exit 1
fi

echo "ntfy-claude-listener: トピック '${NTFY_TOPIC}' を監視中..."

# --since connected で接続確立後のメッセージのみ受信（再起動時のキャッシュ再配信を防ぐ）
ntfy subscribe --since connected "${NTFY_TOPIC}-stop" \
  'afplay /System/Library/Sounds/Glass.aiff' &
PID_STOP=$!

ntfy subscribe --since connected "${NTFY_TOPIC}-notify" \
  'afplay /System/Library/Sounds/Submarine.aiff' &
PID_NOTIFY=$!

trap "kill $PID_STOP $PID_NOTIFY 2>/dev/null; exit 0" TERM INT

wait $PID_STOP $PID_NOTIFY
