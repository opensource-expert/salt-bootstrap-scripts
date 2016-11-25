#!/bin/bash
#
# bootstrap-master.sh
#
# Usage: ./bootstrap-master.sh

# edit /etc/salt/master
# file_roots
# hash_type: sha512

mkdir -p /srv/salt/

# add additional package
packages="vim git etckeeper locate dnsutils"
# joe editor par défaut ??
packages_remove="joe"
mydomain=yourdomain.com

# edit minion
# def master

change_hostname() {

  # change hostname
  # change hosts
  # change /etc/salt/minion_id == hostname

  # apply
  invoke-rc.d hostname.sh start
  invoke-rc.d networking force-reload
}


add_root_facilities() {
  # .alias
  # .bashrc
  # EDITOR=vim
  git config --global alias.st status
  git config --global alias.ci commit
  # .ssh/config
}


# install sls files in /srv/salt/
clone_sls_files() {
  cd /srv/salt/
  git clone sls.git
}

update_etc_hosts() {
  # records some remote server in /etc/hosts
  # /etc/hosts format
  # 10.0.0.1 saltmastrer.yourdomain.com saltmastrer
  for h in dns0 web0 db0 mta0
  do
    fqdn=$h.$mydomain
    echo "$(dig +short $fqdn) $fqdn $h"
  done >> /etc/hosts
}
