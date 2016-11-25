#!/bin/bash
#
# bootstrap-master.sh
#
# Usage: source bootstrap-master.sh
# exec function you need

# edit /etc/salt/master
# file_roots
# hash_type: sha512

mkdir -p /srv/salt/

# add additional package
packages="vim git etckeeper locate dnsutils salt-master"
# joe editor par défaut ??
packages_remove="joe"
mydomain=yourdomain.com

# load functions
source $scriptdir/bootstrap-minion.sh

loadconf

add_root_facilities() {
  # .alias
  touch ~/.alias
  # .bashrc
  # EDITOR=vim
  cat << 'EOF' >> ~/.bashrc
. ~/.alias
export EDITOR=vim
PATH=$HOME/bin:$PATH
HISTFILESIZE=5000
HISTSIZE=50000
EOF
  # .ssh/config done in bootstrap-minion.sh

  git config --global alias.st status
  git config --global alias.ci commit
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

