#!/usr/bin/env bash
#set -e


TMPOUT=$(mktemp /tmp/tmpXXXXXXXXXX)

function shutdown() {
  tput cnorm
  rm $TMPOUT
}

trap shutdown EXIT

function cursorBack() {
  echo -en "\033[$1D"
}

function spinner() {
  local LC_CTYPE=C
  local LC_ALL=en_US.utf-8
  tput civis
  local CL="\e[2K"
  local spin="⣷⣯⣟⡿⢿⣻⣽⣾"
  local pid=$(jobs -p)
  local charwidth=1
  while kill -0 $pid 2>/dev/null; do
    local i=$(((i + charwidth) % ${#spin}))
    printf "%s" "$(tput setaf 2)${spin:i:charwidth}$(tput sgr0)"
    cursorBack 1
    sleep .1
  done
  printf "${CL}"
  tput cnorm
  wait $(jobs -p)
}

CCOUNT=$(chia peer -c full_node | grep 'FULL_NODE' | wc -l)
BEFORE="$CCOUNT"
echo "Connected to $BEFORE nodes."


function addNodes() {
  # Clear loading bar
  echo -ne "\r"
  IDUCERS=$(yq '.full_node.dns_servers[]' ~/.chia/mainnet/config/config.yaml)
  NPORT=$(yq '.full_node.port' ~/.chia/mainnet/config/config.yaml)
  while read DUCER; do
    DNODES=$(dig "$DUCER" | awk '{print $5}' | tail -n 30 | head -n+24)
    for IP in $DNODES; do
      nc -z -w1 "$IP" $NPORT && chia peer -a $IP:$NPORT full_node &>/dev/null
    done
  done < "$IDUCERS"
}

function printInfo() {
  addNodes >$TMPOUT &
  spinner
  cat $TMPOUT
}

echo -n "Adding nodes..."
printInfo

ACOUNT=$(chia peer -c full_node | grep 'FULL_NODE' | wc -l)
AFTER="$ACOUNT"
TOTAL=$((AFTER-BEFORE))

echo "Added $TOTAL."
echo "Connected to $AFTER nodes."