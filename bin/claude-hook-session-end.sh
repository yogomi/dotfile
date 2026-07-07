#!/bin/bash
#
# SessionEnd hook: セッション終了時の状態（session_id, transcript_path, 終了時刻）を
# project-sessions/ の状態ファイルに保存する。transcriptそのものへは書き込まない。
# 次回起動時、bin/claude-project がこの状態ファイルを読んでresume判定に使う。
# stdinにはsession_id, transcript_path, cwd, reason等のJSONが渡される。

# claude-project --solo で起動したセッションはプロジェクトに紐付けないため記録しない
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
STATE_FILE="$STATE_DIR/${PROJECT_KEY}.json"

mkdir -p "$STATE_DIR"

INPUT="$INPUT" STATE_FILE="$STATE_FILE" python3 - <<'EOF'
import json, os, time

try:
    d = json.loads(os.environ['INPUT'])
except Exception:
    raise SystemExit(0)

# /clearで終了した場合は記録しない。clear前のセッションをresume対象にしないためで、
# clear後のセッションは自身の終了時に改めて記録される
if d.get('reason') == 'clear':
    raise SystemExit(0)

# transcriptが実在しないセッションは記録しない。resumeに失敗した起動や
# メッセージ交換前に終了したセッションでもSessionEndは発火するため、
# そのまま記録すると存在しないsession_idで状態ファイルを汚染し、
# 以降の起動が「No conversation found」で失敗し続けるループに陥る
transcript = d.get('transcript_path')
if not transcript or not os.path.exists(transcript):
    raise SystemExit(0)

state = {
    'session_id': d.get('session_id'),
    'transcript_path': transcript,
    'ended_at': int(time.time()),
}

# 書き込み途中のクラッシュで状態ファイルが壊れないよう、一時ファイル経由で置き換える
state_file = os.environ['STATE_FILE']
tmp_file = state_file + '.tmp'
with open(tmp_file, 'w') as f:
    json.dump(state, f, ensure_ascii=False)
os.replace(tmp_file, state_file)
EOF

exit 0
