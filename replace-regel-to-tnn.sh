#!/bin/bash
cd /tmp
rm Tnn-miner-amd64-v0.6.8.tar.gz
rm h-run.sh
rm h-config.sh
rm miner.conf
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/Tnn-miner-amd64-v0.6.8.tar.gz
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/h-run.sh
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/h-config.sh
wget --continue --tries=0 https://github.com/rakot7/dero-repo/raw/refs/heads/main/miner.conf
miner stop
tar -xf Tnn-miner-amd64-v0.6.8.tar.gz
rm /hive/miners/rigel/1.23.1/rigel
rm /hive/miners/rigel/1.23.1/miner.conf
rm /hive/miners/rigel/h-run.sh
rm /hive/miners/rigel/h-config.sh
cp tnn-miner-cpu /hive/miners/rigel/1.23.1/rigel
cp miner.conf /hive/miners/rigel/1.23.1/
cp h-run.sh /hive/miners/rigel/
cp h-config.sh /hive/miners/rigel/
miner start
