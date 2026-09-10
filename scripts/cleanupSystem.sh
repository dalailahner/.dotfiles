#!/usr/bin/env bash

YELLOW='\033[1;33m'
RED='\033[31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if command -v rg >/dev/null 2>&1; then
    GREP_CMD="rg"
else
    GREP_CMD="grep"
fi

KDECRASHDIR="$HOME/.cache/drkonqi/crashes"

echo -e "$GREEN"
echo "###############################################"
echo "#                START CLEANUP                #"
echo "###############################################"
echo -e "$NC"

echo -e "$YELLOW"
echo "-----------------------------------------------"
echo "--------  KDE crash directory cleanup  --------"
echo -e "$NC"
if [ -d "$KDECRASHDIR" ]; then
  if [ -n "$(find "$KDECRASHDIR" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
    echo -e "${GREEN}cleaning out ($KDECRASHDIR)${NC}"
    find "$KDECRASHDIR" -mindepth 1 -delete
  else
    echo -e "${GREEN}Directory exists but is already empty: ${KDECRASHDIR}${NC}"
  fi
else
  echo -e "${YELLOW}Directory does not exist: ${RED}${KDECRASHDIR}${NC}"
fi
echo ""

if command -v journalctl >/dev/null 2>&1; then
  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "-------------  clear  journalctl  -------------"
  echo -e "$NC"
  sudo journalctl --vacuum-time=7d
  echo ""
fi

if command -v yay >/dev/null 2>&1; then
  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "----------  remove orphan packages  -----------"
  echo -e "$NC"
  yay -Qdttq | yay -Rsn - --noconfirm
  echo ""
fi

if command -v yay >/dev/null 2>&1; then
  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "--------------  clear yay cache  --------------"
  echo -e "$NC"
  yay -Scc --noconfirm
  echo ""
fi

if command -v pnpm >/dev/null 2>&1; then
  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "-------------  prune pnpm store  --------------"
  echo -e "$NC"
  pnpm store prune
  echo ""
fi

echo ""
echo -e "$GREEN"
echo "###############################################"
echo "#           RUN CLAMAV AND RKHUNTER           #"
echo "###############################################"
echo -e "$NC"

if command -v clamdscan >/dev/null 2>&1 && command -v rkhunter >/dev/null 2>&1; then
  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "------------------  ClamAV  -------------------"
  echo -e "$NC"

  echo "starting clamav deamon..."
  sudo systemctl start clamav-daemon

  echo "running clamdscan..."
  clamav_output=$(clamdscan --fdpass --multiscan --infected ~/ 2>&1)

  if echo "$clamav_output" | $GREP_CMD -q -e "--- SCAN SUMMARY ---"; then
    echo "$clamav_output" | sed -n '/--- SCAN SUMMARY ---/,$p'
  else
    echo -e "${RED}[ ERROR ]: ClamAV scan failed to produce a summary!${NC}" >&2
    echo "--- full ClamAV output ---" >&2
    echo "$clamav_output" >&2
  fi
  echo "stopping clamav deamon..."
  sudo systemctl stop clamav-daemon
  echo ""

  echo -e "$YELLOW"
  echo "-----------------------------------------------"
  echo "-----------------  rkhunter  ------------------"
  echo -e "$NC"

  echo "killing steam before running rkhunter to prevent false positives..."
  pkill steam || true

  echo "running rkhunter..."
  rkhunter_output=$(sudo rkhunter --check --skip-keypress 2>&1)

  if echo "$rkhunter_output" | $GREP_CMD -q "System checks summary"; then
    echo "$rkhunter_output" | sed -n '/System checks summary/,$p'
  else
    echo -e "${RED}[ ERROR ]: rkhunter scan failed to produce a summary!${NC}" >&2
    echo "--- full rkhunter output ---" >&2
    echo "$rkhunter_output" >&2
  fi
else
  echo -e "${YELLOW}clamdscan/rkhunter not found. skipping scan...${NC}"
fi
echo ""

echo ""
echo -e "$GREEN"
echo "###############################################"
echo "#                CHECK  ERRORS                #"
echo "###############################################"
echo -e "$NC"

echo -e "$YELLOW"
echo "-----------------------------------------------"
echo "---------  failed systemctl entries  ----------"
echo -e "$NC"
systemctl --failed
echo ""

echo -e "$YELLOW"
echo "-----------------------------------------------"
echo "-------  journalctl  errors since boot  -------"
echo -e "$NC"
journalctl -b -p 3 -x --no-pager
echo ""

echo -e "$GREEN"
echo "###############################################"
echo "#                   DONE :)                   #"
echo "###############################################"
echo -e "$NC"
echo ""

exit 0
