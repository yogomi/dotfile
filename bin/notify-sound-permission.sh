#!/bin/bash

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  printf '\a'
else
  afplay /System/Library/Sounds/Submarine.aiff
fi
