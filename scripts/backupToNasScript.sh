#!/usr/bin/env bash

### IMPORTANT:
### $backupMachineIP & $MEDIA_DRIVE_UUID are an environment variables that must be set in /etc/profile or /etc/environment

# exit on errors and unset variables
set -eu

errorLogFile="$HOME/backupErrorLog.txt"
SSHusername=dalailahner

if [[ -z "$backupMachineIP" ]]; then
  printf "environment variable backupMachineIP is not set. please set it in /etc/profile or /etc/environment and reboot\n"
  exit 1
fi

if [[ -z "$MEDIA_DRIVE_UUID" ]]; then
  printf "environment variable MEDIA_DRIVE_UUID is not set. please set it in /etc/profile or /etc/environment and reboot\n"
  exit 1
fi

rm -f "$errorLogFile"
date > "$errorLogFile"

homeDirBackup () {
  if [[ "$#" == 1 && -n "$1" ]]; then
    printf "media drive is mounted\n"
    printf "\n"
    echo "---------------------------------------------------------------------------------"
    printf "\nbacking up %s's home directory...\n" "$1"
    excludePaths=(
      "/Documents/"
      "/Pictures/"
      "/Videos/"
      "/Music/"
      "/3D/"
      "/.cache/"
      "/.var/"
      "/.local/share/Trash/"
      "/.local/share/klipper/"
      "/.local/share/Steam/"
      "/.local/share/fresh/file_states/"
      "/.local/state/fresh/logs/"
      "/.wine/drive_c/users/$1/AppData/Local/Temp/"
      "/.config/vesktop/sessionData/Cache/Cache_Data"
      "/.config/Code/Cache/Cache_Data"
      "/.config/Code/CachedData"
      "/.config/micro/buffers/"
      "/linux-tkg/linux-src-git/"
      "node_modules/"
    )
    excludeListArr=()
    for folder in "${excludePaths[@]}"; do
        excludeListArr+=(--exclude="$folder")
    done
    sudo -u "$1" rsync -aAXv --delete "${excludeListArr[@]}" "/home/$1/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/home/$1/" 2>> "$errorLogFile"

    printf "\nbacking up Documents ...\n"
    sudo -u "$1" rsync -aAXv --delete "/home/$1/Documents/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/Documents/" 2>> "$errorLogFile"

    printf "\nbacking up Pictures ...\n"
    picFolder=$(readlink -f "/home/$1/Pictures")
    sudo -u "$1" rsync -aAXv --delete "$picFolder/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/Pictures/" 2>> "$errorLogFile"

    printf "\nbacking up Videos ...\n"
    vidFolder=$(readlink -f "/home/$1/Videos")
    sudo -u "$1" rsync -aAXv --delete "$vidFolder/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/Videos/" 2>> "$errorLogFile"

    printf "\nbacking up Music ...\n"
    sudo -u "$1" rsync -aAXv --delete "/home/$1/Music/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/Music/" 2>> "$errorLogFile"

    printf "\nbacking up 3D ...\n"
    sudo -u "$1" rsync -aAXv --delete "/home/$1/3D/" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/3D/" 2>> "$errorLogFile"
  else
    printf "homeDirBackup function needs exactly 1 argument with a non-empty string (got %s).\n" "$#"
  fi
}

printf "checking connection to the backup machine...\n"
if ping -q -4 -c 3 "$backupMachineIP" &> /dev/null; then

  printf "init backup to %s...\n" "$backupMachineIP"

  for dir in /home/*; do
    user=$(basename "$dir")
    # check if real user and if proper directory
    if id "$user" &> /dev/null && [ -d "$dir" ]; then

      printf "checking if %s's media drive (%s) is mounted...\n" "$user" "$MEDIA_DRIVE_UUID"
      if mountpoint "/run/media/$user/$MEDIA_DRIVE_UUID" &> /dev/null; then

        homeDirBackup "$user"

      else
        printf "media drive is NOT mounted. trying to mount drive...\n"
        sudo mkdir -p "/run/media/$user/$MEDIA_DRIVE_UUID"
        sudo mount -t ntfs-3g -o uid=1000,gid=1000 --uuid "$MEDIA_DRIVE_UUID" "/run/media/$user/$MEDIA_DRIVE_UUID"

        if mountpoint "/run/media/$user/$MEDIA_DRIVE_UUID" &> /dev/null; then
        
          homeDirBackup "$user"

        else
          printf "couldn't mount %s's media drive. skipping backup of %s's home directory...\n" "$user" "$user"
        fi

        if sudo umount "/run/media/$user/$MEDIA_DRIVE_UUID"; then
          sudo rm -rf "/run/media/$user/$MEDIA_DRIVE_UUID"
        else
          notify-send --urgency critical --app-name "Backup Script" "WARNING\!" "Couldn't unmount media drive.\nManual intervention needed\!"
        fi
      fi
    fi
  done

  printf "\n"
  echo "---------------------------------------------------------------------------------"
  printf "\nbacking up /root ...\n"
  sudo rsync -aAXv --delete --exclude="/.cache/" --exclude="/.local/share/fresh/file_states/" --exclude="/.local/state/fresh/logs/" --exclude="/.config/micro/buffers/" /root/ "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/root/" 2>> "$errorLogFile"

  printf "\n"
  echo "---------------------------------------------------------------------------------"
  printf "\nbacking up /etc ...\n"
  sudo rsync -aAXv --delete /etc/ "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/etc/" 2>> "$errorLogFile"

  printf "\n"
  echo "---------------------------------------------------------------------------------"
  printf "\nbacking up /boot ...\n"
  sudo rsync -aAXv --delete /boot/ "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/boot/" 2>> "$errorLogFile"

  printf "\n"
  echo "---------------------------------------------------------------------------------"
  printf "\nbacking up /usr/local ...\n"
  sudo rsync -aAXv --delete /usr/local/ "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/usr/local/" 2>> "$errorLogFile"

  exit 0

else
  printf "%s not reachable\n" "$backupMachineIP"
  exit 1
fi
