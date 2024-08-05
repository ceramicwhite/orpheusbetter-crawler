#!/bin/bash

echo "=== DOCKER OUTPUT: ==="
set -Eeuxo pipefail

# Ensure the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found at $CONFIG_FILE"
    exit 1
fi

# Run the script
while :
do
  until orpheusbetter --config "$CONFIG_FILE" https://orpheus.network/torrents.php?id=629615\&torrentid=1956460
  do
    echo "orpheusbetter failed, retrying in 15 seconds..."
    sleep 15 || true
  done
  if [ $RESET_INTERVAL -gt 0 ]; then
    echo "=== Going to sleep ==="
    sleep $RESET_INTERVAL || true
  else
    break
  fi
done

echo "=== DOCKER CONTAINER SHUTTING DOWN REGULARLY ==="