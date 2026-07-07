#!/bin/bash
# Claude Code ステータスライン
# 5時間枠・週次枠のレートリミット使用率を 8 セグメントのバーで表示する。
# 入力: Claude Code が stdin に渡すセッション JSON
# 注意: rate_limits はセッション初回の API 応答後にのみ含まれる（Pro/Max 限定）。
#       欠損時は該当セクションを省略して表示する。

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  printf '🤖 statusline: jq が見つかりません\n'
  exit 0
fi

IFS=$'\t' read -r model ctx used5 reset5 used7 reset7 <<< "$(
  jq -r '[
    (.model.display_name // "?"),
    (.context_window.used_percentage // "null"),
    (.rate_limits.five_hour.used_percentage // "null"),
    (.rate_limits.five_hour.resets_at // "null"),
    (.rate_limits.seven_day.used_percentage // "null"),
    (.rate_limits.seven_day.resets_at // "null")
  ] | @tsv' <<< "$input"
)"

RESET=$'\033[0m'

# 使用率(%)から使用量バー（8 セグメント・色付き）と使用済み% の文字列を作る
# 100% で上限到達。使用 50% 未満は緑、50〜80% は黄、80% 超は赤で表示する
render_gauge() {
  local used=$1
  local pct filled i bar color
  pct=$(awk -v u="$used" 'BEGIN { if (u < 0) u = 0; if (u > 100) u = 100; printf "%.0f", u }')
  filled=$(( (pct * 8 + 50) / 100 ))
  if [ "$pct" -lt 50 ]; then
    color=$'\033[32m'
  elif [ "$pct" -le 80 ]; then
    color=$'\033[33m'
  else
    color=$'\033[31m'
  fi
  bar=''
  for ((i = 0; i < 8; i++)); do
    if [ "$i" -lt "$filled" ]; then bar+='▮'; else bar+='▯'; fi
  done
  printf '%s%s %s%%%s' "$color" "$bar" "$pct" "$RESET"
}

line="🤖 ${model}"

if [ "$ctx" != "null" ]; then
  line+=" | 🧠 $(awk -v c="$ctx" 'BEGIN { printf "%.0f", c }')%"
fi

if [ "$used5" != "null" ]; then
  line+=" | 5h $(render_gauge "$used5")"
  if [ "$reset5" != "null" ]; then
    line+=" (〜$(date -r "$reset5" +%H:%M))"
  fi
fi

if [ "$used7" != "null" ]; then
  line+=" | 週 $(render_gauge "$used7")"
  if [ "$reset7" != "null" ]; then
    secs=$(( reset7 - $(date +%s) ))
    if [ "$secs" -lt 0 ]; then secs=0; fi
    if [ "$secs" -lt 86400 ]; then
      line+=" (あと$(( (secs + 3599) / 3600 ))時間)"
    else
      line+=" (あと$(( (secs + 86399) / 86400 ))日)"
    fi
  fi
fi

printf '%s\n' "$line"
