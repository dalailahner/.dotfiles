#!/bin/bash
for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    sudo -u "$user" /usr/bin/sudo -u "${SUDO_USER:-$(logname 2>/dev/null)}" /usr/bin/spicetify backup apply
  fi
done
