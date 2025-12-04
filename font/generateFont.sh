#!/usr/bin/env bash

# exit on errors and unset variables
set -eu

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
  echo "Error: The following required commands are not available: ${missing[*]}" >&2
  exit 1
fi

# variables
SCRIPT_LOCATION=$(dirname "$(readlink -f "$0")")

# download needed files
curl -L -o "/tmp/HackNerdFont-Regular.ttf" "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf"
curl -L -o "/tmp/Myna.ttf" "https://raw.githubusercontent.com/sayyadirfanali/Myna/main/fonts/Myna.ttf"

# run the fontforge script
/usr/bin/fontforge -script "replaceSymbols.pe" "$SCRIPT_LOCATION/dalailahner-base.sfd" "/tmp/HackNerdFont-Regular.ttf" "/tmp/Myna.ttf" "$SCRIPT_LOCATION/dalailahner.ttf"

# cleanup
rm "/tmp/HackNerdFont-Regular.ttf"
rm "/tmp/Myna.ttf"

exit 0
