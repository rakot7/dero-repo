#!/usr/bin/env bash

[[ `ps aux | grep "./rigel" | grep -v grep | wc -l` != 0 ]] &&
  echo -e "${RED}$MINER_NAME miner is already running${NOCOLOR}" &&
  exit 1

cd $MINER_DIR/$MINER_VER

./rigel $(< ./miner.conf) # --api-bind 127.0.0.1:${MINER_API_PORT} --log-file $MINER_LOG_BASENAME.log

