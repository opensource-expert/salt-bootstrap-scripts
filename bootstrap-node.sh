#!/bin/bash

# add additional package
packages="vim git etckeeper locate"
# joe editor par défaut ??
packages_remove="joe"

apt_bootstrap() {
  apt-get update
  apt-get install -y $packages
  apt-get remove -y --purge $packages_remove
}

change_hostname() {
  # change hostname
  cp /etc/hostname /root/hostname.old
  cp /etc/hosts /root/hosts.old

  echo "$1" /etc/hostname
  grep -v $(cat /root/hostname.old) /root/hosts.old > /etc/hosts

  # apply
  invoke-rc.d hostname.sh start
  invoke-rc.d networking force-reload
}

