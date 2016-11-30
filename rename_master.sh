#!/bin/bash
#
# Usage: 
#  echo "saltmaser=new_master.fqdn" > bootstrap.conf
#  ./rename_master.sh  MINION

conf=bootstrap.conf
source $conf || { "echo config missing '$conf'"; exit 1; }
minion=$1

if [[ -z "$saltmaster" ]]
then
  echo "saltmaster empty"
  echo "echo \"saltmaser=new_master.fqdn\" > bootstrap.conf"
  exit 1
fi

tmp=/dev/shm/rename_master.$$
cat <<END > $tmp
ls /etc/salt/minion.d
echo "master: $saltmaster" > /etc/salt/minion.d/99-master-address.conf
cat /etc/salt/minion.d/99-master-address.conf
service salt-minion restart
END

ssh $minion < $tmp
rm -f $tmp
