#!/bin/sh
cd /opt/eos/build/install/bin

if [ -f '/opt/eos/data-dir/config.ini' ]; then
    echo "config taken from the host"
  else
    cp /config.ini /opt/eos/data-dir
fi

if [ -f '/opt/eos/data-dir/genesis.json' ]; then
    echo "genesis taken from the host"
  else
    cp /genesis.json /opt/eos/data-dir
fi

if [ -d '/opt/eos/data-dir/contracts' ]; then
    echo "contracts taken from the host"
  else
    cp -r /contracts /opt/eos/data-dir
fi

exec /opt/eos/build/install/bin/eosd --data-dir /opt/eos/data-dir --genesis-json /opt/eos/data-dir/genesis.json --config /opt/eos/data-dir/config.ini $@
