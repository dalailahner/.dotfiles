#!/bin/bash
for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    echo "init $user's pnpm update"
    cd "/home/$user"
    sudo -Hu "$user" zsh -lc "/usr/local/bin/pacmanHookScripts/pnpm-user-update.sh"
  fi
done
