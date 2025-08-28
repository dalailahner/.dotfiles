#!/bin/bash
for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    echo "cleaning $user's pacman and yay caches"
    /usr/bin/paccache -rk2
    /usr/bin/paccache -rk2 -c "/home/$user/.cache/yay"
  fi
done
