#!/usr/bin/env bash

# required commands
REQUIRED_COMMANDS=("curl" "dirname" "readlink" "/usr/bin/fontforge")

# missing commands
MISSING_COMMANDS=()

# check needed commands
for cmd in "${REQUIRED_COMMANDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    MISSING_COMMANDS+=("$cmd")
  fi
done

# exit if any are missing
if [ ${#MISSING_COMMANDS[@]} -ne 0 ]; then
  echo "Error: The following required commands are not available: ${MISSING_COMMANDS[*]}" >&2
  exit 1
fi

# variables
SCRIPT_LOCATION=$(dirname "$(readlink -f "$0")")

# download needed files
curl -L -o "/tmp/HackNerdFont-Regular.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/refs/heads/master/patched-fonts/Hack/HackNerdFont-Regular.ttf"
curl -L -o "/tmp/Myna-Regular.ttf" "https://github.com/sayyadirfanali/Myna/raw/refs/heads/main/fonts/Myna-Regular.ttf"

printf "\n"

# run the fontforge script
/usr/bin/fontforge -script "replaceSymbols.pe" "$SCRIPT_LOCATION/dalailahner-base.sfd" "/tmp/HackNerdFont-Regular.ttf" "/tmp/Myna-Regular.ttf" "$SCRIPT_LOCATION/dalailahner-new.ttf"

fontforgeExitCode=$?

printf "\n"

# cleanup
rm "/tmp/HackNerdFont-Regular.ttf"
rm "/tmp/Myna-Regular.ttf"

if [ $fontforgeExitCode -eq 0 ]; then
  printf "\n!!! IMPORTANT !!! rename dalailahner-new.ttf to dalailahner.ttf in order to use updated font.\n\nPress Enter to continue..."
  read -r
  exit 0
else
  echo "FontForge exited with error code: $fontforgeExitCode"
  exit 1
fi
