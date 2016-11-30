#!/bin/bash
#
# cleanup ~/.ssh/known_hosts with hostname and visit host once
#
# Usage: ./ssh_once.sh HOST
#

host=$1

if [[ -z "$host" ]]
then
    echo "need hostname"
    exit 1
fi

# remove for my known_hosts
sed -i -e "/$host/ d" ~/.ssh/known_hosts

if ! grep -q HashKnownHosts ~/.ssh/known_hosts
then
  echo "HashKnownHosts not in ~/.ssh/known_hosts"
fi

ssh $host -o StrictHostKeyChecking=no \
  "echo -e \"I'm logged as root \\033[1;32mOK\\033[0m\""
