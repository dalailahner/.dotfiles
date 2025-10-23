#!/usr/bin/env bash

### IMPORTANT:
### $backupMachineIP & $MEDIA_DRIVE_UUID are an environment variables that must be set in /etc/profile or /etc/environment

# exit on errors and unset variables
set -eu

errorLogFile="$HOME/backupErrorLog.txt"
echo -n "ssh username: "
read -r SSHusername

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
	  printf "\nbacking up $1's home directory...\n"
		excludePaths=("Documents" "Pictures" "Videos" "Music" "3D" ".cache" ".local/share/Trash" ".var" ".local/share/klipper" ".local/share/Steam" ".local/share/pnpm" ".wine/drive_c/users/dalailahner/AppData/Local/Temp" ".config/vesktop/sessionData" ".config/micro/buffers")
    excludeListArr=()
    for folder in "${excludePaths[@]}"; do
        excludeListArr+=(--exclude="/home/$1/$folder")
    done
    sudo -u "$1" rsync -aAXv --delete "${excludeListArr[@]}" /home "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/" 2>> "$errorLogFile"

		printf "\nbacking up Documents ...\n"
		sudo -u "$1" rsync -aAXv --delete "/home/$1/Documents" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/" 2>> "$errorLogFile"

		printf "\nbacking up Pictures ...\n"
		picFolder=$(readlink -f "/home/$1/Pictures")
		sudo -u "$1" rsync -aAXv --delete "$picFolder" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/" 2>> "$errorLogFile"

		printf "\nbacking up Videos ...\n"
		vidFolder=$(readlink -f "/home/$1/Videos")
		sudo -u "$1" rsync -aAXv --delete "$vidFolder" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/" 2>> "$errorLogFile"

		printf "\nbacking up Music ...\n"
		sudo -u "$1" rsync -aAXv --delete "/home/$1/Music" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/" 2>> "$errorLogFile"

		printf "\nbacking up 3D ...\n"
		sudo -u "$1" rsync -aAXv --delete "/home/$1/3D" "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/media/" 2>> "$errorLogFile"
	else
		printf "homeDirBackup function needs exactly 1 argument with a non-empty string (got $#).\n"
	fi
}

printf "checking connection to the backup machine...\n"
if ping -q -4 -c 3 "$backupMachineIP" &> /dev/null; then

	printf "init backup to $backupMachineIP...\n"

	for dir in /home/*; do
		user=$(basename "$dir")
		# check if real user and if proper directory
		if id "$user" &> /dev/null && [ -d "$dir" ]; then

			printf "checking if $user's media drive ($MEDIA_DRIVE_UUID) is mounted...\n"
			if mountpoint "/run/media/$user/$MEDIA_DRIVE_UUID" &> /dev/null; then

				homeDirBackup "$user"

			else
				printf "media drive is NOT mounted. trying to mount drive...\n"
				sudo mkdir -p "/run/media/$user/$MEDIA_DRIVE_UUID"
				sudo mount -t ntfs-3g -o uid=1000,gid=1000 --uuid "$MEDIA_DRIVE_UUID" "/run/media/$user/$MEDIA_DRIVE_UUID"

				if mountpoint "/run/media/$user/$MEDIA_DRIVE_UUID" &> /dev/null; then
				
					homeDirBackup "$user"

				else
					printf "couldn't mount $user's media drive. skipping backup of $user's home directory...\n"
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
	sudo rsync -aAXv --delete --exclude="/root/.cache" --exclude="/root/.config/micro/buffers" /root "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/" 2>> "$errorLogFile"

	printf "\n"
	echo "---------------------------------------------------------------------------------"
	printf "\nbacking up /etc ...\n"
	sudo rsync -aAXv --delete /etc "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/" 2>> "$errorLogFile"

	printf "\n"
	echo "---------------------------------------------------------------------------------"
	printf "\nbacking up /boot ...\n"
	sudo rsync -aAXv --delete /boot "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/" 2>> "$errorLogFile"

	printf "\n"
	echo "---------------------------------------------------------------------------------"
	printf "\nbacking up /usr/local ...\n"
	sudo rsync -aAXv --delete /usr/local "$SSHusername@$backupMachineIP:/mnt/MAIN/NAS/BACKUPS/archlinux/usr/" 2>> "$errorLogFile"

	exit 0

else
	printf "$backupMachineIP not reachable\n"
	exit 1
fi
