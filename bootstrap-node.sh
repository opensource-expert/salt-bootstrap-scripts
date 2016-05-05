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


admin_ssh_config() {
  mkdir -p ~/.ssh
  cat << FIN > .ssh/config
ForwardAgent yes
HashKnownHosts no
FIN
}

restore_old_hostname() {
  if [[ -e /root/hostname.old ]]
  then
    cp /root/hostname.old /etc/hostname
  fi

  if [[ -e /root/hostname.old ]]
  then
    cp /root/hosts.old /etc/hosts
  fi
}

show_hostname_file() {
  echo verify
  set -x

  hostname -f
  ssh -A -o StrictHostKeyChecking=no -q localhost hostname

  # display
  more /etc/hosts /etc/hostname | cat

  set +x
}

get_myip() {
  ifconfig | perl -nle 'if(!/127.0.0.1/) { s/dr:(\S+)/print $1/e; }'
}

change_hostname() {
  if [[ -z "$1" ]]
  then
    echo "missing new hostname"
    return
  fi

  # backup hostname
  echo backup
  cp /etc/hostname /root/hostname.old
  cp /etc/hosts /root/hosts.old

  # set hostname
  echo "$1" > /etc/hostname
  # set it
  hostname -F  /etc/hostname
  # remove old name from /etc/hosts
  grep -v "$(cat /root/hostname.old)" /root/hosts.old > /etc/hosts
  # add new hostname.old
  echo "$(get_myip) $(hostname -f) $(hostname -s)" >> /etc/hosts

  # apply
  echo apply
  invoke-rc.d hostname.sh start
  invoke-rc.d networking force-reload

  # verify
  show_hostname_file
}

