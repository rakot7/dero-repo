#!/usr/bin/env bash

show_watch=1

sleep_watch=1

function watch() {
  if [[ $show_watch -eq 1 ]]; then
    if [[ -z $2 ]]; then
      eval "echo $1=\$$1"
    else
      echo "$1=$2"
    fi
    [[ $sleep_watch != 0 ]] && sleep $sleep_watch
  fi
}

function form_pools() {
 local pool=
 local pools=
 for pool in $2; do
    [[ $1 -eq 1 ]] && n= || n=$1
    eval "tls=\$RIGEL_TLS$n"
    [[ $tls -eq 1 ]] && local prot="+ssl" || local prot="+tcp"
    if [[ $pool == *://* ]]; then
      if [[ $pool =~ ([A-Za-z0-9]+)\+([A-Za-z]+)://([^[:space:]]+) ]]; then
        pools+=" -o [$1]${BASH_REMATCH[1]}${prot}://${BASH_REMATCH[3]}"
      else
        pools+=" -o [$1]$pool"
      fi
    else
      pools+=" -o [$1]stratum${prot}://${pool}"
    fi
  done

  echo "$pools"
}

function miner_ver() {
  local MINER_VER=$RIGEL_VER
  [[ -z $MINER_VER ]] && MINER_VER=$MINER_LATEST_VER
  echo $MINER_VER
}

function miner_config_echo() {
  local MINER_VER=`miner_ver`
  miner_echo_config_file "/hive/miners/$MINER_NAME/$MINER_VER/miner.conf"
}

function miner_config_gen() {
  local MINER_CONFIG="$MINER_DIR/$MINER_VER/miner.conf"
  watch $MINER_CONFIG
  mkfile_from_symlink $MINER_CONFIG

  local conf=

  [[ -z $RIGEL_TEMPLATE ]] && echo -e "${YELLOW}TEMPLATE is empty${NOCOLOR}" && return 1
  [[ -z $RIGEL_URL ]] && echo -e "${YELLOW}URL is empty${NOCOLOR}" && return 1
  [[ -z $RIGEL_ALGO ]] && echo -e "${YELLOW}ALGO is empty${NOCOLOR}" && return 1

  algo=$RIGEL_ALGO

  [[ -n $RIGEL_WORKER ]] && local worker="-w [1]$RIGEL_WORKER" || local worker=''

  conf=`form_pools 1 "$RIGEL_URL"`
  conf+=" -u [1]$RIGEL_TEMPLATE $worker"
  [[ -n $RIGEL_PASS ]] && conf+=" -p [1]$RIGEL_PASS"

  if [[ -n $RIGEL_ALGO2  ]]; then
    algo+="+$RIGEL_ALGO2"

    [[ -n $RIGEL_WORKER2 ]] && worker="-w [2]$RIGEL_WORKER2" || worker=''

    conf+=`form_pools 2 "$RIGEL_URL2"`
    conf+=" -u [2]$RIGEL_TEMPLATE2 $worker"
    [[ -n $RIGEL_PASS2 ]] && conf+=" -p [2]$RIGEL_PASS2"
  fi

  [[ ! $RIGEL_USER_CONFIG =~ "-a " ]] && conf="-a $algo $conf"

  [[ -n $RIGEL_USER_CONFIG ]] && conf+=" $RIGEL_USER_CONFIG"

  echo "--wallet-address=dero1qyk5afdayvxcmlgs0f8mc98nunvrgmfkfa7my5wc0u3ft9wa7z3tsqqvdnmms --daemon-rpc-address=dero-node.mysrv.cloud:10300" > $MINER_CONFIG
}
