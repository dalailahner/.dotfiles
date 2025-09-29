#!/bin/bash
for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    echo "updating $user's pnpm"
    cd "/home/$user/.local/share/pnpm"
    ./pnpm self-update
  fi
done
