#!/usr/bin/env bash

YELLOW='\033[1;33m'
RED='\033[31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

KDECRASHDIR="$HOME/.cache/drkonqi/crashes"

echo -e "$GREEN"
echo -e "###############################################"
echo -e "#                START CLEANUP                #"
echo -e "###############################################"
echo -e "$NC"

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "--------  KDE crash directory cleanup  --------"
echo -e "$NC"
if [ -d "$KDECRASHDIR" ]; then
  if [ "$(ls -A "$KDECRASHDIR" 2>/dev/null)" ]; then
    echo -e "$GREEN"
    echo -e "cleaning out ($KDECRASHDIR)"
    echo -e "$NC"
    rm -rf -- "${KDECRASHDIR:?}"/*
    rm -rf -- "$KDECRASHDIR"/.[!.]*
    rm -rf -- "$KDECRASHDIR"/..?*
  else
    echo -e "$GREEN"
    echo -e "Directory exists but is already empty: $KDECRASHDIR"
    echo -e "$NC"
  fi
else
  echo -e "$YELLOW"
  echo -e "Directory does not exist: $RED$KDECRASHDIR"
  echo -e "$NC"
fi

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "-------------  clear  journalctl  -------------"
echo -e "$NC"
sudo journalctl --vacuum-time=7d
echo ""

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "----------  remove orphan packages  -----------"
echo -e "$NC"
yay -Qdttq | yay -Rsn - --noconfirm
echo ""

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "--------------  clear yay cache  --------------"
echo -e "$NC"
yay -Scc --noconfirm
echo ""

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "-------------  prune pnpm store  --------------"
echo -e "$NC"
pnpm store prune
echo ""

echo ""
echo -e "$GREEN"
echo -e "###############################################"
echo -e "#                CHECK  ERRORS                #"
echo -e "###############################################"
echo -e "$NC"

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "---------  failed systemctl entries  ----------"
echo -e "$NC"
systemctl --failed
echo ""

echo -e "$YELLOW"
echo -e "-----------------------------------------------"
echo -e "-------  journalctl  errors since boot  -------"
echo -e "$NC"
journalctl -b -p 3 -x --no-pager
echo ""

echo -e "$GREEN"
echo -e "###############################################"
echo -e "#                   DONE :)                   #"
echo -e "###############################################"
echo -e "$NC"
