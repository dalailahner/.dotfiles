#!/bin/bash
if [ -d "/home/$USER/.local/share/pnpm/.tools/pnpm" ]; then
  echo "updating pnpm of $USER"
  /home/$USER/.local/share/pnpm/pnpm self-update
  cd "/home/$USER/.local/share/pnpm/.tools/pnpm"
  echo "removing old pnpm versions in $PWD"
  ls -d */ | sort -V | head -n -1 | xargs -d '\n' -r rm -rf
  echo "prune pnpm store"
  /home/$USER/.local/share/pnpm/pnpm store prune
else
  echo "/home/$USER/.local/share/pnpm/.tools/pnpm is not a folder! please update and cleanup pnpm manually!"
fi
