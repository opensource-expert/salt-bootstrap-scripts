#!/bin/bash

# edit /etc/salt/master
# file_roots
# hash_type: sha512

mkdir -p /srv/salt/

# add additional package
packages="vim git etckeeper locate"
# joe editor par défaut ??
packages_remove="joe"

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
}


# install sls files in /srv/salt/
clone_sls_files() {
  cd /srv/salt/
  git clone sls.git
}

