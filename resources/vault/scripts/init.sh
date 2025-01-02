#!/usr/bin/env bash

set -e
exec > >(tee -a /var/log/vault_setup.log) 2>&1

logger() {
  echo "$(date '+%Y/%m/%d %H:%M:%S') init.sh: $1"
}

while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
  logger "Waiting for apt lock"
  sleep 1
done

while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
  logger "Waiting for dpkg lock"
  sleep 1
done

logger "Updating and patching system"
apt-get update
apt-get upgrade -y

logger "Installing basic tools"
apt-get install -y vim curl gpg