#!/bin/bash
for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    echo "updating $user's tealdeer database"
    sudo -i -u "$user" /usr/bin/tldr --update
  fi
done
