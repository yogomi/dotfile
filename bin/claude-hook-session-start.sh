#!/bin/bash
#
# SessionStart hook: 前回セッションの要約（pending）があればadditionalContextとして注入する。
# 一度注入したpendingファイルはconsume-onceで削除する。stdinにはcwd, session_id, source等の
# JSONが渡される。常に高速に終わることを優先し、重い処理は行わない。

# claude-project --solo で起動したセッションはプロジェクトに紐付けないため注入しない
if [ -n "${CLAUDE_PROJECT_SOLO:-}" ]; then
  exit 0
fi

INPUT=$(cat)

CWD=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get('cwd', ''))
except Exception:
    print('')
")

if [ -z "$CWD" ]; then
  exit 0
fi

GIT_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)

if [ -z "$GIT_ROOT" ]; then
  exit 0
fi

PROJECT_KEY=$(echo "$GIT_ROOT" | sed 's/[^a-zA-Z0-9]/-/g')
STATE_DIR="$HOME/.claude/project-sessions"
PENDING_FILE="$STATE_DIR/${PROJECT_KEY}.pending.md"

if [ ! -f "$PENDING_FILE" ]; then
  exit 0
fi

# 注入JSONの出力に成功した場合のみpendingを削除する（失敗時に要約を失わないため）
if PENDING_FILE="$PENDING_FILE" python3 - <<'EOF'
import json, os

pending_file = os.environ['PENDING_FILE']
with open(pending_file) as f:
    pending = f.read()

context = f'[前のセッションの要約]\n\n{pending}'
output = {
    'hookSpecificOutput': {
        'hookEventName': 'SessionStart',
        'additionalContext': context,
    }
}
print(json.dumps(output, ensure_ascii=False))
EOF
then
  rm -f "$PENDING_FILE"
fi
