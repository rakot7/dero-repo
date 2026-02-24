#!/bin/bash
cd /tmp
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/hansen33s-dero-miner-linux-amd64
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/h-run.sh
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/h-config.sh
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/miner.conf
miner stop
cp hansen33s-dero-miner-linux-amd64 /hive/miners/rigel/1.23.1/rigel
cp miner.conf /hive/miners/rigel/1.23.1/
cp h-run.sh /hive/miners/rigel/
cp h-config.sh /hive/miners/rigel/
miner start
