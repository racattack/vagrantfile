#!/bin/bash

THISFILE=$(basename "${0}")
THISDIR=${0%$THISFILE}

if [ -f /media/sf_12cR1/linuxamd64_12c_grid_1of2.zip ]; then
  [ -f /u01/stage/grid/sshsetup/sshUserSetup.sh ] || unzip -o /media/sf_12cR1/linuxamd64_12c_grid_1of2.zip -d /u01/stage grid/sshsetup/sshUserSetup.sh
else
  echo "this script requires linuxamd64_12c zip files in 12cR1 folder"
  exit 1
fi

if [ $# -lt 2 ]; then
  echo "this script require at least 2 arguments:"
  echo "${0} server1 server2 [..] [servern]"
  exit 1
fi

if [ ! -f ~grid/.ssh/id_rsa.pub ] && [ ! -f ~grid/.ssh/authorized_hosts ]; then
  expect $THISDIR/sshUserSetup.expect root root $@
  sudo -H -E -u grid expect $THISDIR/sshUserSetup.expect grid grid $@
else
  echo "on $HOSTNAME ssh configuration found for user grid, skipping.."
  echo "if you want to setup this user again, on $HOSTNAME delete /home/grid/.ssh and run this command again"
fi

if [ ! -f ~oracle/.ssh/id_rsa.pub ] && [ ! -f ~oracle/.ssh/authorized_hosts ]; then
  sudo -H -E -u oracle expect $THISDIR/sshUserSetup.expect oracle oracle $@
else
  echo "on $HOSTNAME ssh configuration found for user oracle, skipping.."
  echo "if you want to setup this user again, on $HOSTNAME delete /home/oracle/.ssh and run this command again"
fi
