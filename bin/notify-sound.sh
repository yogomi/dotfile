#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  # SSH経由 → ベル文字を送信してローカルで鳴らす
  printf '\a'
else
  # ローカル → afplayで直接鳴らす
  afplay /System/Library/Sounds/Glass.aiff
fi
