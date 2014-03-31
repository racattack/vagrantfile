#!/bin/bash

THISFILE=$(basename "${0}")
THISDIR=${0%$THISFILE}
BASEDIR=${0%$THISFILE}

id grid 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo "user grid is required"
  echo "executing $BASEDIR/grid_oracle_user.sh"
  sh  "$BASEDIR/grid_oracle_user.sh"
fi

cp /media/stagefiles/99-oracle-asmdevices.rules /etc/udev/rules.d 
start_udev

#configure oracleasm
if [ -d /dev/oracleasm/disks ]; then
  echo "oracleasm configured"
else
  service oracleasm configure << EOF
  grid
  asmadmin
  y
  y
EOF

fi

i=1
for x in sdc sdd sde sdf; do
  blkid /dev/$x\*
  if [ $? -ne 0 ]; then
     if [ -b /dev/$x\1 ]; then
       echo "ignoring $x, partition found on /dev/$x"
     else
       echo "ok: no partition on /dev/$x"
       parted -s /dev/$x mklabel msdos
       parted -s /dev/$x unit MB mkpart primary 0% 100%
     fi
     if [ -b /dev/oracleasm/disks/ASMDISK$i ]; then
       echo "ignoring /dev/oracleasm/disks/ASMDISK$i already exists"
     else
       service oracleasm createdisk ASMDISK$i /dev/$x\1
     fi
  else
    echo "filesystem metadata found on $x, ignoring"
  fi
  let i=i+1
done
      
