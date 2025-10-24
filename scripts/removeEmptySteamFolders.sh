#!/usr/bin/env bash
FOLDERS=(.factorio .killingfloor .klei .mbwarband .paradoxinteractive .paradoxlauncher .prey Zomboid)

for FOLDER in "${FOLDERS[@]}"; do
  if [ -d "$HOME/$FOLDER" ]; then
    if [ "$(ls -A "$HOME/$FOLDER")" ]; then
      echo "Directory '$FOLDER' is not empty."
    else
      rm -r "$HOME/$FOLDER"
    fi
  else
    echo "Directory '$FOLDER' does not exist."
  fi
done
