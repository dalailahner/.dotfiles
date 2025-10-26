#!/usr/bin/env bash

FOLDERS=(.config/Epic .config/Loop_Hero .config/MangoHud .config/ModTheSpire .config/RogueLegacy .config/UNDERTALE .config/unity3d .factorio .killingfloor .klei .mbwarband .paradoxinteractive .paradoxlauncher .prey Zomboid .local/share/3909 .local/share/aspyr-media .local/share/Baba_Is_You .local/share/bohemiainteractive .local/share/cdprojektred '.local/share/Colossal Order' .local/share/Dredmor .local/share/FasterThanLight .local/share/feral-interactive .local/share/HotlineMiami .local/share/IntoTheBreach '.local/share/Paradox Interactive' .local/share/PillarsOfEternity .local/share/RogueLegacy .local/share/SteamWorldDig '.local/share/SteamWorld Dig 2' .local/share/SuperHexagon .local/share/Terraria .local/share/vpltd)

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
