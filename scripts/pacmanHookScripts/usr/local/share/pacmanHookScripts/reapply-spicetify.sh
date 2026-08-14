#!/usr/bin/env bash

sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

for dir in /home/*; do
  user=$(basename "$dir")
  # check if real user and if proper directory
  if id "$user" &>/dev/null && [ -d "$dir" ]; then
    echo "applying spicetify backup to $user's spotify"
    sudo -i -u "$user" /usr/bin/spicetify backup apply
  fi
done
